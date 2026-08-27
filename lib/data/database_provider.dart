import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'repo_config.dart';
import 'repo_mercado.dart';
import 'repo_plano.dart';
import 'repo_receitas.dart';
import 'semente.dart';

/// Versão da semente empacotada. Subir isto reimporta o conteúdo `seed`
/// e deixa intacto o que a usuária editou.
///
/// **Mudou qualquer JSON de `assets/semente/`? Suba este número.** Sem isso o
/// app já instalado nunca recarrega — a guarda em [semeaduraProvider] compara
/// com `seed_version` e volta calada. Foi o que aconteceu com as fotos dos
/// pratos: a coluna entrou pela migração, ficou nula, e nenhuma foto apareceu
/// no aparelho dela. `test/semente_versao_test.dart` guarda isto por impressão
/// do conteúdo.
///
/// - 1 — os 4 primeiros dias
/// - 2 — foto do prato em cada um dos 8 combos
/// - 3 — os 33 dias inteiros: 66 combos, 139 receitas, 110 alimentos
/// - 4 — conteúdo idêntico ao 3. Sobe só para a semente **rodar de novo** e
///   consertar `tamanho_ciclo`, que ficou em '4' no aparelho dele: a versão 3
///   gravava esse valor derivado só quando ausente, como se fosse escolha da
///   usuária. Bump sem conteúdo novo é válido — o que a versão controla é
///   "precisa recarregar", não "o conteúdo mudou".
const int versaoSemente = 4;

final bancoProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  // GeneratedDatabase expõe `close()`, não `dispose()` (drift 2.34.3,
  // runtime/api/db_base.dart:146) — o brief tinha o nome errado.
  ref.onDispose(db.close);
  return db;
});

final repoConfigProvider =
    Provider<RepoConfig>((ref) => RepoConfig(ref.watch(bancoProvider)));

final repoPlanoProvider = Provider<RepoPlano>(
    (ref) => RepoPlano(ref.watch(bancoProvider), ref.watch(repoConfigProvider)));

final repoReceitasProvider =
    Provider<RepoReceitas>((ref) => RepoReceitas(ref.watch(bancoProvider)));

final repoMercadoProvider = Provider<RepoMercado>((ref) =>
    RepoMercado(ref.watch(bancoProvider), ref.watch(repoPlanoProvider)));

/// Roda a carga da semente uma vez, na abertura do app.
final semeaduraProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(bancoProvider);
  final atual = await RepoConfig(db).ler('seed_version');
  if (atual == '$versaoSemente') return;

  final cache = <String, String>{};
  for (final nome in const [
    'alimentos.json', 'conversoes.json', 'receitas.json',
    'combos.json', 'ciclo.json',
  ]) {
    cache[nome] = await rootBundle.loadString('assets/semente/$nome');
  }

  await carregarSemente(db,
      lerAsset: (nome) => cache[nome]!, versao: versaoSemente);
});
