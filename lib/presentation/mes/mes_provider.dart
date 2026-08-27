import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../hoje/hoje_provider.dart';

/// O mês que a grade está mostrando.
///
/// Inicializa a partir da data selecionada e **não** reage a mudanças
/// posteriores dela: `ref.read` e não `ref.watch`. Com `watch`, qualquer troca
/// de data — inclusive vinda de outra tela — reconstruiria o notifier e
/// descartaria o mês que ela estava folheando, sem ação dela.
///
/// Tocar num dia da grade continua funcionando porque a grade só mostra dias do
/// mês visível: o dia escolhido nunca está fora dele.
class MesVisivel extends Notifier<({int ano, int mes})> {
  @override
  ({int ano, int mes}) build() {
    final d = ref.read(dataSelecionadaProvider).comoDateTime;
    return (ano: d.year, mes: d.month);
  }

  void avancar(int meses) {
    final atual = DateTime.utc(state.ano, state.mes + meses);
    state = (ano: atual.year, mes: atual.month);
  }
}

final mesVisivelProvider =
    NotifierProvider<MesVisivel, ({int ano, int mes})>(MesVisivel.new);

/// Quantos dias tem o mês visível.
int diasNoMes(int ano, int mes) => DateTime.utc(ano, mes + 1, 0).day;

/// Em que coluna cai o dia 1 (0 = domingo).
int primeiroDiaDaSemana(int ano, int mes) =>
    DateTime.utc(ano, mes, 1).weekday % 7;

/// Datas do mês visível com alguma substituição — alimenta o ponto de brasa.
final diasEditadosProvider = FutureProvider<Set<DataPura>>((ref) {
  final m = ref.watch(mesVisivelProvider);
  final de = DataPura.de(DateTime.utc(m.ano, m.mes, 1));
  final ate = DataPura.de(DateTime.utc(m.ano, m.mes, diasNoMes(m.ano, m.mes)));
  return ref.watch(repoPlanoProvider).diasEditados(de, ate);
});
