import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../../domain/nutricao.dart';

class Filtro extends Notifier<({CategoriaReceita? categoria, String busca})> {
  @override
  ({CategoriaReceita? categoria, String busca}) build() =>
      (categoria: null, busca: '');

  void categoria(CategoriaReceita? c) => state = (categoria: c, busca: state.busca);
  void buscar(String b) => state = (categoria: state.categoria, busca: b);
}

final filtroProvider =
    NotifierProvider<Filtro, ({CategoriaReceita? categoria, String busca})>(
        Filtro.new);

final catalogoProvider = FutureProvider<List<Receita>>((ref) {
  final f = ref.watch(filtroProvider);
  return ref
      .watch(repoReceitasProvider)
      .listar(categoria: f.categoria, busca: f.busca);
});

class IngredienteNaTela {
  final int alimentoId;
  final String nome;
  final double quantidade;
  final Unidade unidade;
  final String? observacao;

  const IngredienteNaTela({
    required this.alimentoId,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    this.observacao,
  });
}

class DetalheReceita {
  final Receita receita;
  final List<IngredienteNaTela> ingredientes;
  final Nutrientes nutrientes;

  /// Verdadeiro quando algum ingrediente é `a gosto` ou `pitada` — a tela
  /// avisa que aquilo não entra na conta (spec 8.2).
  final bool temSemMedida;

  const DetalheReceita({
    required this.receita,
    required this.ingredientes,
    required this.nutrientes,
    required this.temSemMedida,
  });

  List<String> get passos => receita.modoPreparo
      .split('\n')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
}

/// Detalhe no rendimento nativo da receita, sem escalar por porção do dia.
final detalheProvider =
    FutureProvider.family<DetalheReceita, int>((ref, receitaId) async {
  final repo = ref.watch(repoReceitasProvider);
  final db = ref.watch(bancoProvider);

  final receita = await repo.porId(receitaId);
  if (receita == null) throw StateError('receita $receitaId nao existe');

  final ingredientes = await repo.ingredientesDe(receitaId);
  final alimentos = {
    for (final a in await db.select(db.alimentos).get()) a.id: a,
  };
  final conversoes = <int, Map<Unidade, double>>{};
  for (final c in await db.select(db.conversoes).get()) {
    conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
  }

  final naTela = <IngredienteNaTela>[];
  var nutrientes = Nutrientes.zero;
  var semMedida = false;

  for (final i in ingredientes) {
    final a = alimentos[i.alimentoId];
    if (a == null) continue;

    if (unidadesSemMedida.contains(i.unidade)) semMedida = true;

    naTela.add(IngredienteNaTela(
      alimentoId: a.id,
      nome: a.nome,
      quantidade: i.quantidade,
      unidade: i.unidade,
      observacao: i.observacao,
    ));

    final gramas = emGramas(
      unidade: i.unidade,
      quantidade: i.quantidade,
      conversoes: conversoes[a.id] ?? const {},
      alimentoId: a.id,
    );
    nutrientes = nutrientes +
        nutrienteDe(
          por100g: Nutrientes(
            kcal: a.kcal100g,
            carboidrato: a.carboidratoG,
            proteina: a.proteinaG,
            gordura: a.gorduraG,
            fibra: a.fibraG,
            sodio: a.sodioMg,
          ),
          gramas: gramas,
        );
  }

  return DetalheReceita(
    receita: receita,
    ingredientes: naTela,
    nutrientes: nutrientes,
    temSemMedida: semMedida,
  );
});
