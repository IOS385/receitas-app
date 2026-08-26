import 'modelos.dart';

/// Posição de uma data dentro do ciclo, de 1 a [tamanho].
///
/// Atenção ao operador: em Dart, `%` sobre `int` é **euclidiano** — o resultado
/// é sempre em `[0, tamanho)` mesmo para dias negativos (`-2 % 33 == 31`).
/// Isso difere de C, Java e JavaScript. Quem quer o resto truncado usa
/// `remainder()`, que devolveria `-2` e quebraria a navegação para datas
/// anteriores ao início do ciclo.
///
/// O módulo duplo abaixo é redundante nesta linguagem, e fica de propósito:
/// custa nada e protege se alguém trocar `%` por `remainder()`. O teste de
/// varredura de 800 dias é o que guarda essa promessa.
int posicaoNoCiclo({
  required DataPura inicio,
  required DataPura data,
  required int tamanho,
}) {
  assert(tamanho > 0, 'tamanho do ciclo precisa ser positivo');
  final dias = data.comoDateTime.difference(inicio.comoDateTime).inDays;
  return ((dias % tamanho) + tamanho) % tamanho + 1;
}
