import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_mercado.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

void main() {
  late AppDatabase db;
  late RepoMercado mercado;

  setUp(() async {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final config = RepoConfig(db);
    await config.definir('data_inicio_ciclo', '2026-09-01');
    // Sem definir o tamanho: quem o define e a semente, derivando do
    // ciclo.json. Ver divergencia-de-harness-esconde-bug.
    mercado = RepoMercado(db, RepoPlano(db, config));
  });
  tearDown(() async => db.close());

  test('gera lista de um dia com itens', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final itens = await mercado.itens(id);
    expect(itens, isNotEmpty);
    expect(itens.every((i) => i.quantidadeG > 0), isTrue);
  });

  test('uma semana soma mais que um dia', () async {
    final umDia = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final semana = await mercado.gerar(
        const DataPura('2026-09-01'), const DataPura('2026-09-07'));

    final gDia = (await mercado.itens(umDia))
        .fold<double>(0, (a, i) => a + i.quantidadeG);
    final gSemana = (await mercado.itens(semana))
        .fold<double>(0, (a, i) => a + i.quantidadeG);

    expect(gSemana, greaterThan(gDia));
  });

  test('cada alimento aparece uma vez so na lista', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-01'), const DataPura('2026-09-07'));
    final itens = await mercado.itens(id);
    final ids = itens.map((i) => i.alimentoId).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('sal a gosto nao entra na lista', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final itens = await mercado.itens(id);
    final sal = (await db.select(db.alimentos).get())
        .firstWhere((a) => a.nome == 'Sal');
    expect(itens.any((i) => i.alimentoId == sal.id), isFalse);
  });

  test('marcar item persiste', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final primeiro = (await mercado.itens(id)).first;

    await mercado.marcar(id, primeiro.alimentoId, true);

    final relido = (await mercado.itens(id))
        .firstWhere((i) => i.alimentoId == primeiro.alimentoId);
    expect(relido.marcado, isTrue);
  });

  test('gerar de novo cria lista nova, nao sobrescreve', () async {
    final a = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final b = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));

    expect(a, isNot(b));
    expect(await db.select(db.listasCompra).get(), hasLength(2));
  });

  test('ultimaLista devolve a mais recente', () async {
    await mercado.gerar(
        const DataPura('2026-09-01'), const DataPura('2026-09-01'));
    final ultima = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));

    expect((await mercado.ultimaLista())!.id, ultima);
  });
}
