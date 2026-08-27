import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/presentation/receitas/receita_screen.dart';
import 'package:refeicoes_app/presentation/receitas/receitas_provider.dart';
import 'package:refeicoes_app/presentation/receitas/receitas_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrirCatalogo(WidgetTester tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(const ReceitasScreen(), db: db));
    await tester.pumpAndSettle();
  }

  group('catalogo', () {
    testWidgets('lista as receitas da semente', (tester) async {
      await abrirCatalogo(tester);

      expect(find.text('CATÁLOGO'), findsOneWidget);
      expect(find.text('24 receitas'), findsOneWidget);
      expect(find.text('Arroz branco'), findsOneWidget);
    });

    testWidgets('filtrar por categoria reduz a lista', (tester) async {
      await abrirCatalogo(tester);

      await tester.tap(find.text('Proteína'));
      await tester.pumpAndSettle();

      expect(find.text('Frango grelhado simples'), findsOneWidget);
      expect(find.text('Arroz branco'), findsNothing);
    });

    testWidgets('legume aparece com o rotulo da tela', (tester) async {
      await abrirCatalogo(tester);

      // A tira de filtros e horizontal e preguicosa: em viewport de celular
      // so os primeiros chips (Todas, Base, Proteina, Leguminosa) entram no
      // cacheExtent inicial. "Legume" (vegetal) fica fora ate rolar.
      await tester.scrollUntilVisible(
        find.text('Legume'),
        100,
        scrollable:
            find.ancestor(of: find.text('Todas'), matching: find.byType(Scrollable)),
      );

      expect(find.text('Legume'), findsWidgets);
      expect(find.text('Vegetal'), findsNothing);
    });

    testWidgets('buscar filtra por nome', (tester) async {
      await abrirCatalogo(tester);

      await tester.enterText(find.byType(TextField), 'tapioca');
      await tester.pumpAndSettle();

      expect(find.text('Tapioca com queijo coalho'), findsOneWidget);
      expect(find.text('Arroz branco'), findsNothing);
    });

    testWidgets('busca sem resultado mostra convite', (tester) async {
      await abrirCatalogo(tester);

      await tester.enterText(find.byType(TextField), 'zzzzz');
      await tester.pumpAndSettle();

      expect(find.textContaining('Nenhuma receita com esse filtro'),
          findsOneWidget);
    });

    testWidgets('tem botao de nova receita', (tester) async {
      await abrirCatalogo(tester);
      expect(find.byTooltip('Nova receita'), findsOneWidget);
    });
  });

  group('receita aberta', () {
    Future<void> abrirDetalhe(WidgetTester tester, int id) async {
      telaDeCelular(tester);
      await tester.pumpWidget(envolver(ReceitaScreen(receitaId: id), db: db));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra nome, tempo e rendimento', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('Picadinho de carne com legumes'), findsOneWidget);
      expect(find.text('35 min'), findsOneWidget);
      expect(find.text('rende 1'), findsOneWidget);
      expect(find.text('Proteína'), findsOneWidget);
    });

    testWidgets('macros vem calculados e rotulados como tal', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('KCAL'), findsOneWidget);
      expect(find.text('PROT G'), findsOneWidget);
      expect(find.text('calculado dos ingredientes · tabela TACO'),
          findsOneWidget);
    });

    testWidgets('macros da tela batem com o que o provider calcula',
        (tester) async {
      await abrirDetalhe(tester, 3);

      final container = ProviderScope.containerOf(
          tester.element(find.byType(ReceitaScreen)));
      final d = await container.read(detalheProvider(3).future);

      expect(d.nutrientes.kcal, greaterThan(0),
          reason: 'sanidade: a receita 3 tem ingredientes com caloria');
      expect(find.text('${d.nutrientes.kcal.round()}'), findsOneWidget,
          reason: 'o kcal exibido tem de ser o calculado, nao um placeholder');
      expect(find.text('${d.nutrientes.proteina.round()}'), findsOneWidget);
    });

    testWidgets('cada numero de passo fica ao lado do passo certo',
        (tester) async {
      await abrirDetalhe(tester, 3);

      final container = ProviderScope.containerOf(
          tester.element(find.byType(ReceitaScreen)));
      final d = await container.read(detalheProvider(3).future);

      // o Row do passo 1 tem de conter o texto do PRIMEIRO passo
      expect(
        find.ancestor(of: find.text('1'), matching: find.byType(Row)).evaluate(),
        isNotEmpty,
      );
      expect(
        find.descendant(
          of: find.ancestor(
              of: find.text(d.passos.first), matching: find.byType(Row)),
          matching: find.text('1'),
        ),
        findsOneWidget,
        reason: 'numeracao invertida passaria sem isto',
      );
      expect(
        find.descendant(
          of: find.ancestor(
              of: find.text(d.passos.last), matching: find.byType(Row)),
          matching: find.text('${d.passos.length}'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('lista ingredientes com quantidade e observacao',
        (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('Patinho cru'), findsOneWidget);
      expect(find.text('150 g'), findsWidgets);
      expect(find.text('Cebola crua (picada)'), findsOneWidget);
      expect(find.text('1 dente'), findsWidgets);
    });

    testWidgets('avisa sobre ingrediente a gosto', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('a gosto'), findsWidgets);
      expect(find.text('Sal e temperos a gosto não entram na conta.'),
          findsOneWidget);
    });

    testWidgets('receita sem a gosto nao mostra o aviso', (tester) async {
      await abrirDetalhe(tester, 6); // tapioca com queijo

      expect(find.text('Sal e temperos a gosto não entram na conta.'),
          findsNothing);
    });

    testWidgets('numera os passos do preparo', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('5 passos'), findsOneWidget);
      expect(find.text('1'), findsWidgets);
      expect(find.text('5'), findsWidgets);
      expect(
          find.textContaining('Tempere a carne com sal'), findsOneWidget);
    });

    testWidgets('receita inexistente mostra erro sem quebrar', (tester) async {
      await abrirDetalhe(tester, 9999);
      expect(find.textContaining('nao existe'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza no escuro sem estourar', (tester) async {
      telaDeCelular(tester);
      await tester.pumpWidget(envolver(const ReceitaScreen(receitaId: 3),
          db: db, brilho: Brightness.dark));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
