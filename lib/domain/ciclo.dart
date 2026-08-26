import 'modelos.dart';

/// Posição de uma data dentro do ciclo, de 1 a [tamanho].
///
/// O módulo é duplo de propósito: em Dart, `-1 % 33` devolve `-1`, e a usuária
/// precisa poder navegar para datas anteriores ao início do ciclo.
int posicaoNoCiclo({
  required DataPura inicio,
  required DataPura data,
  required int tamanho,
}) {
  assert(tamanho > 0, 'tamanho do ciclo precisa ser positivo');
  final dias = data.comoDateTime.difference(inicio.comoDateTime).inDays;
  return ((dias % tamanho) + tamanho) % tamanho + 1;
}
