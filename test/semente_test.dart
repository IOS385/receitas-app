import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

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
    expect(mapa['tamanho_ciclo'], '33');
    expect(mapa['data_inicio_ciclo'], isNotEmpty);
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
