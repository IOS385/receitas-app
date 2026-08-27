import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/app.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/database_provider.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/presentation/tema/tema.dart';
// `Override` fica fora do barril principal do riverpod 3 (só em `misc.dart`,
// junto de `ProviderBase` etc. — ver riverpod-3.4.2/lib/misc.dart).
import 'package:riverpod/misc.dart' show Override;

String lerSementeDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

List<dynamic> _semente(String nome) =>
    jsonDecode(lerSementeDoDisco(nome)) as List<dynamic>;

/// Quantas linhas o JSON da semente tem.
///
/// Teste que crava o numero ("40 alimentos", "24 receitas") apodrece na
/// primeira mudanca de conteudo e obriga uma varredura de testes a cada
/// mudanca de dado. O invariante que interessa e outro: **o banco espelha a
/// semente**. Ao subir de 4 para 33 dias, 36 testes reprovaram so por isso.
int quantosNaSemente(String arquivo) => _semente(arquivo).length;

/// Tamanho do ciclo derivado do `ciclo.json` — a mesma derivacao que a
/// producao faz. Nunca escreva o tamanho a mao num teste: foi exatamente isso
/// que escondeu a aba Mercado nao abrindo.
int tamanhoDoCiclo() => _semente('ciclo.json')
    .map((e) => (e as Map<String, dynamic>)['posicao'] as int)
    .reduce((a, b) => a > b ? a : b);

/// Combo que a semente poe numa posicao e tipo do ciclo.
int comboDaSemente(int posicao, String tipo) => _semente('ciclo.json')
    .cast<Map<String, dynamic>>()
    .firstWhere((e) => e['posicao'] == posicao && e['tipo'] == tipo)['combo']
        as int;

/// Banco em memória já semeado, com o ciclo começando em 2026-09-01. O tamanho
/// vem da própria semente (4 nesta fase), nunca escrito à mão aqui.
Future<AppDatabase> bancoDeTeste() async {
  final db = AppDatabase(DatabaseConnection(
    NativeDatabase.memory(),
    closeStreamsSynchronously: true,
  ));
  await carregarSemente(db, lerAsset: lerSementeDoDisco, versao: 1);
  final config = RepoConfig(db);
  await config.definir('data_inicio_ciclo', '2026-09-01');
  // O tamanho NAO e definido aqui de proposito: quem o define e a semente,
  // derivando da maior posicao do ciclo.json. Foi um harness que definia esse
  // valor a mao que escondeu a aba Mercado nao abrindo — 244 testes verdes com
  // 4 enquanto a producao rodava com 33.
  return db;
}

/// Envolve um widget com tema, ProviderScope e o banco de teste já pronto.
Widget envolver(
  Widget child, {
  required AppDatabase db,
  List<Override> overrides = const [],
  Brightness brilho = Brightness.light,
}) {
  return ProviderScope(
    // A MESMA politica do main(): sem isto o teste roda com retry e o app
    // sem, e a divergencia esconde erro de provider (ver `semRetry`).
    retry: semRetry,
    overrides: [
      bancoProvider.overrideWithValue(db),
      semeaduraProvider.overrideWith((ref) async {}),
      ...overrides,
    ],
    child: MaterialApp(
      theme: brilho == Brightness.light ? temaClaro() : temaEscuro(),
      home: child,
    ),
  );
}

/// Ajusta a superficie de teste para um celular real (412×915 dp, densidade 3).
///
/// O padrao do `flutter_test` e 800×600 — mais BAIXO que qualquer aparelho, o
/// que empurra conteudo legitimo para fora da viewport e faz `tap()` errar em
/// silencio (avisa, mas nao falha). Chame no inicio de todo teste de tela.
void telaDeCelular(WidgetTester tester) {
  tester.view.physicalSize = const Size(412 * 3, 915 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
