import 'package:drift/drift.dart';

import '../domain/modelos.dart';
import '../domain/porcoes.dart';
import 'app_database.dart';

class RepoConfig {
  final AppDatabase db;
  const RepoConfig(this.db);

  Future<String?> ler(String chave) async {
    final l = await (db.select(db.config)..where((t) => t.chave.equals(chave)))
        .getSingleOrNull();
    return l?.valor;
  }

  Future<void> definir(String chave, String valor) => db
      .into(db.config)
      .insertOnConflictUpdate(ConfigCompanion.insert(chave: chave, valor: valor));

  Future<DataPura> inicioCiclo() async =>
      DataPura(await ler('data_inicio_ciclo') ?? DataPura.de(DateTime.now()).iso);

  /// Tamanho do ciclo, com o fallback derivado do DADO e não de um literal.
  ///
  /// O literal `33` que ficava aqui era o caminho de volta para o crash da aba
  /// Mercado: um backup importado sem a chave `tamanho_ciclo` declarava 33
  /// posições sobre um ciclo que tem 4, e `resolverRefeicao` estoura na
  /// primeira posição sem combo. Importar backup é feature de primeira classe,
  /// então o fallback tem de ser sempre consistente com `ciclo_itens`.
  Future<int> tamanhoCiclo() async {
    final salvo = int.tryParse(await ler('tamanho_ciclo') ?? '');
    if (salvo != null && salvo > 0) return salvo;

    // A MESMA instância de expressão vai no addColumns e no read.
    final maior = db.cicloItens.posicao.max();
    final linha = await (db.selectOnly(db.cicloItens)..addColumns([maior]))
        .getSingleOrNull();
    // Ciclo vazio devolve uma linha com NULL: aí 1 é o mínimo honesto.
    return linha?.read(maior) ?? 1;
  }

  Future<Map<(SlotRefeicao, bool), int>> regras() async {
    final linhas = await db.select(db.regrasPorcao).get();
    if (linhas.isEmpty) return regrasPadrao;
    return {for (final l in linhas) (l.slot, l.diaUtil): l.porcoes};
  }
}
