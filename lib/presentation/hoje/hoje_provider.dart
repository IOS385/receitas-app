import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../data/repo_plano.dart';
import '../../domain/modelos.dart';

/// A data que as telas Hoje e Mês compartilham. Começa no dia de hoje.
class DataSelecionada extends Notifier<DataPura> {
  @override
  DataPura build() => DataPura.de(DateTime.now());

  void ir(DataPura d) => state = d;

  void avancar(int dias) =>
      state = DataPura.de(state.comoDateTime.add(Duration(days: dias)));

  void hoje() => state = DataPura.de(DateTime.now());
}

final dataSelecionadaProvider =
    NotifierProvider<DataSelecionada, DataPura>(DataSelecionada.new);

final diaProvider = FutureProvider<DiaResolvido>((ref) {
  final data = ref.watch(dataSelecionadaProvider);
  return ref.watch(repoPlanoProvider).dia(data);
});
