import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_screen.dart';
import 'package:refeicoes_app/presentation/receitas/receita_screen.dart';
import 'package:refeicoes_app/presentation/widgets/foto_prato.dart';

import 'util_teste.dart';

void main() {
  // ------------------------------------------------------------ integridade
  //
  // Este bloco e o que protege o Plano 2: la sobem 66 fotos para 66 combos, e
  // um caminho errado no JSON so apareceria na tela dela.

  test('toda foto da semente existe no disco', () {
    final combos =
        jsonDecode(lerSementeDoDisco('combos.json')) as List<dynamic>;
    final semFoto = <int>[];

    for (final raw in combos) {
      final c = raw as Map<String, dynamic>;
      final foto = c['foto'] as String?;
      if (foto == null) {
        semFoto.add(c['id'] as int);
        continue;
      }
      expect(File(foto).existsSync(), isTrue,
          reason: 'combo ${c['id']} aponta para "$foto", que nao existe');
    }

    expect(semFoto, isEmpty,
        reason: 'combo sem foto nao quebra o app, mas os 66 tem');
  });

  test('nenhuma foto em assets/pratos ficou orfa', () {
    final combos =
        jsonDecode(lerSementeDoDisco('combos.json')) as List<dynamic>;
    final usadas = {
      for (final c in combos)
        if ((c as Map<String, dynamic>)['foto'] != null) c['foto'] as String
    };

    final noDisco = Directory('assets/pratos')
        .listSync()
        .whereType<File>()
        .map((f) => 'assets/pratos/${f.uri.pathSegments.last}')
        .where((n) => n.endsWith('.jpg'));

    expect(noDisco.toSet().difference(usadas), isEmpty,
        reason: 'foto no bundle que nenhum combo usa: peso morto no APK');
  });

  test('pubspec declara a pasta das fotos', () {
    // Sem esta linha o asset nao entra no APK e o errorBuilder assume em
    // producao — sintoma que nenhum teste de unidade veria.
    expect(File('pubspec.yaml').readAsStringSync(),
        contains('- assets/pratos/'));
  });

  test('a procedencia cobre toda foto do bundle', () {
    final proc = jsonDecode(File('assets/pratos/PROCEDENCIA.json')
        .readAsStringSync()) as Map<String, dynamic>;
    final noDisco = Directory('assets/pratos')
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last)
        .where((n) => n.endsWith('.jpg'));

    for (final nome in noDisco) {
      expect(proc.containsKey(nome), isTrue,
          reason: 'sem procedencia nao se sabe de qual foto dela "$nome" veio');
    }
  });

  // ------------------------------------------------------------------ tela

  group('na tela', () {
    late AppDatabase db;
    setUp(() async => db = await bancoDeTeste());
    tearDown(() async => db.close());

    /// Sexta 2026-09-04 — posicao 4 do ciclo, dia de semana, 1 porcao.
    const sexta = DataPura('2026-09-04');

    Future<void> abrir(WidgetTester tester) async {
      telaDeCelular(tester);
      await tester.pumpWidget(envolver(
        const HojeScreen(),
        db: db,
        overrides: [
          dataSelecionadaProvider.overrideWith(() => _DataFixa(sexta)),
        ],
      ));
      await tester.pumpAndSettle();
    }

    /// Nome do asset por tras de um [Image], atravessando o [ResizeImage] que
    /// o `cacheWidth` do [FotoPrato] cria.
    String nomeDoAsset(Image img) {
      final p = img.image;
      final alvo = p is ResizeImage ? p.imageProvider : p;
      return (alvo as AssetImage).assetName;
    }

    testWidgets('os quatro cartoes trazem a foto do combo', (tester) async {
      await abrir(tester);

      final imagens = tester
          .widgetList<Image>(find.descendant(
              of: find.byType(FotoPrato), matching: find.byType(Image)))
          .map(nomeDoAsset)
          .toList();

      // Quatro slots, e o espelho repete a foto do slot base.
      expect(imagens, hasLength(4));
      expect(imagens.toSet(), hasLength(2));
      for (final n in imagens) {
        expect(n, startsWith('assets/pratos/combo-'));
      }
    });

    testWidgets('a foto carrega de verdade — errorBuilder nao assume',
        (tester) async {
      await abrir(tester);
      // O icone so aparece quando o asset falha. Se o caminho no JSON, o
      // pubspec e o arquivo no disco nao fecharem, ele aparece aqui.
      expect(find.byIcon(Icons.restaurant_outlined), findsNothing);
    });

    testWidgets('a foto do cartao espelhado desbota junto com o aro',
        (tester) async {
      await abrir(tester);

      final opacidades = tester
          .widgetList<Opacity>(find.descendant(
              of: find.byType(FotoPrato), matching: find.byType(Opacity)))
          .map((o) => o.opacity)
          .toSet();

      // Dois cartoes originais em 1, dois espelhados desbotados.
      expect(opacidades, {1.0, .55});
    });

    testWidgets('receita aberta nao ganha foto emprestada do combo',
        (tester) async {
      await abrir(tester);
      // Com as fotos, o cartao do almoco nasce abaixo dos 915 dp: sem rolar
      // o tap erra e apenas AVISA.
      await tester.ensureVisible(find.text('Arroz branco').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arroz branco').first);
      await tester.pumpAndSettle();

      expect(find.byType(ReceitaScreen), findsOneWidget,
          reason: 'sem navegar, o resto do teste nao prova nada — a Hoje '
              'continua na arvore atras da rota');

      // A foto e do prato inteiro. Pendurar ela numa receita solta faria a
      // tela de "Arroz branco" mostrar carne, feijao e salada.
      expect(
          find.descendant(
              of: find.byType(ReceitaScreen), matching: find.byType(FotoPrato)),
          findsNothing);
    });
  });
}

class _DataFixa extends DataSelecionada {
  final DataPura fixa;
  _DataFixa(this.fixa);

  @override
  DataPura build() => fixa;
}
