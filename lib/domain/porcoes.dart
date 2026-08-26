import 'modelos.dart';

/// Segunda a sexta. Sábado e domingo são fim de semana.
bool ehDiaUtil(DataPura data) {
  final d = data.comoDateTime.weekday;
  return d >= DateTime.monday && d <= DateTime.friday;
}

/// Quantas porções este slot rende nesta data.
///
/// Regra ausente cai em 1 em vez de estourar: uma tabela incompleta no banco
/// não pode impedir a tela de abrir.
int porcoesDoSlot({
  required SlotRefeicao slot,
  required DataPura data,
  required Map<(SlotRefeicao, bool), int> regras,
}) =>
    regras[(slot, ehDiaUtil(data))] ?? 1;

/// Semente da tabela `regra_porcao`.
///
/// De manhã e no almoço ela está sozinha durante a semana; à tarde e à noite
/// são dois. No fim de semana são dois o dia todo.
const Map<(SlotRefeicao, bool), int> regrasPadrao = {
  (SlotRefeicao.cafeManha, true): 1,
  (SlotRefeicao.cafeManha, false): 2,
  (SlotRefeicao.almoco, true): 1,
  (SlotRefeicao.almoco, false): 2,
  (SlotRefeicao.cafeTarde, true): 2,
  (SlotRefeicao.cafeTarde, false): 2,
  (SlotRefeicao.jantar, true): 2,
  (SlotRefeicao.jantar, false): 2,
};
