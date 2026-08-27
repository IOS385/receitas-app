import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;
  late RepoPlano plano;
  const sexta = DataPura('2026-09-04');

  setUp(() async {
    db = await bancoDeTeste();
    plano = RepoPlano(db, RepoConfig(db));
  });
  tearDown(() async => db.close());

  Future<void> abrirFolha(WidgetTester tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(
      const HojeScreen(),
      db: db,
      overrides: [
        dataSelecionadaProvider.overrideWith(() => _DataFixa(sexta)),
      ],
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SUBSTITUIR').last);
    await tester.pumpAndSettle();
  }

  RefeicaoDoDia slot(DiaResolvido d, SlotRefeicao s) =>
      d.refeicoes.firstWhere((r) => r.slot == s);

  testWidgets('folha traz os dois niveis', (tester) async {
    await abrirFolha(tester);

    expect(find.text('Trocar a refeição inteira'), findsOneWidget);
    expect(find.text('Ou trocar só um componente'), findsOneWidget);
    expect(find.text('Substituir almoço'), findsOneWidget);
  });

  testWidgets('folha diz que a troca vale so neste dia', (tester) async {
    await abrirFolha(tester);
    expect(find.textContaining('só neste dia'), findsOneWidget);
    expect(find.textContaining('sexta, 4 de setembro'), findsOneWidget);
  });

  testWidgets('nao oferece o combo que ja esta no dia', (tester) async {
    final antes = await plano.dia(sexta);
    final atual = slot(antes, SlotRefeicao.almoco).comboNome;

    await abrirFolha(tester);

    // o nome aparece no cartao de tras, mas nao como opcao dentro da folha
    expect(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text(atual),
      ),
      findsNothing,
    );
  });

  testWidgets('escolher outro combo grava o override', (tester) async {
    await abrirFolha(tester);

    final combos = await db.select(db.combos).get();
    final atual = slot(await plano.dia(sexta), SlotRefeicao.almoco).comboId;
    final nomeAntigo =
        slot(await plano.dia(sexta), SlotRefeicao.almoco).comboNome;
    final outro = combos.firstWhere(
        (c) => c.tipo == TipoCombo.refeicao && c.id != atual);

    await tester.tap(find.text(outro.nome));
    await tester.pumpAndSettle();

    final depois = await plano.dia(sexta);
    expect(slot(depois, SlotRefeicao.almoco).comboId, outro.id);
    // o espelho segue intacto: o jantar acompanha
    expect(slot(depois, SlotRefeicao.jantar).comboId, outro.id);

    // E a TELA: sem `ref.invalidate(diaProvider)` a gravacao acontece mas o
    // cartao continua mostrando o combo antigo. Estas duas asserções são o
    // unico guarda-corpo disso em toda a suite.
    expect(find.text(outro.nome), findsWidgets,
        reason: 'almoco e jantar (espelhado) tem de mostrar o combo novo');
    expect(find.text(nomeAntigo), findsNothing,
        reason: 'o combo antigo nao pode sobrar na tela');
  });

  testWidgets('trocar componente abre a lista da mesma categoria',
      (tester) async {
    await abrirFolha(tester);

    // "Picadinho de carne com legumes" tambem aparece nos cartoes de tras
    // (almoco e o jantar espelhado) — escopa a folha aberta para desambiguar.
    await tester.tap(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text('Picadinho de carne com legumes'),
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('Trocar Picadinho'), findsOneWidget);
    // a folha do componente e a ultima (mais recente) BottomSheet na pilha —
    // a de cima (a de refeicao inteira) continua por baixo, ainda montada.
    final folhaComponente = find.byType(BottomSheet).last;
    expect(
      find.descendant(
          of: folhaComponente, matching: find.text('Frango grelhado simples')),
      findsOneWidget,
    );
    expect(
      find.descendant(
          of: folhaComponente, matching: find.text('Tirar do prato hoje')),
      findsOneWidget,
    );
    // nao oferece componente de outra categoria — "Arroz branco" ja aparece
    // nos cartoes de tras e na propria folha de refeicao (e componente do
    // combo do dia), entao a checagem tem de mirar so a folha de componente.
    expect(
      find.descendant(
          of: folhaComponente, matching: find.text('Arroz branco')),
      findsNothing,
    );
  });

  testWidgets('trocar componente grava e reflete no jantar', (tester) async {
    await abrirFolha(tester);
    await tester.tap(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text('Picadinho de carne com legumes'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Frango grelhado simples'));
    await tester.pumpAndSettle();

    final d = await plano.dia(sexta);
    expect(
      slot(d, SlotRefeicao.almoco).componentes.map((c) => c.nome),
      contains('Frango grelhado simples'),
    );
    expect(
      slot(d, SlotRefeicao.jantar).componentes.map((c) => c.nome),
      contains('Frango grelhado simples'),
    );

    // a TELA tem de refletir: sem o invalidate o cartao segue com a carne
    expect(find.text('Frango grelhado simples'), findsWidgets,
        reason: 'o componente novo tem de aparecer no cartao');
  });

  testWidgets('tirar do prato remove o componente', (tester) async {
    final antes =
        slot(await plano.dia(sexta), SlotRefeicao.almoco).componentes.length;
    const nomeRemovido = 'Picadinho de carne com legumes';

    await abrirFolha(tester);
    await tester.tap(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.text(nomeRemovido),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tirar do prato hoje'));
    await tester.pumpAndSettle();

    final depois =
        slot(await plano.dia(sexta), SlotRefeicao.almoco).componentes.length;
    expect(depois, antes - 1);

    // a TELA: sem o invalidate o componente removido continua na tela
    // (o jantar espelha o almoco, entao some dos dois cartoes)
    expect(find.text(nomeRemovido), findsNothing,
        reason: 'o componente tirado nao pode continuar na tela');
  });

  testWidgets('voltar ao plano original limpa os overrides', (tester) async {
    // capturado ANTES de qualquer substituicao: o nome que o ciclo devolve
    final nomeOriginal =
        slot(await plano.dia(sexta), SlotRefeicao.almoco).comboNome;

    await plano.substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);

    await abrirFolha(tester);
    // tela estreita + combo com nomes longos empurra o botao para fora da
    // area visivel da folha rolavel — precisa trazer para a vista antes.
    await tester.ensureVisible(find.text('Voltar ao plano original'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voltar ao plano original'));
    await tester.pumpAndSettle();

    expect(await db.select(db.overridesCombo).get(), isEmpty);

    // a TELA: sem o invalidate o dia parece continuar substituido, mesmo
    // com o banco ja limpo — e ela conclui que o botao nao funcionou
    expect(find.text(nomeOriginal), findsWidgets,
        reason: 'o combo do ciclo tem de voltar a aparecer na tela');
  });
}

class _DataFixa extends DataSelecionada {
  final DataPura inicial;
  _DataFixa(this.inicial);

  @override
  DataPura build() => inicial;
}
