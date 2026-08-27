import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/database_provider.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/domain/nutricao.dart';
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

  /// Le o KCAL que o painel de macros esta desenhando de fato.
  int kcalNoPainel(WidgetTester tester) {
    final coluna =
        find.ancestor(of: find.text('KCAL'), matching: find.byType(Column)).first;
    final valor =
        find.descendant(of: coluna, matching: find.byType(Text)).first;
    return int.parse(tester.widget<Text>(valor).data!);
  }

  Future<ReceitaIngrediente> linhaDe(String alimento) async {
    final a = (await db.select(db.alimentos).get())
        .firstWhere((x) => x.nome == alimento);
    final linhas = await (db.select(db.receitaIngredientes)
          ..where((t) => t.receitaId.equals(3)))
        .get();
    return linhas.firstWhere((l) => l.alimentoId == a.id);
  }

  Future<void> salvar(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Salvar receita'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();
  }

  testWidgets('editar a quantidade de um ingrediente grava no banco',
      (tester) async {
    await abrir(tester, id: 3);

    final campo = find.byKey(const ValueKey('qtd-Patinho cru'));
    await tester.ensureVisible(campo);
    await tester.pumpAndSettle();
    // a quantidade e CAMPO, nao texto: ela precisa poder corrigir 150 para 250
    expect(tester.widget<TextField>(campo).controller?.text, '150');

    await tester.enterText(campo, '250');
    await tester.pumpAndSettle();
    await salvar(tester);

    expect((await linhaDe('Patinho cru')).quantidade, 250);
  });

  testWidgets('trocar a unidade de um ingrediente grava no banco',
      (tester) async {
    await abrir(tester, id: 3);

    expect((await linhaDe('Cenoura crua')).unidade, Unidade.g);

    final seletor = find.byKey(const ValueKey('unidade-Cenoura crua'));
    await tester.ensureVisible(seletor);
    await tester.pumpAndSettle();
    await tester.tap(seletor);
    await tester.pumpAndSettle();
    // 'un' so existe no menu aberto; `.last` protege se o botao fechado
    // tambem passar a mostra-lo
    await tester.tap(find.text('un').last);
    await tester.pumpAndSettle();
    await salvar(tester);

    expect((await linhaDe('Cenoura crua')).unidade, Unidade.unidade);
  });

  testWidgets('macros do formulario recalculam ao mudar a quantidade',
      (tester) async {
    await abrir(tester, id: 3);

    final container = ProviderScope.containerOf(
        tester.element(find.byType(ReceitaFormScreen)));
    final doRepositorio = (await container.read(detalheProvider(3).future))
        .nutrientes
        .kcal
        .round();
    final antes = kcalNoPainel(tester);
    expect(antes, doRepositorio,
        reason: 'o painel comeca mostrando o que o repositorio calcula');

    final campo = find.byKey(const ValueKey('qtd-Patinho cru'));
    await tester.ensureVisible(campo);
    await tester.pumpAndSettle();
    await tester.enterText(campo, '300'); // 150 g -> 300 g
    await tester.pumpAndSettle();

    expect(kcalNoPainel(tester), greaterThan(antes),
        reason: 'dobrar a carne tem de mover as macros — e a promessa da tela');
  });

  test('detalhe erra na hora mesmo sem o retry global', () async {
    // Container montado a mao, SEM o `retry: semRetry` que main() e envolver()
    // poem — como o teste de import de backup monta. E o que guarda o `retry`
    // local do detalheProvider: sem ele, o riverpod reexecuta 10x com backoff
    // e `.future` fica pendurado em vez de completar com erro.
    final patinho = (await db.select(db.alimentos).get())
        .firstWhere((a) => a.nome == 'Patinho cru');
    await (db.delete(db.conversoes)
          ..where((t) => t.alimentoId.equals(patinho.id)))
        .go();

    final c = ProviderContainer(overrides: [
      bancoProvider.overrideWithValue(db),
      semeaduraProvider.overrideWith((ref) async {}),
    ]);
    addTearDown(c.dispose);

    await expectLater(
      c.read(detalheProvider(3).future).timeout(const Duration(seconds: 2)),
      throwsA(isA<ConversaoAusente>()),
    );
  });

  testWidgets('a linha de ingrediente cabe em 412 dp em toda receita',
      (tester) async {
    // A linha ficou apertada com a quantidade e a unidade viraram campo:
    // nome + campo + dropdown + remover. Overflow de RenderFlex reprova aqui.
    telaDeCelular(tester);
    final ids = (await db.select(db.receitas).get()).map((r) => r.id).toList();
    expect(ids, hasLength(24));

    for (final id in ids) {
      // a Key troca o elemento, senao o State (e o initState) e reaproveitado
      await tester.pumpWidget(envolver(
          ReceitaFormScreen(key: ValueKey('form-$id'), receitaId: id),
          db: db));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull,
          reason: 'receita $id estourou o layout do formulario');
    }
  });

  testWidgets('painel de macros avisa em vez de mostrar zero calado',
      (tester) async {
    await abrir(tester, id: 3);
    expect(kcalNoPainel(tester), greaterThan(0));

    // Patinho so tem conversao para grama: trocar para 'un' faz `emGramas`
    // estourar de proposito (nutricao.dart:5-9).
    final seletor = find.byKey(const ValueKey('unidade-Patinho cru'));
    await tester.ensureVisible(seletor);
    await tester.pumpAndSettle();
    await tester.tap(seletor);
    await tester.pumpAndSettle();
    await tester.tap(find.text('un').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Não foi possível calcular'), findsOneWidget,
        reason: 'o painel tem de dizer que nao deu, nao mostrar zero');
    expect(find.text('KCAL'), findsNothing,
        reason: '0 KCAL calado e o que faz ela salvar receita quebrada');
  });

  testWidgets('carregamento que falha mostra erro e Voltar, nao spinner eterno',
      (tester) async {
    // apaga a conversao base do patinho: detalheProvider(3) passa a estourar
    final patinho = (await db.select(db.alimentos).get())
        .firstWhere((a) => a.nome == 'Patinho cru');
    await (db.delete(db.conversoes)
          ..where((t) => t.alimentoId.equals(patinho.id)))
        .go();

    telaDeCelular(tester);
    await tester.pumpWidget(envolver(
      Builder(
        builder: (ctx) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(
                builder: (_) => const ReceitaFormScreen(receitaId: 3))),
            child: const Text('abrir form'),
          ),
        ),
      ),
      db: db,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('abrir form'));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing,
        reason: 'sem branch de erro a tela gira para sempre');
    expect(find.text('Não foi possível abrir esta receita.'), findsOneWidget);
    expect(find.textContaining('Falta a conversão de unidade'), findsOneWidget);

    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('abrir form'), findsOneWidget,
        reason: 'o Voltar tem de tirar ela da tela de erro');
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
