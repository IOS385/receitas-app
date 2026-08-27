import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../format.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'receita_form_screen.dart';
import 'receitas_provider.dart';

class ReceitaScreen extends ConsumerWidget {
  final int receitaId;
  const ReceitaScreen({super.key, required this.receitaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalhe = ref.watch(detalheProvider(receitaId));
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Scaffold(
      body: detalhe.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e', textAlign: TextAlign.center),
          ),
        ),
        data: (d) => ListView(
          padding: EdgeInsets.zero,
          children: [
            CampoRespingo(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.chevron_left, size: 19),
                        label: const Text('Voltar'),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size(44, 44)),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Editar',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ReceitaFormScreen(receitaId: receitaId),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(d.receita.nome,
                      style: t.displaySmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final f in [
                        '${d.receita.tempoPreparoMin} min',
                        'rende ${d.receita.rendimentoPorcoes}',
                        rotuloCategoria(d.receita.categoria),
                      ])
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(f,
                              style: t.labelMedium
                                  ?.copyWith(color: Colors.white)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // --- macros calculados
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
              child: Row(
                children: [
                  for (final n in [
                    (v: d.nutrientes.kcal, r: 'KCAL'),
                    (v: d.nutrientes.proteina, r: 'PROT G'),
                    (v: d.nutrientes.carboidrato, r: 'CARB G'),
                    (v: d.nutrientes.gordura, r: 'GORD G'),
                  ])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        // Border com cor diferente no topo + borderRadius na
                        // mesma BoxDecoration estoura em paint() ("A
                        // borderRadius can only be given on borders with
                        // uniform colors.") — mesma restrição documentada em
                        // CartaoEsmalte. O arredondamento sai para um
                        // ClipRRect por fora.
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border(
                                top: BorderSide(
                                    color: cores.marinho, width: 2.5),
                                left: BorderSide(color: cores.linha),
                                right: BorderSide(color: cores.linha),
                                bottom: BorderSide(color: cores.linha),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text('${n.v.round()}', style: t.titleMedium),
                                Text(n.r,
                                    style: t.labelSmall?.copyWith(
                                        color: cores.ink3, fontSize: 8)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 8, 13, 0),
              child: Center(
                child: Text('calculado dos ingredientes · tabela TACO',
                    style: t.labelMedium?.copyWith(color: cores.ink3)),
              ),
            ),

            // --- ingredientes
            _Bloco(
              titulo: 'Ingredientes',
              nota: 'para ${porcoesTexto(d.receita.rendimentoPorcoes)}',
              child: Column(
                children: [
                  for (final i in d.ingredientes)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: cores.linha)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              i.observacao == null
                                  ? i.nome
                                  : '${i.nome} (${i.observacao})',
                              style:
                                  t.bodyMedium?.copyWith(color: cores.ink2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(qtd(i.quantidade, i.unidade),
                              style: t.labelMedium
                                  ?.copyWith(color: cores.ink3)),
                        ],
                      ),
                    ),
                  if (d.temSemMedida)
                    Padding(
                      padding: const EdgeInsets.only(top: 9),
                      child: Text(
                        'Sal e temperos a gosto não entram na conta.',
                        style: t.bodySmall?.copyWith(
                            color: cores.ink3, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),

            // --- preparo
            _Bloco(
              titulo: 'Modo de preparo',
              nota: '${d.passos.length} passos',
              child: Column(
                children: [
                  for (var i = 0; i < d.passos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            child: Text('${i + 1}',
                                style: t.titleMedium
                                    ?.copyWith(color: cores.marinho)),
                          ),
                          Expanded(
                            child: Text(d.passos[i],
                                style:
                                    t.bodyMedium?.copyWith(color: cores.ink2)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}

class _Bloco extends StatelessWidget {
  final String titulo;
  final String nota;
  final Widget child;

  const _Bloco({
    required this.titulo,
    required this.nota,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 17, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(titulo.toUpperCase(),
                    style: t.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              Text(nota, style: t.labelMedium?.copyWith(color: cores.ink3)),
            ],
          ),
          const SizedBox(height: 9),
          child,
        ],
      ),
    );
  }
}
