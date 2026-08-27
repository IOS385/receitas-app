import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Banco em memória já semeado, com o ciclo começando em 2026-09-01 e tamanho 4
/// (a semente desta fase só tem 4 dias).
Future<AppDatabase> bancoDeTeste() async {
  final db = AppDatabase(DatabaseConnection(
    NativeDatabase.memory(),
    closeStreamsSynchronously: true,
  ));
  await carregarSemente(db, lerAsset: lerSementeDoDisco, versao: 1);
  final config = RepoConfig(db);
  await config.definir('data_inicio_ciclo', '2026-09-01');
  await config.definir('tamanho_ciclo', '4');
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
