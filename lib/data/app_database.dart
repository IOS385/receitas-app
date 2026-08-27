import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/modelos.dart';
import 'conversores.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------- alimentos

@DataClassName('Alimento')
class Alimentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get tacoCodigo => text().nullable()();
  RealColumn get kcal100g => real()();
  RealColumn get carboidratoG => real()();
  RealColumn get proteinaG => real()();
  RealColumn get gorduraG => real()();
  RealColumn get fibraG => real()();
  RealColumn get sodioMg => real()();
  TextColumn get secaoMercado => textEnum<SecaoMercado>()();
  TextColumn get unidadeCompra => textEnum<UnidadeCompra>()();
}

@DataClassName('Conversao')
class Conversoes extends Table {
  IntColumn get alimentoId => integer().references(Alimentos, #id)();
  TextColumn get unidade => textEnum<Unidade>()();
  RealColumn get gramas => real()();

  @override
  Set<Column> get primaryKey => {alimentoId, unidade};
}

// ----------------------------------------------------------------- receitas

@DataClassName('Receita')
class Receitas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get categoria => textEnum<CategoriaReceita>()();
  IntColumn get rendimentoPorcoes => integer().withDefault(const Constant(1))();
  IntColumn get tempoPreparoMin => integer().withDefault(const Constant(0))();
  TextColumn get modoPreparo => text().withDefault(const Constant(''))();
  TextColumn get fotoPath => text().nullable()();
  TextColumn get origem => text().withDefault(const Constant('seed'))();
  BoolColumn get ativa => boolean().withDefault(const Constant(true))();
}

@DataClassName('ReceitaIngrediente')
class ReceitaIngredientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get receitaId => integer().references(Receitas, #id)();
  IntColumn get alimentoId => integer().references(Alimentos, #id)();
  IntColumn get ordem => integer()();
  RealColumn get quantidade => real()();
  TextColumn get unidade => textEnum<Unidade>()();
  TextColumn get observacao => text().nullable()();
}

// ------------------------------------------------------------ combos e ciclo

@DataClassName('Combo')
class Combos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get tipo => textEnum<TipoCombo>()();

  /// Asset com a foto do prato montado. A foto e do combo inteiro (o prato
  /// como ela ve na mesa), nao de uma receita solta: uma receita como "Arroz
  /// branco" nao tem foto propria e nunca tera. Nulo quando nao ha foto —
  /// combo que ela criar, por exemplo.
  TextColumn get fotoPath => text().nullable()();

  TextColumn get origem => text().withDefault(const Constant('seed'))();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
}

@DataClassName('ComboReceita')
class ComboReceitas extends Table {
  IntColumn get comboId => integer().references(Combos, #id)();
  IntColumn get receitaId => integer().references(Receitas, #id)();
  IntColumn get ordem => integer()();

  @override
  Set<Column> get primaryKey => {comboId, receitaId};
}

@DataClassName('CicloItem')
class CicloItens extends Table {
  IntColumn get posicao => integer()();
  TextColumn get tipoSlot => textEnum<TipoCombo>()();
  IntColumn get comboId => integer().references(Combos, #id)();

  @override
  Set<Column> get primaryKey => {posicao, tipoSlot};
}

// ------------------------------------------------------ config e excecoes

@DataClassName('ConfigLinha')
class Config extends Table {
  TextColumn get chave => text()();
  TextColumn get valor => text()();

  @override
  Set<Column> get primaryKey => {chave};
}

@DataClassName('RegraPorcao')
class RegrasPorcao extends Table {
  TextColumn get slot => textEnum<SlotRefeicao>()();
  BoolColumn get diaUtil => boolean()();
  IntColumn get porcoes => integer()();

  @override
  Set<Column> get primaryKey => {slot, diaUtil};
}

@DataClassName('OverrideCombo')
class OverridesCombo extends Table {
  TextColumn get data => text().map(const DataPuraConverter())();
  TextColumn get slot => textEnum<SlotRefeicao>()();
  IntColumn get comboId => integer().references(Combos, #id)();

  @override
  Set<Column> get primaryKey => {data, slot};
}

@DataClassName('OverrideComponente')
class OverridesComponente extends Table {
  TextColumn get data => text().map(const DataPuraConverter())();
  TextColumn get slot => textEnum<SlotRefeicao>()();
  IntColumn get receitaOriginalId => integer().references(Receitas, #id)();

  /// Nulo significa componente removido do prato, não ausência de regra.
  IntColumn get receitaNovaId => integer().nullable().references(Receitas, #id)();

  @override
  Set<Column> get primaryKey => {data, slot, receitaOriginalId};
}

// -------------------------------------------------------------- mercado

@DataClassName('ListaCompra')
class ListasCompra extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dataInicio => text().map(const DataPuraConverter())();
  TextColumn get dataFim => text().map(const DataPuraConverter())();
  DateTimeColumn get criadaEm => dateTime()();
}

@DataClassName('ListaCompraItem')
class ListaCompraItens extends Table {
  IntColumn get listaId => integer().references(ListasCompra, #id)();
  IntColumn get alimentoId => integer().references(Alimentos, #id)();
  RealColumn get quantidadeG => real()();
  BoolColumn get marcado => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {listaId, alimentoId};
}

// -------------------------------------------------------------- o banco

@DriftDatabase(tables: [
  Alimentos,
  Conversoes,
  Receitas,
  ReceitaIngredientes,
  Combos,
  ComboReceitas,
  CicloItens,
  Config,
  RegrasPorcao,
  OverridesCombo,
  OverridesComponente,
  ListasCompra,
  ListaCompraItens,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrir());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, de, para) async {
          // v2 — foto do prato montado no combo. Coluna nulavel, então banco
          // que já existe no aparelho dela sobrevive: as fotos entram na
          // próxima carga da semente.
          if (de < 2) await m.addColumn(combos, combos.fotoPath);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _abrir() {
    return LazyDatabase(() async {
      final pasta = await getApplicationDocumentsDirectory();
      final arquivo = File(p.join(pasta.path, 'refeicoes.sqlite'));
      return NativeDatabase.createInBackground(arquivo);
    });
  }
}
