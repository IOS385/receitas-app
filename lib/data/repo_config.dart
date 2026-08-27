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

  Future<int> tamanhoCiclo() async =>
      int.tryParse(await ler('tamanho_ciclo') ?? '') ?? 33;

  Future<Map<(SlotRefeicao, bool), int>> regras() async {
    final linhas = await db.select(db.regrasPorcao).get();
    if (linhas.isEmpty) return regrasPadrao;
    return {for (final l in linhas) (l.slot, l.diaUtil): l.porcoes};
  }
}
