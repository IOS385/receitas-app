import 'package:drift/drift.dart';

import '../domain/modelos.dart';
import 'app_database.dart';

class RepoReceitas {
  final AppDatabase db;
  const RepoReceitas(this.db);

  Future<List<Receita>> listar({
    CategoriaReceita? categoria,
    String? busca,
  }) {
    final q = db.select(db.receitas)..where((t) => t.ativa.equals(true));
    if (categoria != null) {
      q.where((t) => t.categoria.equalsValue(categoria));
    }
    if (busca != null && busca.trim().isNotEmpty) {
      q.where((t) => t.nome.lower().contains(busca.trim().toLowerCase()));
    }
    q.orderBy([(t) => OrderingTerm(expression: t.nome)]);
    return q.get();
  }

  Future<Receita?> porId(int id) =>
      (db.select(db.receitas)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<ReceitaIngrediente>> ingredientesDe(int receitaId) =>
      (db.select(db.receitaIngredientes)
            ..where((t) => t.receitaId.equals(receitaId))
            ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
          .get();

  /// Salva a receita e substitui a lista de ingredientes inteira.
  ///
  /// Toda escrita marca `origem = 'usuario'`: a partir daí a semente nunca
  /// mais sobrescreve esta linha (spec seção 12).
  Future<int> salvar({
    int? id,
    required String nome,
    required CategoriaReceita categoria,
    required int rendimentoPorcoes,
    required int tempoPreparoMin,
    required String modoPreparo,
    required List<({int alimentoId, double quantidade, Unidade unidade, String? observacao})>
        ingredientes,
  }) async {
    return db.transaction(() async {
      final companion = ReceitasCompanion(
        id: id == null ? const Value.absent() : Value(id),
        nome: Value(nome),
        categoria: Value(categoria),
        rendimentoPorcoes: Value(rendimentoPorcoes),
        tempoPreparoMin: Value(tempoPreparoMin),
        modoPreparo: Value(modoPreparo),
        origem: const Value('usuario'),
      );

      final receitaId = id == null
          ? await db.into(db.receitas).insert(companion)
          : await () async {
              await db.into(db.receitas).insertOnConflictUpdate(companion);
              return id;
            }();

      await (db.delete(db.receitaIngredientes)
            ..where((t) => t.receitaId.equals(receitaId)))
          .go();

      for (var i = 0; i < ingredientes.length; i++) {
        final ing = ingredientes[i];
        await db
            .into(db.receitaIngredientes)
            .insert(ReceitaIngredientesCompanion.insert(
              receitaId: receitaId,
              alimentoId: ing.alimentoId,
              ordem: i,
              quantidade: ing.quantidade,
              unidade: ing.unidade,
              observacao: Value(ing.observacao),
            ));
      }
      return receitaId;
    });
  }

  /// Desativa em vez de apagar: a receita pode estar em combo de dia passado.
  Future<void> excluir(int id) =>
      (db.update(db.receitas)..where((t) => t.id.equals(id)))
          .write(const ReceitasCompanion(ativa: Value(false)));

  Future<List<Combo>> combosDoTipo(TipoCombo tipo) =>
      (db.select(db.combos)
            ..where((t) => t.tipo.equalsValue(tipo) & t.ativo.equals(true))
            ..orderBy([(t) => OrderingTerm(expression: t.nome)]))
          .get();

  Future<List<Alimento>> alimentos() =>
      (db.select(db.alimentos)
            ..orderBy([(t) => OrderingTerm(expression: t.nome)]))
          .get();
}
