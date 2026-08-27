import 'package:drift/drift.dart';

import '../domain/mercado.dart';
import '../domain/modelos.dart';
import 'app_database.dart';
import 'repo_plano.dart';

class RepoMercado {
  final AppDatabase db;
  final RepoPlano plano;

  const RepoMercado(this.db, this.plano);

  /// Expande o intervalo dia a dia, agrega e congela a lista.
  ///
  /// Materializa de propósito (spec D6): ela marca itens dentro do mercado ao
  /// longo de minutos, e a lista não pode se mexer se o plano mudar no meio.
  Future<int> gerar(DataPura de, DataPura ate) async {
    final linhas = <LinhaIngrediente>[];

    var cursor = de.comoDateTime;
    final fim = ate.comoDateTime;
    while (!cursor.isAfter(fim)) {
      final dia = await plano.dia(DataPura.de(cursor));
      for (final refeicao in dia.refeicoes) {
        for (final componente in refeicao.componentes) {
          for (final ing in componente.ingredientes) {
            linhas.add(LinhaIngrediente(
              alimentoId: ing.alimentoId,
              unidade: ing.unidade,
              quantidade: ing.quantidade,
            ));
          }
        }
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    final conversoes = <int, Map<Unidade, double>>{};
    for (final c in await db.select(db.conversoes).get()) {
      conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
    }
    final alimentos = await db.select(db.alimentos).get();

    final itens = agregarMercado(
      linhas: linhas,
      conversoes: conversoes,
      secoes: {for (final a in alimentos) a.id: a.secaoMercado},
      unidadesCompra: {for (final a in alimentos) a.id: a.unidadeCompra},
    );

    return db.transaction(() async {
      final listaId = await db.into(db.listasCompra).insert(
          ListasCompraCompanion.insert(
              dataInicio: de, dataFim: ate, criadaEm: DateTime.now()));

      for (final i in itens) {
        await db.into(db.listaCompraItens).insert(
            ListaCompraItensCompanion.insert(
                listaId: listaId,
                alimentoId: i.alimentoId,
                quantidadeG: i.gramas));
      }
      return listaId;
    });
  }

  Future<ListaCompra?> ultimaLista() => (db.select(db.listasCompra)
        ..orderBy([
          // criadaEm sozinho não é suficiente: o drift guarda DateTime como
          // segundos unix por padrão (sem milissegundos), então duas
          // chamadas de gerar() no mesmo segundo empatam. `id` desempata de
          // forma determinística porque é autoincrement.
          (t) => OrderingTerm(expression: t.criadaEm, mode: OrderingMode.desc),
          (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
        ])
        ..limit(1))
      .getSingleOrNull();

  Future<List<ListaCompraItem>> itens(int listaId) =>
      (db.select(db.listaCompraItens)
            ..where((t) => t.listaId.equals(listaId)))
          .get();

  Future<void> marcar(int listaId, int alimentoId, bool marcado) =>
      (db.update(db.listaCompraItens)
            ..where((t) =>
                t.listaId.equals(listaId) & t.alimentoId.equals(alimentoId)))
          .write(ListaCompraItensCompanion(marcado: Value(marcado)));
}
