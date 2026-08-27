import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/modelos.dart';

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
