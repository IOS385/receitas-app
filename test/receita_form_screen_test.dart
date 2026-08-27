import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/presentation/receitas/receita_form_screen.dart';
import 'package:refeicoes_app/presentation/receitas/receitas_provider.dart';
import 'package:refeicoes_app/presentation/receitas/receitas_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester, {int? id}) async {
    telaDeCelular(tester);
    await tester.pumpWidget(
        envolver(ReceitaFormScreen(receitaId: id), db: db));
    await tester.pumpAndSettle();
  }

  testWidgets('novo comeca vazio e sem botao de excluir', (tester) async {
    await abrir(tester);

    expect(find.text('Nova receita'), findsOneWidget);
    expect(find.byTooltip('Excluir'), findsNothing);
    expect(find.text('Adicionar ingrediente'), findsOneWidget);
  });

  testWidgets('editar carrega os dados da receita', (tester) async {
    await abrir(tester, id: 3);

    expect(find.text('Editar receita'), findsOneWidget);
    expect(find.text('Picadinho de carne com legumes'), findsOneWidget);
    expect(find.text('35 min'), findsOneWidget);
    expect(find.text('1 porção'), findsOneWidget);
    expect(find.text('Patinho cru'), findsOneWidget);
    expect(find.byTooltip('Excluir'), findsOneWidget);
  });

  testWidgets('painel de nutricao e travado e explica de onde vem',
      (tester) async {
    await abrir(tester, id: 3);

    expect(
      find.textContaining('não dá pra digitar à mão'),
      findsOneWidget,
    );
    // nao existe campo de texto para caloria
    final campos = tester.widgetList<TextField>(find.byType(TextField));
    for (final c in campos) {
      expect(c.decoration?.hintText, isNot(contains('kcal')));
    }
  });

  testWidgets('contador de rendimento nao desce abaixo de 1', (tester) async {
    await abrir(tester, id: 3);

    expect(find.text('1 porção'), findsOneWidget);
    // find.byTooltip acha o RawTooltip que envolve o botao, nao o IconButton
    // em si — o cast direto quebra. O predicate mira o IconButton de fato.
    final menos = find
        .byWidgetPredicate((w) => w is IconButton && w.tooltip == 'Menos')
        .first;
    expect(tester.widget<IconButton>(menos).onPressed, isNull);
  });

  testWidgets('subir o rendimento muda o rotulo para plural', (tester) async {
    await abrir(tester, id: 3);

    await tester.ensureVisible(find.byTooltip('Mais').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mais').first);
    await tester.pumpAndSettle();
    expect(find.text('2 porções'), findsOneWidget);
  });

  testWidgets('remover ingrediente tira a linha', (tester) async {
    await abrir(tester, id: 3);

    expect(find.text('Patinho cru'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Remover Patinho cru'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remover Patinho cru'));
    await tester.pumpAndSettle();
    expect(find.text('Patinho cru'), findsNothing);
  });

  testWidgets('macros do formulario mudam ao remover ingrediente',
      (tester) async {
    await abrir(tester, id: 3);

    // captura o kcal exibido antes
    final container = ProviderScope.containerOf(
        tester.element(find.byType(ReceitaFormScreen)));
    final antes = (await container.read(detalheProvider(3).future))
        .nutrientes
        .kcal
        .round();
    expect(find.text('$antes'), findsOneWidget,
        reason: 'o painel tem de comecar mostrando o calculado');

    // remove o ingrediente de maior peso calorico (patinho, o primeiro)
    await tester.ensureVisible(find.byTooltip('Remover Patinho cru'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remover Patinho cru'));
    await tester.pumpAndSettle();

    expect(find.text('$antes'), findsNothing,
        reason: 'o painel tem de recalcular ao mudar a lista — e a promessa da tela');
  });

  testWidgets('receita nova aparece no catalogo depois de salvar',
      (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(const ReceitasScreen(), db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nova receita'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Omelete simples');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Adicionar ingrediente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar ingrediente'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Ovo de galinha cru'),
      200,
      scrollable: find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Ovo de galinha cru').first);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Salvar receita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    // De volta no catalogo (25 receitas, ordem alfabetica): "Omelete simples"
    // fica no indice 17, fora do cacheExtent inicial da ListView.builder.
    // (Nao usar a busca aqui: digitar no campo mexe em filtroProvider, que o
    // catalogoProvider observa — isso forcaria um refetch por conta propria e
    // mascararia justamente a falta do invalidate que este teste prova.)
    await tester.scrollUntilVisible(
      find.text('Omelete simples'),
      300,
      scrollable: find.descendant(
        of: find.byWidgetPredicate(
            (w) => w is ListView && w.scrollDirection == Axis.vertical),
        matching: find.byType(Scrollable),
      ),
    );

    expect(find.text('Omelete simples'), findsOneWidget,
        reason: 'sem invalidate do catalogoProvider ela salva e nao aparece');
  });

  testWidgets('salvar sem nome avisa e nao grava', (tester) async {
    await abrir(tester);

    await tester.ensureVisible(find.text('Salvar receita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    expect(find.text('Dê um nome à receita.'), findsOneWidget);
    expect(await db.select(db.receitas).get(), hasLength(24));
  });

  testWidgets('salvar sem ingrediente avisa', (tester) async {
    await abrir(tester);

    await tester.enterText(find.byType(TextField).first, 'Omelete simples');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Salvar receita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    expect(find.text('Adicione pelo menos um ingrediente.'), findsOneWidget);
  });

  testWidgets('criar receita nova grava com origem usuario', (tester) async {
    await abrir(tester);

    await tester.enterText(find.byType(TextField).first, 'Omelete simples');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Adicionar ingrediente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar ingrediente'));
    await tester.pumpAndSettle();

    // A folha de alimentos e uma ListView.builder com 40 itens — "Ovo de
    // galinha cru" (ordem alfabetica, indice 28) fica fora do cacheExtent
    // inicial e precisa ser trazido por scroll antes de tocar.
    await tester.scrollUntilVisible(
      find.text('Ovo de galinha cru'),
      200,
      scrollable: find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('Ovo de galinha cru').first);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Salvar receita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    final nova = (await db.select(db.receitas).get())
        .firstWhere((r) => r.nome == 'Omelete simples');
    expect(nova.origem, 'usuario');
    expect(await db.select(db.receitas).get(), hasLength(25));
  });

  testWidgets('editar receita de semente transfere a posse', (tester) async {
    await abrir(tester, id: 1);

    await tester.enterText(
        find.byType(TextField).first, 'Arroz do jeito dela');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Salvar receita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(1)))
        .getSingle();
    expect(r.nome, 'Arroz do jeito dela');
    expect(r.origem, 'usuario');
  });

  testWidgets('excluir pede confirmacao e desativa', (tester) async {
    await abrir(tester, id: 22);

    await tester.tap(find.byTooltip('Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Excluir receita?'), findsOneWidget);

    await tester.tap(find.text('Excluir').last);
    await tester.pumpAndSettle();

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(22)))
        .getSingle();
    expect(r.ativa, isFalse);
  });

  testWidgets('cancelar a exclusao nao mexe em nada', (tester) async {
    await abrir(tester, id: 22);

    await tester.tap(find.byTooltip('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar').last);
    await tester.pumpAndSettle();

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(22)))
        .getSingle();
    expect(r.ativa, isTrue);
  });
}
