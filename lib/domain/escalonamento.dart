import 'dart:math' as math;

import 'modelos.dart';

/// Ajusta a quantidade de um ingrediente para o número de porções do slot.
///
/// Unidade discreta arredonda para cima: meio ovo não vai na panela.
/// Unidade contínua mantém o decimal — o arredondamento fica para a exibição.
/// `pitada` e `aGosto` não escalam (spec 7).
double escalarQuantidade({
  required double quantidade,
  required Unidade unidade,
  required int porcoes,
  required int rendimento,
}) {
  if (unidadesSemMedida.contains(unidade)) return quantidade;
  if (rendimento <= 0) return quantidade;

  final bruto = quantidade * (porcoes / rendimento);
  if (unidadesDiscretas.contains(unidade)) {
    return math.max(1, bruto.ceil()).toDouble();
  }
  return bruto;
}
