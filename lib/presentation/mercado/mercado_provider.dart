import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/mercado.dart';
import '../../domain/modelos.dart';

class ItemNaTela {
  final int alimentoId;
  final String nome;
  final SecaoMercado secao;
  final double valor;
  final String unidade;
  final bool marcado;

  const ItemNaTela({
    required this.alimentoId,
    required this.nome,
    required this.secao,
    required this.valor,
    required this.unidade,
    required this.marcado,
  });
}

class ListaNaTela {
  final int listaId;
  final DataPura de;
  final DataPura ate;
  final List<ItemNaTela> itens;

  const ListaNaTela({
    required this.listaId,
    required this.de,
    required this.ate,
    required this.itens,
  });

  int get feitos => itens.where((i) => i.marcado).length;
  int get total => itens.length;
  double get progresso => total == 0 ? 0 : feitos / total;

  List<ItemNaTela> daSecao(SecaoMercado s) =>
      itens.where((i) => i.secao == s).toList();

  List<SecaoMercado> get secoes =>
      ordemSecoes.where((s) => daSecao(s).isNotEmpty).toList();
}

/// Segunda a domingo da semana corrente.
({DataPura de, DataPura ate}) semanaDe(DateTime agora) {
  final base = DateTime.utc(agora.year, agora.month, agora.day);
  final segunda = base.subtract(Duration(days: base.weekday - 1));
  return (
    de: DataPura.de(segunda),
    ate: DataPura.de(segunda.add(const Duration(days: 6))),
  );
}

({DataPura de, DataPura ate}) mesDe(DateTime agora) => (
      de: DataPura.de(DateTime.utc(agora.year, agora.month, 1)),
      ate: DataPura.de(DateTime.utc(agora.year, agora.month + 1, 0)),
    );

class Intervalo extends Notifier<({DataPura de, DataPura ate})> {
  @override
  ({DataPura de, DataPura ate}) build() => semanaDe(DateTime.now());

  void definir(DataPura de, DataPura ate) => state = (de: de, ate: ate);
  void semana() => state = semanaDe(DateTime.now());
  void mes() => state = mesDe(DateTime.now());
}

final intervaloProvider =
    NotifierProvider<Intervalo, ({DataPura de, DataPura ate})>(Intervalo.new);

/// Gera a lista do intervalo. Só re-executa quando o INTERVALO muda.
///
/// Marcar item NAO pode passar por aqui: `gerar()` cria uma lista nova a cada
/// chamada (por design, spec D6), entao regenerar ao marcar apagaria a marca.
final listaIdProvider = FutureProvider<int>((ref) async {
  final intervalo = ref.watch(intervaloProvider);
  return ref.watch(repoMercadoProvider).gerar(intervalo.de, intervalo.ate);
});

/// Le os itens da lista gerada. Marcar item invalida SO este provider, entao
/// os itens sao relidos da MESMA lista e as marcas sobrevivem.
final listaMercadoProvider = FutureProvider<ListaNaTela>((ref) async {
  final intervalo = ref.watch(intervaloProvider);
  final listaId = await ref.watch(listaIdProvider.future);
  final repo = ref.watch(repoMercadoProvider);
  final db = ref.watch(bancoProvider);

  final itens = await repo.itens(listaId);

  final alimentos = {
    for (final a in await db.select(db.alimentos).get()) a.id: a,
  };
  final gramasPorUnidade = <int, double>{};
  for (final c in await db.select(db.conversoes).get()) {
    if (c.unidade == Unidade.unidade) gramasPorUnidade[c.alimentoId] = c.gramas;
  }

  final naTela = <ItemNaTela>[];
  for (final s in ordemSecoes) {
    for (final i in itens) {
      final a = alimentos[i.alimentoId];
      if (a == null || a.secaoMercado != s) continue;

      final f = formatarCompra(
        gramas: i.quantidadeG,
        compra: a.unidadeCompra,
        gramasPorUnidade: gramasPorUnidade[a.id],
      );
      naTela.add(ItemNaTela(
        alimentoId: a.id,
        nome: a.nome,
        secao: a.secaoMercado,
        valor: f.valor,
        unidade: f.unidade,
        marcado: i.marcado,
      ));
    }
  }

  return ListaNaTela(
    listaId: listaId,
    de: intervalo.de,
    ate: intervalo.ate,
    itens: naTela,
  );
});
