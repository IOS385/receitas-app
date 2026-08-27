import 'dart:io';

// `hide`: drift exporta `isNull`/`isNotNull` top-level deprecados que
// colidem com os matchers homonimos do package:matcher.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
  });

  tearDown(() async => db.close());

  test('abre no schema 2', () {
    expect(db.schemaVersion, 2);
  });

  test('migracao v1 -> v2 poe foto_path sem perder o que ela tinha', () async {
    // Ela pode ja ter o APK v1 instalado com dados. Se a migracao falhar, o
    // app nao abre — e o dado dela e o unico que nao da para regerar.
    // A drift avisa "created the database class multiple times" aqui. E o que
    // o teste faz de proposito: fecha a v1 e reabre para a migracao rodar. As
    // duas instancias nunca coexistem — o aviso e falso positivo.
    final pasta = await Directory.systemTemp.createTemp('refeicoes_mig');
    addTearDown(() => pasta.delete(recursive: true));
    final arquivo = File('${pasta.path}/refeicoes.sqlite');

    // Rebaixa um banco novo para o formato v1: tira a coluna e volta o
    // user_version que a drift le para decidir se migra.
    final antigo = AppDatabase(NativeDatabase(arquivo));
    await antigo.into(antigo.combos).insert(CombosCompanion.insert(
          nome: 'Combo que ela criou',
          tipo: TipoCombo.refeicao,
          origem: const Value('usuario'),
        ));
    await antigo.customStatement('ALTER TABLE combos DROP COLUMN foto_path');
    await antigo.customStatement('PRAGMA user_version = 1');
    await antigo.close();

    // Reabre: a drift ve 1 < 2 e roda o onUpgrade.
    final novo = AppDatabase(NativeDatabase(arquivo));
    addTearDown(novo.close);
    final combos = await novo.select(novo.combos).get();

    expect(combos, hasLength(1), reason: 'a migracao nao pode apagar linha');
    expect(combos.single.nome, 'Combo que ela criou');
    expect(combos.single.origem, 'usuario');
    expect(combos.single.fotoPath, isNull,
        reason: 'coluna nova entra nula; a foto chega na proxima semente');

    final versao = await novo.customSelect('PRAGMA user_version').getSingle();
    expect(versao.data.values.single, 2);
  });

  test('grava e le um alimento com enums', () async {
    final id = await db.into(db.alimentos).insert(AlimentosCompanion.insert(
          nome: 'Arroz branco cozido',
          kcal100g: 128,
          carboidratoG: 28.1,
          proteinaG: 2.5,
          gorduraG: 0.2,
          fibraG: 1.6,
          sodioMg: 1,
          secaoMercado: SecaoMercado.mercearia,
          unidadeCompra: UnidadeCompra.kg,
        ));

    final lido = await (db.select(db.alimentos)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    expect(lido.nome, 'Arroz branco cozido');
    expect(lido.secaoMercado, SecaoMercado.mercearia);
    expect(lido.unidadeCompra, UnidadeCompra.kg);
    expect(lido.tacoCodigo, isNull);
  });

  test('DataPura vai e volta como texto ISO', () async {
    final combo = await db.into(db.combos).insert(
        CombosCompanion.insert(nome: 'Almoco teste', tipo: TipoCombo.refeicao));

    await db.into(db.overridesCombo).insert(OverridesComboCompanion.insert(
          data: const DataPura('2026-09-04'),
          slot: SlotRefeicao.almoco,
          comboId: combo,
        ));

    final lido = await db.select(db.overridesCombo).getSingle();
    expect(lido.data, const DataPura('2026-09-04'));
    expect(lido.data.iso, '2026-09-04');
  });

  test('chave primaria composta impede duplicata de override', () async {
    final combo = await db.into(db.combos).insert(
        CombosCompanion.insert(nome: 'X', tipo: TipoCombo.refeicao));

    Future<void> gravar() =>
        db.into(db.overridesCombo).insert(OverridesComboCompanion.insert(
              data: const DataPura('2026-09-04'),
              slot: SlotRefeicao.almoco,
              comboId: combo,
            ));

    await gravar();
    await expectLater(gravar(), throwsA(isA<Exception>()));
  });

  test('receitaNovaId nula significa componente removido', () async {
    final r = await db.into(db.receitas).insert(ReceitasCompanion.insert(
        nome: 'Salada', categoria: CategoriaReceita.salada));

    await db.into(db.overridesComponente).insert(
        OverridesComponenteCompanion.insert(
          data: const DataPura('2026-09-04'),
          slot: SlotRefeicao.almoco,
          receitaOriginalId: r,
        ));

    final lido = await db.select(db.overridesComponente).getSingle();
    expect(lido.receitaNovaId, isNull);
  });

  test('chave estrangeira esta ligada', () async {
    await expectLater(
      db.into(db.comboReceitas).insert(ComboReceitasCompanion.insert(
            comboId: 999,
            receitaId: 999,
            ordem: 0,
          )),
      throwsA(isA<Exception>()),
    );
  });
}
