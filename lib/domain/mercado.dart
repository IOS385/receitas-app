import 'dart:math' as math;

import 'modelos.dart';
import 'nutricao.dart';

/// Ordem física de um mercado, não alfabética: é o percurso que ela faz.
const List<SecaoMercado> ordemSecoes = [
  SecaoMercado.hortifruti,
  SecaoMercado.acougue,
  SecaoMercado.padaria,
  SecaoMercado.laticinios,
  SecaoMercado.mercearia,
  SecaoMercado.congelados,
  SecaoMercado.bebidas,
];

/// Uma linha de ingrediente já escalada, vinda de um dia do intervalo.
class LinhaIngrediente {
  final int alimentoId;
  final Unidade unidade;
  final double quantidade;

  const LinhaIngrediente({
    required this.alimentoId,
    required this.unidade,
    required this.quantidade,
  });
}

/// Um alimento somado ao longo do intervalo inteiro.
class ItemMercado {
  final int alimentoId;

  /// Sempre em grama (ou mililitro). A conversão para unidade de compra é
  /// assunto da exibição.
  final double gramas;
  final SecaoMercado secao;
  final UnidadeCompra unidadeCompra;

  const ItemMercado({
    required this.alimentoId,
    required this.gramas,
    required this.secao,
    required this.unidadeCompra,
  });
}

/// Soma todas as linhas por alimento e devolve na ordem do percurso do mercado.
///
/// Acumula sempre em grama — inclusive para alimento comprado por unidade.
/// É o que permite somar "2 ovos" de uma receita com "100 g de ovo" de outra
/// na mesma linha.
List<ItemMercado> agregarMercado({
  required List<LinhaIngrediente> linhas,
  required Map<int, Map<Unidade, double>> conversoes,
  required Map<int, SecaoMercado> secoes,
  required Map<int, UnidadeCompra> unidadesCompra,
}) {
  final soma = <int, double>{};

  for (final l in linhas) {
    final g = emGramas(
      unidade: l.unidade,
      quantidade: l.quantidade,
      conversoes: conversoes[l.alimentoId] ?? const {},
      alimentoId: l.alimentoId,
    );
    if (g == 0) continue; // pitada e a gosto não entram na compra
    soma.update(l.alimentoId, (v) => v + g, ifAbsent: () => g);
  }

  final itens = soma.entries
      .map((e) => ItemMercado(
            alimentoId: e.key,
            gramas: e.value,
            secao: secoes[e.key] ?? SecaoMercado.mercearia,
            unidadeCompra: unidadesCompra[e.key] ?? UnidadeCompra.kg,
          ))
      .toList();

  itens.sort((a, b) {
    final s = ordemSecoes.indexOf(a.secao).compareTo(ordemSecoes.indexOf(b.secao));
    return s != 0 ? s : a.alimentoId.compareTo(b.alimentoId);
  });

  return itens;
}

/// Converte a massa acumulada para a unidade em que a coisa é comprada.
///
/// [gramasPorUnidade] é a conversão `Unidade.unidade` do alimento, necessária
/// só quando ele é comprado por unidade. Sem ela, cai para grama em vez de
/// estourar: lista de mercado incompleta é melhor que tela que não abre.
({double valor, String unidade}) formatarCompra({
  required double gramas,
  required UnidadeCompra compra,
  required double? gramasPorUnidade,
}) {
  switch (compra) {
    case UnidadeCompra.kg:
      return gramas >= 1000
          ? (valor: gramas / 1000, unidade: 'kg')
          : (valor: gramas, unidade: 'g');

    case UnidadeCompra.litro:
      return gramas >= 1000
          ? (valor: gramas / 1000, unidade: 'L')
          : (valor: gramas, unidade: 'ml');

    case UnidadeCompra.unidade:
      if (gramasPorUnidade == null || gramasPorUnidade <= 0) {
        return (valor: gramas, unidade: 'g');
      }
      final n = math.max(1, (gramas / gramasPorUnidade).ceil());
      return (valor: n.toDouble(), unidade: 'un');
  }
}
