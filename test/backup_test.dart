import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/backup.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

import 'util_teste.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

AppDatabase novoBanco() => AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));

void main() {
  test('exporta json com cabecalho e tabelas', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final texto = await exportarJson(db);
    final mapa = jsonDecode(texto) as Map<String, dynamic>;

    expect(mapa['seed_version'], isNotNull);
    expect(mapa['exportado_em'], isNotNull);
    expect(mapa['tabelas'], isA<Map<String, dynamic>>());
    expect((mapa['tabelas'] as Map)['alimentos'], hasLength(quantosNaSemente('alimentos.json')));

    await db.close();
  });

  test('exportar e importar devolve o mesmo estado', () async {
    final origem = novoBanco();
    await carregarSemente(origem, lerAsset: lerDoDisco, versao: 1);
    await RepoPlano(origem, RepoConfig(origem)).substituirCombo(
        data: const DataPura('2026-09-04'),
        slot: SlotRefeicao.almoco,
        comboId: 5);

    final texto = await exportarJson(origem);

    final destino = novoBanco();
    await importarJson(destino, texto);

    expect(await destino.select(destino.alimentos).get(),
        hasLength(quantosNaSemente('alimentos.json')));
    expect(await destino.select(destino.receitas).get(),
        hasLength(quantosNaSemente('receitas.json')));

    final ov = await destino.select(destino.overridesCombo).getSingle();
    expect(ov.comboId, 5);
    expect(ov.data, const DataPura('2026-09-04'));

    await origem.close();
    await destino.close();
  });

  test('importar substitui o que estava la', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final texto = await exportarJson(db);

    await db.into(db.alimentos).insert(AlimentosCompanion.insert(
          nome: 'Alimento intruso',
          kcal100g: 1, carboidratoG: 1, proteinaG: 1,
          gorduraG: 1, fibraG: 1, sodioMg: 1,
          secaoMercado: SecaoMercado.mercearia,
          unidadeCompra: UnidadeCompra.kg,
        ));
    expect(await db.select(db.alimentos).get(), hasLength(quantosNaSemente('alimentos.json') + 1));

    await importarJson(db, texto);
    expect(await db.select(db.alimentos).get(), hasLength(quantosNaSemente('alimentos.json')));

    await db.close();
  });

  test('json malformado estoura em vez de apagar tudo', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    await expectLater(
        importarJson(db, '{ nao e json valido'), throwsA(isA<Exception>()));
    expect(await db.select(db.alimentos).get(), hasLength(quantosNaSemente('alimentos.json')));

    await db.close();
  });

  test('falha no meio do import reverte o delete', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final texto = await exportarJson(db);

    // JSON valido, mas com uma coluna que nao existe numa linha de receitas:
    // a falha acontece DEPOIS do DELETE de todas as tabelas.
    final mapa = jsonDecode(texto) as Map<String, dynamic>;
    (mapa['tabelas'] as Map)['receitas'][0]['coluna_que_nao_existe'] = 1;

    await expectLater(
        importarJson(db, jsonEncode(mapa)), throwsA(isA<Exception>()));

    expect(await db.select(db.alimentos).get(), hasLength(quantosNaSemente('alimentos.json')),
        reason: 'a transacao tem de reverter o delete que ja rodou');
    expect(await db.select(db.receitas).get(), hasLength(quantosNaSemente('receitas.json')));

    await db.close();
  });

  test('backup de formato incompativel e recusado', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final texto = await exportarJson(db);

    final mapa = jsonDecode(texto) as Map<String, dynamic>;
    mapa['formato'] = 999;

    await expectLater(
        importarJson(db, jsonEncode(mapa)), throwsA(isA<Exception>()));
    expect(await db.select(db.alimentos).get(), hasLength(quantosNaSemente('alimentos.json')));

    await db.close();
  });
}
