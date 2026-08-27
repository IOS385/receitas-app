import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `ProviderOrFamily` fica fora do barril principal do riverpod 3 (só em
// `misc.dart`), como o `Override` que os testes importam de lá.
import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;

import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../hoje/hoje_provider.dart';
import '../mercado/mercado_provider.dart';
import '../mes/mes_provider.dart';
import '../receitas/receitas_provider.dart';

/// Aparência: claro, escuro ou seguir o sistema. Persistida em `config.tema`.
class TemaModo extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final valor = await ref.watch(repoConfigProvider).ler('tema');
    return switch (valor) {
      'claro' => ThemeMode.light,
      'escuro' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> definir(ThemeMode modo) async {
    final texto = switch (modo) {
      ThemeMode.light => 'claro',
      ThemeMode.dark => 'escuro',
      ThemeMode.system => 'sistema',
    };
    await ref.read(repoConfigProvider).definir('tema', texto);
    state = AsyncData(modo);
  }
}

final temaModoProvider =
    AsyncNotifierProvider<TemaModo, ThemeMode>(TemaModo.new);

typedef Resumo = ({
  int receitas,
  int combos,
  int alimentos,
  String inicio,
  int tamanho,
});

final resumoProvider = FutureProvider<Resumo>((ref) async {
  final db = ref.watch(bancoProvider);
  final config = ref.watch(repoConfigProvider);

  return (
    receitas: (await db.select(db.receitas).get()).length,
    combos: (await db.select(db.combos).get()).length,
    alimentos: (await db.select(db.alimentos).get()).length,
    inicio: (await config.inicioCiclo()).iso,
    tamanho: await config.tamanhoCiclo(),
  );
});

final regrasPorcaoProvider =
    FutureProvider<Map<(SlotRefeicao, bool), int>>((ref) =>
        ref.watch(repoConfigProvider).regras());

/// Tudo que é lido do banco e fica em cache.
///
/// Importar backup troca o banco INTEIRO, então nada pode sobreviver ao
/// import. Antes daqui só três eram invalidados: a aba Receitas voltava com o
/// catálogo antigo, o Mercado apontava para um `listaId` que o import apagou,
/// o ponto de brasa do Mês ficava velho e o tema do arquivo não era aplicado.
final providersDoBanco = <ProviderOrFamily>[
  resumoProvider,
  regrasPorcaoProvider,
  temaModoProvider,
  diaProvider,
  catalogoProvider,
  listaIdProvider,
  listaMercadoProvider,
  diasEditadosProvider,
];
