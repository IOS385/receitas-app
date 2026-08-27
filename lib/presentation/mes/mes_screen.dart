import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/modelos.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import '../widgets/cartao_esmalte.dart';
import 'mes_provider.dart';

class MesScreen extends ConsumerWidget {
  const MesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = ref.watch(mesVisivelProvider);
    final selecionada = ref.watch(dataSelecionadaProvider);
    final editados = ref.watch(diasEditadosProvider).value ?? const {};
    final dia = ref.watch(diaProvider);
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CampoRespingo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      tooltip: 'Mês anterior',
                      onPressed: () =>
                          ref.read(mesVisivelProvider.notifier).avancar(-1),
                    ),
                    Expanded(
                      child: Text(
                        '${mesNome(m.mes)} ${m.ano}'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: t.labelSmall?.copyWith(color: Colors.white70),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: 'Mês seguinte',
                      onPressed: () =>
                          ref.read(mesVisivelProvider.notifier).avancar(1),
                    ),
                  ],
                ),
                Text('O mês',
                    style: t.displaySmall?.copyWith(color: Colors.white)),
              ],
            ),
          ),
          _Grade(
            ano: m.ano,
            mes: m.mes,
            selecionada: selecionada,
            editados: editados,
            onEscolher: (d) =>
                ref.read(dataSelecionadaProvider.notifier).ir(d),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 11, 15, 3),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      color: cores.brasa, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('dia que você trocou',
                    style: t.bodySmall?.copyWith(color: cores.ink3)),
                const Spacer(),
                Text('${editados.length} neste mês',
                    style: t.labelMedium?.copyWith(color: cores.ink3)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 9, 13, 24),
            child: dia.when(
              loading: () => const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator())),
              error: (e, _) => Text('$e', style: t.bodySmall),
              data: (d) => CartaoEsmalte(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataLonga(d.data).replaceFirstMapped(
                          RegExp(r'^\w'), (m) => m[0]!.toUpperCase()),
                      style: t.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'dia ${d.posicao} de ${d.tamanhoCiclo} · '
                      '${ehDiaUtilData(d.data) ? '1 porção no café e no almoço' : '2 porções o dia todo'}',
                      style: t.labelMedium?.copyWith(color: cores.ink3),
                    ),
                    const SizedBox(height: 10),
                    for (final r in d.refeicoes)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(rotuloSlot(r.slot),
                                  style: t.bodyMedium
                                      ?.copyWith(color: cores.ink2)),
                            ),
                            Text('${r.nutrientes.kcal.round()} kcal',
                                style: t.labelMedium
                                    ?.copyWith(color: cores.ink3)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(height: 2, color: cores.marinho),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text('TOTAL DO DIA',
                              style: t.labelSmall?.copyWith(color: cores.ink3)),
                        ),
                        Text('${d.total.kcal.round()}',
                            style: t.titleLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Grade extends StatelessWidget {
  final int ano;
  final int mes;
  final DataPura selecionada;
  final Set<DataPura> editados;
  final ValueChanged<DataPura> onEscolher;

  const _Grade({
    required this.ano,
    required this.mes,
    required this.selecionada,
    required this.editados,
    required this.onEscolher,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    final t = Theme.of(context).textTheme;
    final total = diasNoMes(ano, mes);
    final vazias = primeiroDiaDaSemana(ano, mes);
    final hoje = DataPura.de(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
      child: Column(
        children: [
          Row(
            children: [
              for (final s in const ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'])
                Expanded(
                  child: Center(
                    child: Text(s,
                        style:
                            t.labelSmall?.copyWith(color: cores.ink3)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: vazias + total,
            itemBuilder: (context, i) {
              if (i < vazias) return const SizedBox.shrink();

              final numero = i - vazias + 1;
              final data = DataPura.de(DateTime.utc(ano, mes, numero));
              final ativa = data == selecionada;
              final editada = editados.contains(data);

              return Semantics(
                selected: ativa,
                button: true,
                label: '$numero de ${mesNome(mes)}'
                    '${editada ? ', substituído' : ''}',
                child: Material(
                  color: ativa ? cores.marinho : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(7),
                  child: InkWell(
                    onTap: () => onEscolher(data),
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: ativa ? cores.marinho : cores.linha,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              '$numero',
                              style: t.bodyMedium?.copyWith(
                                color: ativa ? Colors.white : cores.ink2,
                                fontVariations: [
                                  FontVariation('wght', ativa ? 800 : 500)
                                ],
                              ),
                            ),
                          ),
                          if (editada)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: ativa ? Colors.white : cores.brasa,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          if (data == hoje && !ativa)
                            Positioned(
                              bottom: 4,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: cores.brasa,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
