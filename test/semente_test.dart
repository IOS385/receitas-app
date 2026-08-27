import 'dart:convert';
import 'dart:io';

// / do drift colidem com os do matcher neste arquivo.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_mercado.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/mercado/mercado_provider.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
  });
  tearDown(() async => db.close());

  test('carrega a semente inteira', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    expect(await db.select(db.alimentos).get(), hasLength(40));
    expect(await db.select(db.receitas).get(), hasLength(24));
    expect(await db.select(db.combos).get(), hasLength(8));
    expect(await db.select(db.cicloItens).get(), hasLength(8));
  });

  test('carregar duas vezes nao duplica', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    expect(await db.select(db.alimentos).get(), hasLength(40));
    expect(await db.select(db.combos).get(), hasLength(8));
  });

  test('grava as regras de porcao padrao', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final regras = await db.select(db.regrasPorcao).get();

    expect(regras, hasLength(8));
    final almocoUtil = regras.firstWhere(
        (r) => r.slot == SlotRefeicao.almoco && r.diaUtil);
    expect(almocoUtil.porcoes, 1);
    final jantarUtil = regras.firstWhere(
        (r) => r.slot == SlotRefeicao.jantar && r.diaUtil);
    expect(jantarUtil.porcoes, 2);
  });

  test('grava a versao e o tamanho do ciclo em config', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final linhas = await db.select(db.config).get();
    final mapa = {for (final l in linhas) l.chave: l.valor};

    expect(mapa['seed_version'], '1');
    expect(mapa['data_inicio_ciclo'], isNotEmpty);

    // O tamanho e DERIVADO do ciclo.json, nao cravado: gravar 33 com 4
    // posicoes cadastradas e crash garantido em qualquer posicao 5-33.
    final maiorPosicao = (jsonDecode(lerDoDisco('ciclo.json')) as List)
        .map((e) => (e as Map<String, dynamic>)['posicao'] as int)
        .reduce((a, b) => a > b ? a : b);
    expect(mapa['tamanho_ciclo'], '$maiorPosicao');
    expect(mapa['tamanho_ciclo'], '4',
        reason: 'a semente desta fase cadastra 4 dias de ciclo');
  });

  test('ciclo inteiro resolve sem override de tamanho', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final config = RepoConfig(db);
    await config.definir('data_inicio_ciclo', '2026-09-01');
    // NAO define tamanho_ciclo — usa o que a semente derivou
    final tamanho = await config.tamanhoCiclo();
    final repo = RepoPlano(db, config);

    for (var i = 0; i <= tamanho; i++) {
      final d = DataPura.de(DateTime.utc(2026, 9, 1).add(Duration(days: i)));
      await repo.dia(d); // nao pode estourar em nenhum dia do ciclo + 1
    }
  });

  test('mercado da semana corrente gera sem override de tamanho', () async {
    // O caminho exato de producao: sete dias CONSECUTIVOS a partir da data
    // real de hoje, com o tamanho de ciclo que a semente gravou. Sete
    // posicoes seguidas nunca caem todas dentro de {1,2,3,4}.
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final config = RepoConfig(db);
    final semana = semanaDe(DateTime.now());

    final listaId = await RepoMercado(db, RepoPlano(db, config))
        .gerar(semana.de, semana.ate);
    expect(listaId, greaterThan(0));
  });

  test('backup sem tamanho_ciclo nao reabre o crash do Mercado', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final config = RepoConfig(db);
    await config.definir('data_inicio_ciclo', '2026-09-01');

    // Um backup importado pode nao trazer a chave. O fallback tem de sair do
    // dado: com um literal 33 aqui, `resolverRefeicao` volta a estourar.
    await (db.delete(db.config)
          ..where((t) => t.chave.equals('tamanho_ciclo')))
        .go();
    expect(await config.ler('tamanho_ciclo'), isNull, reason: 'sanidade');

    final tamanho = await config.tamanhoCiclo();
    expect(tamanho, 4, reason: 'derivado da maior posicao em ciclo_itens');

    final repo = RepoPlano(db, config);
    for (var i = 0; i <= tamanho; i++) {
      final d = DataPura.de(DateTime.utc(2026, 9, 1).add(Duration(days: i)));
      await repo.dia(d); // nao pode estourar em nenhum dia do ciclo + 1
    }
  });

  test('mercado da semana gera com backup sem tamanho_ciclo', () async {
    // O sintoma do C1 pelo caminho de producao, agora vindo do fallback.
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    await (db.delete(db.config)
          ..where((t) => t.chave.equals('tamanho_ciclo')))
        .go();

    final config = RepoConfig(db);
    final semana = semanaDe(DateTime.now());
    final listaId = await RepoMercado(db, RepoPlano(db, config))
        .gerar(semana.de, semana.ate);
    expect(listaId, greaterThan(0));
  });

  test('ciclo vazio devolve tamanho 1, nao zero nem 33', () async {
    // Guarda do `?? 1`: MAX() sobre tabela vazia devolve uma linha com NULL,
    // e tamanho 0 faria `posicaoNoCiclo` dividir por zero.
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    await db.delete(db.cicloItens).go();
    await (db.delete(db.config)
          ..where((t) => t.chave.equals('tamanho_ciclo')))
        .go();

    expect(await RepoConfig(db).tamanhoCiclo(), 1);
  });

  test('nao sobrescreve receita que virou do usuario', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    await (db.update(db.receitas)..where((t) => t.id.equals(1))).write(
        const ReceitasCompanion(
            nome: Value('Arroz do jeito dela'), origem: Value('usuario')));

    await carregarSemente(db, lerAsset: lerDoDisco, versao: 2);

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(1)))
        .getSingle();
    expect(r.nome, 'Arroz do jeito dela');
  });

  test('todo alimento tem conversao para grama', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final alimentos = await db.select(db.alimentos).get();
    final conv = await db.select(db.conversoes).get();
    final comGrama = conv
        .where((c) => c.unidade == Unidade.g || c.unidade == Unidade.ml)
        .map((c) => c.alimentoId)
        .toSet();

    for (final a in alimentos) {
      expect(comGrama, contains(a.id), reason: '${a.nome} sem conversao base');
    }
  });

  test('alimento comprado por unidade tem conversao de unidade', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final porUnidade = (await db.select(db.alimentos).get())
        .where((a) => a.unidadeCompra == UnidadeCompra.unidade);
    final conv = await db.select(db.conversoes).get();
    final temUnidade = conv
        .where((c) => c.unidade == Unidade.unidade)
        .map((c) => c.alimentoId)
        .toSet();

    for (final a in porUnidade) {
      expect(temUnidade, contains(a.id), reason: '${a.nome} sem g por unidade');
    }
  });

  test('carregar duas vezes nao duplica tabelas filhas', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final ingredientes1 = (await db.select(db.receitaIngredientes).get()).length;
    final ligacoes1 = (await db.select(db.comboReceitas).get()).length;

    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    expect(ingredientes1, greaterThan(0), reason: 'sanidade: a 1a carga trouxe algo');
    expect(await db.select(db.receitaIngredientes).get(),
        hasLength(ingredientes1));
    expect(await db.select(db.comboReceitas).get(), hasLength(ligacoes1));
  });

  test('semente nao restaura ingrediente que o usuario apagou', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    // a receita 1 vira dela, e ela tira um ingrediente
    await (db.update(db.receitas)..where((t) => t.id.equals(1)))
        .write(const ReceitasCompanion(origem: Value('usuario')));
    await (db.delete(db.receitaIngredientes)
          ..where((t) => t.receitaId.equals(1) & t.ordem.equals(0)))
        .go();

    final depoisDaEdicao = (await (db.select(db.receitaIngredientes)
              ..where((t) => t.receitaId.equals(1)))
            .get())
        .length;

    await carregarSemente(db, lerAsset: lerDoDisco, versao: 2);

    final agora = (await (db.select(db.receitaIngredientes)
              ..where((t) => t.receitaId.equals(1)))
            .get())
        .length;
    expect(agora, depoisDaEdicao,
        reason: 'a semente nao pode ressuscitar ingrediente que ela apagou');
  });

  test('segunda carga nao reseta a data de inicio do ciclo', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    await (db.update(db.config)
          ..where((t) => t.chave.equals('data_inicio_ciclo')))
        .write(const ConfigCompanion(valor: Value('2020-01-01')));

    await carregarSemente(db, lerAsset: lerDoDisco, versao: 2);

    final mapa = {
      for (final l in await db.select(db.config).get()) l.chave: l.valor
    };
    expect(mapa['data_inicio_ciclo'], '2020-01-01',
        reason: 'atualizacao de semente nao pode resetar o ciclo dela');
    expect(mapa['seed_version'], '2',
        reason: 'mas seed_version sobrescreve — e a assimetria');
  });

  test('todo par (alimento, unidade) usado em receita tem conversao', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final conv = {
      for (final c in await db.select(db.conversoes).get())
        (c.alimentoId, c.unidade)
    };
    final alimentos = {
      for (final a in await db.select(db.alimentos).get()) a.id: a.nome
    };

    final faltando = <String>[];
    for (final i in await db.select(db.receitaIngredientes).get()) {
      if (unidadesSemMedida.contains(i.unidade)) continue;
      if (!conv.contains((i.alimentoId, i.unidade))) {
        faltando.add('receita ${i.receitaId}: '
            '${alimentos[i.alimentoId]} em ${i.unidade.name}');
      }
    }
    expect(faltando, isEmpty, reason: faltando.join('\n'));
  });

  test('todo json da semente e valido', () {
    for (final nome in const [
      'alimentos.json', 'conversoes.json', 'receitas.json',
      'combos.json', 'ciclo.json',
    ]) {
      expect(() => jsonDecode(lerDoDisco(nome)), returnsNormally,
          reason: nome);
    }
  });
}
