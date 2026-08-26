import 'espelho.dart';
import 'modelos.dart';

/// Resolve qual refeição cai em (data, slot), aplicando o ciclo e as duas
/// camadas de exceção.
///
/// Precedência do combo, primeira que casar vence:
///   1. override próprio do slot — e aqui o espelho está quebrado
///   2. override do slot base, se este slot for espelhado
///   3. o combo do ciclo na posição do dia
///
/// Depois, as substituições de componente. A regra em uma frase: um slot que
/// já se soltou do espelho não herda mais nada do espelho.
RefeicaoResolvida resolverRefeicao({
  required DataPura data,
  required SlotRefeicao slot,
  required int posicao,
  required int porcoes,
  required Map<(int, TipoCombo), int> ciclo,
  required Map<int, List<int>> componentesDoCombo,
  required Map<(DataPura, SlotRefeicao), int> overridesCombo,
  required Map<(DataPura, SlotRefeicao), Map<int, int?>> overridesComponente,
}) {
  final base = slotBase(slot);

  var espelhoIntacto = true;
  var comboId = overridesCombo[(data, slot)];

  if (comboId != null) {
    espelhoIntacto = false;
  } else if (base != slot) {
    comboId = overridesCombo[(data, base)];
  }

  comboId ??= ciclo[(posicao, tipoDoSlot(slot))] ??
      (throw StateError(
          'ciclo sem combo para posicao $posicao / ${tipoDoSlot(slot).name}'));

  final originais = componentesDoCombo[comboId] ??
      (throw StateError('combo $comboId sem componentes cadastrados'));

  // Camadas de substituição de componente, na ordem em que se aplicam.
  final camadas = <(DataPura, SlotRefeicao)>[
    if (espelhoIntacto && base != slot) (data, base),
    (data, slot),
  ];

  var receitas = List<int>.of(originais);
  for (final chave in camadas) {
    final subs = overridesComponente[chave];
    if (subs == null) continue;

    final proxima = <int>[];
    for (final id in receitas) {
      if (!subs.containsKey(id)) {
        proxima.add(id);
        continue;
      }
      final destino = subs[id];
      if (destino != null) proxima.add(destino); // nulo = removido do prato
    }
    receitas = proxima;
  }

  return RefeicaoResolvida(
    slot: slot,
    porcoes: porcoes,
    comboId: comboId,
    receitaIds: receitas,
    espelhoIntacto: espelhoIntacto,
  );
}
