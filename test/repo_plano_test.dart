import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

void main() {
  late AppDatabase db;
  late RepoPlano repo;

  // 2026-09-04 e sexta; 2026-09-05 sabado.
  const sexta = DataPura('2026-09-04');
  const sabado = DataPura('2026-09-05');

  setUp(() async {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final config = RepoConfig(db);
    // ciclo comeca em 2026-09-01 para o dia 4 cair na posicao 4
    await config.definir('data_inicio_ciclo', '2026-09-01');
    // a semente desta fase tem so 4 posicoes; sem isto, qualquer data que caia
    // na posicao 5+ estoura `StateError: ciclo sem combo`
    await config.definir('tamanho_ciclo', '4');
    repo = RepoPlano(db, config);
  });
  tearDown(() async => db.close());

  RefeicaoDoDia slotDe(DiaResolvido d, SlotRefeicao s) =>
      d.refeicoes.firstWhere((r) => r.slot == s);

  test('resolve os quatro slots do dia', () async {
    final d = await repo.dia(sexta);
    expect(d.posicao, 4);
    expect(d.refeicoes, hasLength(4));
  });

  test('sexta tem 1 porcao no almoco e 2 no jantar', () async {
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).porcoes, 1);
    expect(slotDe(d, SlotRefeicao.jantar).porcoes, 2);
  });

  test('sabado tem 2 porcoes em tudo', () async {
    final d = await repo.dia(sabado);
    for (final r in d.refeicoes) {
      expect(r.porcoes, 2, reason: '${r.slot}');
    }
  });

  test('jantar espelha o combo do almoco', () async {
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.jantar).comboId,
        slotDe(d, SlotRefeicao.almoco).comboId);
    expect(slotDe(d, SlotRefeicao.jantar).espelhoIntacto, isTrue);
  });

  test('o jantar de 2 porcoes dobra a quantidade do almoco', () async {
    final d = await repo.dia(sexta);
    final arrozAlmoco = slotDe(d, SlotRefeicao.almoco)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');
    final arrozJantar = slotDe(d, SlotRefeicao.jantar)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');

    final gAlmoco = arrozAlmoco.ingredientes
        .firstWhere((i) => i.nome == 'Arroz branco cozido')
        .quantidade;
    final gJantar = arrozJantar.ingredientes
        .firstWhere((i) => i.nome == 'Arroz branco cozido')
        .quantidade;

    expect(gJantar, gAlmoco * 2);
  });

  test('dente de alho arredonda para cima ao dobrar', () async {
    final d = await repo.dia(sexta);
    final arroz = slotDe(d, SlotRefeicao.jantar)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');
    final alho = arroz.ingredientes.firstWhere((i) => i.nome == 'Alho cru');
    expect(alho.quantidade, 2);
    expect(alho.unidade, Unidade.dente);
  });

  test('nutricao do dia soma as quatro refeicoes', () async {
    final d = await repo.dia(sexta);
    final soma = d.refeicoes
        .map((r) => r.nutrientes.kcal)
        .fold<double>(0, (a, b) => a + b);
    expect(d.total.kcal, closeTo(soma, 0.001));
    expect(d.total.kcal, greaterThan(0));
  });

  test('substituir o combo do almoco arrasta o jantar', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).comboId, 5);
    expect(slotDe(d, SlotRefeicao.jantar).comboId, 5);
  });

  test('substituir o jantar solta o espelho', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.jantar, comboId: 5);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).comboId, 8);
    expect(slotDe(d, SlotRefeicao.jantar).comboId, 5);
    expect(slotDe(d, SlotRefeicao.jantar).espelhoIntacto, isFalse);
  });

  test('substituir um componente troca so ele', () async {
    await repo.substituirComponente(
        data: sexta,
        slot: SlotRefeicao.almoco,
        receitaOriginalId: 3,
        receitaNovaId: 22);
    final d = await repo.dia(sexta);
    final nomes =
        slotDe(d, SlotRefeicao.almoco).componentes.map((c) => c.nome);
    expect(nomes, contains('Frango grelhado simples'));
    expect(nomes, isNot(contains('Picadinho de carne com legumes')));
    expect(nomes, contains('Arroz branco'));
  });

  test('componente com destino nulo some do prato', () async {
    await repo.substituirComponente(
        data: sexta,
        slot: SlotRefeicao.almoco,
        receitaOriginalId: 5,
        receitaNovaId: null);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).componentes, hasLength(4));
  });

  test('limparOverrides devolve o dia ao ciclo', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.jantar, comboId: 5);
    await repo.limparOverrides(sexta, SlotRefeicao.jantar);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.jantar).comboId, 8);
    expect(slotDe(d, SlotRefeicao.jantar).espelhoIntacto, isTrue);
  });

  test('diasEditados lista so os dias com substituicao', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);
    final editados = await repo.diasEditados(
        const DataPura('2026-09-01'), const DataPura('2026-09-30'));
    expect(editados, {sexta});
  });

  test('dia anterior ao inicio do ciclo resolve sem estourar', () async {
    final d = await repo.dia(const DataPura('2026-08-30'));
    expect(d.posicao, inInclusiveRange(1, 33));
    expect(d.refeicoes, hasLength(4));
  });

  test('nutricao do jantar dobra junto com a porcao', () async {
    final d = await repo.dia(sexta);
    final arrozAlmoco = slotDe(d, SlotRefeicao.almoco)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');
    final arrozJantar = slotDe(d, SlotRefeicao.jantar)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');

    expect(arrozAlmoco.nutrientes.kcal, greaterThan(0));
    expect(arrozJantar.nutrientes.kcal,
        closeTo(arrozAlmoco.nutrientes.kcal * 2, 1.0),
        reason: 'a nutricao tem de usar a quantidade ESCALADA, nao a crua');
  });

  test('componentes do combo vem na ordem cadastrada', () async {
    final d = await repo.dia(sexta);
    expect(
      slotDe(d, SlotRefeicao.almoco).componentes.map((c) => c.nome).toList(),
      [
        'Arroz branco',
        'Feijao carioca',
        'Picadinho de carne com legumes',
        'Batata-doce cozida e amassada',
        'Alface americana e pepino com molho de mostarda e mel',
      ],
      reason: 'a ordem do prato e significativa: base, leguminosa, proteina, legume, salada',
    );
  });

  test('diasEditados filtra pelo intervalo pedido', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);
    await repo.substituirCombo(
        data: const DataPura('2026-10-20'),
        slot: SlotRefeicao.almoco,
        comboId: 5);

    final setembro = await repo.diasEditados(
        const DataPura('2026-09-01'), const DataPura('2026-09-30'));
    expect(setembro, {sexta}, reason: 'outubro nao pode entrar');

    final ambos = await repo.diasEditados(
        const DataPura('2026-09-01'), const DataPura('2026-10-31'));
    expect(ambos, hasLength(2));
  });
}
