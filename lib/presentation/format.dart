import '../domain/espelho.dart' as espelho;
import '../domain/modelos.dart';

const _sufixo = {
  Unidade.g: 'g',
  Unidade.ml: 'ml',
  Unidade.unidade: 'un',
  Unidade.colherSopa: 'col. sopa',
  Unidade.colherCha: 'col. chá',
  Unidade.xicara: 'xíc.',
  Unidade.dente: 'dente',
  Unidade.fatia: 'fatia',
  Unidade.folha: 'folha',
};

/// Quantidade pronta para tela. Grama e mililitro viram inteiro; colher e
/// xícara arredondam para meio; discreta já vem inteira do escalonamento.
String qtd(double valor, Unidade unidade) {
  if (unidade == Unidade.aGosto) return 'a gosto';
  if (unidade == Unidade.pitada) return 'uma pitada';

  final sufixo = _sufixo[unidade] ?? '';

  if (unidade == Unidade.g || unidade == Unidade.ml) {
    return '${valor.round()} $sufixo';
  }

  final meio = (valor * 2).round() / 2;
  final texto = meio == meio.roundToDouble()
      ? '${meio.round()}'
      : meio.toString().replaceAll('.', ',');

  final plural = meio > 1 &&
      (unidade == Unidade.dente ||
          unidade == Unidade.fatia ||
          unidade == Unidade.folha);
  return '$texto ${plural ? '${sufixo}s' : sufixo}';
}

String kcal(double valor) => '${valor.round()} kcal';

String gramas(double valor) => '${valor.round()} g';

String rotuloSlot(SlotRefeicao slot) => switch (slot) {
      SlotRefeicao.cafeManha => 'Café da manhã',
      SlotRefeicao.almoco => 'Almoço',
      SlotRefeicao.cafeTarde => 'Café da tarde',
      SlotRefeicao.jantar => 'Jantar',
    };

String rotuloCategoria(CategoriaReceita c) => switch (c) {
      CategoriaReceita.base => 'Base',
      CategoriaReceita.proteina => 'Proteína',
      CategoriaReceita.leguminosa => 'Leguminosa',
      CategoriaReceita.vegetal => 'Legume',
      CategoriaReceita.salada => 'Salada',
      CategoriaReceita.molho => 'Molho',
      CategoriaReceita.bebida => 'Bebida',
      CategoriaReceita.pao => 'Pão',
      CategoriaReceita.fruta => 'Fruta',
    };

String rotuloSecao(SecaoMercado s) => switch (s) {
      SecaoMercado.hortifruti => 'Hortifrúti',
      SecaoMercado.acougue => 'Açougue',
      SecaoMercado.padaria => 'Padaria',
      SecaoMercado.laticinios => 'Laticínios',
      SecaoMercado.mercearia => 'Mercearia',
      SecaoMercado.congelados => 'Congelados',
      SecaoMercado.bebidas => 'Bebidas',
    };

String porcoesTexto(int n) => n == 1 ? '1 porção' : '$n porções';

const _diasSemana = [
  'segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo',
];
const _meses = [
  'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
  'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
];

String diaDaSemana(DataPura d) => _diasSemana[d.comoDateTime.weekday - 1];

String mesNome(int mes) => _meses[mes - 1];

/// "quarta, 4 de setembro"
String dataLonga(DataPura d) {
  final dt = d.comoDateTime;
  return '${diaDaSemana(d)}, ${dt.day} de ${mesNome(dt.month)}';
}

// Reexporta o espelho com nome explícito para uso na apresentação.
bool ehEspelhadoSlot(SlotRefeicao s) => espelho.ehEspelhado(s);
SlotRefeicao slotBaseDe(SlotRefeicao s) => espelho.slotBase(s);
