import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/database_provider.dart';
import 'package:refeicoes_app/domain/mercado.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/mercado/mercado_provider.dart';
import 'package:refeicoes_app/presentation/mercado/mercado_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(
      const MercadoScreen(),
      db: db,
      overrides: [
        intervaloProvider.overrideWith(() => _IntervaloFixo(
            const DataPura('2026-09-01'), const DataPura('2026-09-07'))),
      ],
    ));
    await tester.pumpAndSettle();
  }

  test('semanaDe devolve segunda a domingo', () {
    // 2026-09-04 e sexta
    final s = semanaDe(DateTime(2026, 9, 4));
    expect(s.de.iso, '2026-08-31'); // segunda
    expect(s.ate.iso, '2026-09-06'); // domingo
  });

  test('semanaDe num domingo nao pula a semana', () {
    final s = semanaDe(DateTime(2026, 9, 6));
    expect(s.de.iso, '2026-08-31');
    expect(s.ate.iso, '2026-09-06');
  });

  test('mesDe pega o primeiro e o ultimo dia', () {
    final m = mesDe(DateTime(2026, 9, 15));
    expect(m.de.iso, '2026-09-01');
    expect(m.ate.iso, '2026-09-30');
  });

  testWidgets('mostra o intervalo e as secoes', (tester) async {
    await abrir(tester);

    expect(find.text('LISTA DE MERCADO'), findsOneWidget);
    expect(find.text('1 – 7 de setembro'), findsOneWidget);
    expect(find.text('HORTIFRÚTI'), findsOneWidget);
    expect(find.text('AÇOUGUE'), findsOneWidget);
  });

  testWidgets('secoes saem na ordem do percurso do mercado', (tester) async {
    await abrir(tester);

    final hortifruti = tester.getTopLeft(find.text('HORTIFRÚTI')).dy;
    final acougue = tester.getTopLeft(find.text('AÇOUGUE')).dy;
    final mercearia = tester.getTopLeft(find.text('MERCEARIA')).dy;

    expect(hortifruti, lessThan(acougue));
    expect(acougue, lessThan(mercearia));
  });

  testWidgets('quantidade na tela e o valor convertido, nao so o sufixo',
      (tester) async {
    await abrir(tester);

    final container = ProviderScope.containerOf(
        tester.element(find.byType(MercadoScreen)));
    final lista = await container.read(listaMercadoProvider.future);
    final brutos =
        await container.read(repoMercadoProvider).itens(lista.listaId);
    final alimentos = await db.select(db.alimentos).get();
    final conversoes = await db.select(db.conversoes).get();

    // arroz e comprado por kg e numa semana passa de 1 kg; ovo, por unidade
    for (final nome in const ['Arroz branco cozido', 'Ovo de galinha cru']) {
      final a = alimentos.firstWhere((x) => x.nome == nome);
      final bruto = brutos.firstWhere((x) => x.alimentoId == a.id);
      double? gramasPorUnidade;
      for (final c in conversoes) {
        if (c.alimentoId == a.id && c.unidade == Unidade.unidade) {
          gramasPorUnidade = c.gramas;
        }
      }

      // Esperado derivado do banco pela MESMA funcao de dominio, sem numero
      // magico. A asserção antiga olhava so o sufixo: `999999 kg` passava.
      final esperado = formatarCompra(
        gramas: bruto.quantidadeG,
        compra: a.unidadeCompra,
        gramasPorUnidade: gramasPorUnidade,
      );
      final texto = medidaDeCompra(esperado.valor, esperado.unidade);

      final linha =
          find.ancestor(of: find.text(nome), matching: find.byType(Row)).first;
      expect(find.descendant(of: linha, matching: find.text(texto)),
          findsOneWidget,
          reason: '$nome tem de mostrar "$texto" na propria linha');
    }

    // e o sufixo continua sendo o da unidade de compra
    expect(lista.itens.firstWhere((i) => i.nome == 'Arroz branco cozido').unidade,
        'kg');
    expect(lista.itens.firstWhere((i) => i.nome == 'Ovo de galinha cru').unidade,
        'un');
  });

  testWidgets('sal a gosto nao aparece na lista', (tester) async {
    await abrir(tester);
    expect(find.text('Sal'), findsNothing);
  });

  testWidgets('progresso comeca em zero', (tester) async {
    await abrir(tester);
    expect(find.textContaining(RegExp(r'^0 de \d+$')), findsOneWidget);
  });

  testWidgets('marcar item risca e move o progresso', (tester) async {
    await abrir(tester);

    final antes = find.textContaining(RegExp(r'^0 de \d+$'));
    expect(antes, findsOneWidget);

    await tester.tap(find.text('Batata-doce crua'));
    await tester.pumpAndSettle();

    expect(find.textContaining(RegExp(r'^1 de \d+$')), findsOneWidget);

    final texto = tester.widget<Text>(find.text('Batata-doce crua'));
    expect(texto.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('marcar de novo desmarca', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('Batata-doce crua'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batata-doce crua'));
    await tester.pumpAndSettle();

    expect(find.textContaining(RegExp(r'^0 de \d+$')), findsOneWidget);
  });

  testWidgets('reabrir o app nao apaga as marcas nem acumula listas',
      (tester) async {
    await abrir(tester);

    await tester.tap(find.text('Batata-doce crua'));
    await tester.pumpAndSettle();
    expect(find.textContaining(RegExp(r'^1 de \d+$')), findsOneWidget);

    final listasAntes = (await db.select(db.listasCompra).get()).length;

    // Derruba a arvore inteira e monta um ProviderScope NOVO sobre o MESMO
    // banco: e o que o Android faz ao matar o app e ela reabrir depois.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await abrir(tester);

    expect(find.textContaining(RegExp(r'^1 de \d+$')), findsOneWidget,
        reason: 'a marca dela tem de sobreviver a reabertura do app (spec D6)');
    expect(await db.select(db.listasCompra).get(), hasLength(listasAntes),
        reason: 'gerar() a cada abertura acumularia lista_compra sem fim');
  });

  testWidgets('renderiza no escuro sem estourar', (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(
      const MercadoScreen(),
      db: db,
      brilho: Brightness.dark,
      overrides: [
        intervaloProvider.overrideWith(() => _IntervaloFixo(
            const DataPura('2026-09-01'), const DataPura('2026-09-07'))),
      ],
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

class _IntervaloFixo extends Intervalo {
  final DataPura de;
  final DataPura ate;
  _IntervaloFixo(this.de, this.ate);

  @override
  ({DataPura de, DataPura ate}) build() => (de: de, ate: ate);
}
