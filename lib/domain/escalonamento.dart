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

  // Multiplica ANTES de dividir. Calcular a razão `porcoes / rendimento`
  // primeiro introduz erro de ponto flutuante que empurra resultados exatos
  // para cima da fronteira inteira, e o `ceil()` abaixo então erra por 1:
  // `21 * (9 / 7)` dá 27.000000000000004 e arredonda para 28, não 27.
  final bruto = quantidade * porcoes / rendimento;
  if (unidadesDiscretas.contains(unidade)) {
    return math.max(1, bruto.ceil()).toDouble();
  }
  return bruto;
}
