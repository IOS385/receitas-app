import 'modelos.dart';

/// Falta uma linha em `conversao_unidade` para este par alimento/unidade.
///
/// Estoura de propósito: devolver zero calado esconderia caloria faltando na
/// tela, que é pior do que quebrar durante a carga da semente.
class ConversaoAusente implements Exception {
  final int alimentoId;
  final Unidade unidade;

  const ConversaoAusente(this.alimentoId, this.unidade);

  @override
  String toString() =>
      'ConversaoAusente: alimento $alimentoId nao tem conversao para '
      '${unidade.name}';
}

/// Converte uma quantidade para gramas (ou mililitros) usando a tabela.
///
/// Grama também passa pela tabela, sem atalho no código: o cálculo tem um
/// caminho só, e conversão faltando aparece sempre do mesmo jeito.
double emGramas({
  required Unidade unidade,
  required double quantidade,
  required Map<Unidade, double> conversoes,
  required int alimentoId,
}) {
  if (unidadesSemMedida.contains(unidade)) return 0;

  final gramasPorUnidade = conversoes[unidade];
  if (gramasPorUnidade == null) {
    throw ConversaoAusente(alimentoId, unidade);
  }
  return quantidade * gramasPorUnidade;
}

/// Nutrientes de uma massa a partir da tabela por 100 g.
Nutrientes nutrienteDe({
  required Nutrientes por100g,
  required double gramas,
}) =>
    por100g.escalar(gramas / 100);
