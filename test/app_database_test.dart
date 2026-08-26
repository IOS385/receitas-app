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

  test('abre no schema 1', () {
    expect(db.schemaVersion, 1);
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
