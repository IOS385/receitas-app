import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../format.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'mercado_provider.dart';

class MercadoScreen extends ConsumerWidget {
  const MercadoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(listaMercadoProvider);
    final intervalo = ref.watch(intervaloProvider);
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
                Text('LISTA DE MERCADO',
                    style: t.labelSmall?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  '${intervalo.de.comoDateTime.day} – '
                  '${intervalo.ate.comoDateTime.day} de '
                  '${mesNome(intervalo.ate.comoDateTime.month)}',
                  style: t.displaySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    _Faixa(
                      texto: 'Esta semana',
                      ativa: intervalo == semanaDe(DateTime.now()),
                      onTap: () =>
                          ref.read(intervaloProvider.notifier).semana(),
                    ),
                    _Faixa(
                      texto: 'Este mês',
                      ativa: intervalo == mesDe(DateTime.now()),
                      onTap: () => ref.read(intervaloProvider.notifier).mes(),
                    ),
                    _Faixa(
                      texto: 'Escolher…',
                      ativa: false,
                      onTap: () => _escolherIntervalo(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                lista.maybeWhen(
                  data: (l) => Row(
                    children: [
                      Text('${l.feitos} de ${l.total}',
                          style: t.labelMedium?.copyWith(color: cores.ink3)),
                      const SizedBox(width: 9),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: l.progresso,
                            minHeight: 5,
                            backgroundColor: cores.superficie2,
                            valueColor:
                                AlwaysStoppedAnimation(cores.marinho),
                          ),
                        ),
                      ),
                    ],
                  ),
                  orElse: () => const SizedBox(height: 5),
                ),
              ],
            ),
          ),
          lista.when(
            loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text('$e', style: t.bodySmall)),
            data: (l) => l.itens.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'Nada a comprar neste intervalo.',
                        style: t.bodyMedium?.copyWith(color: cores.ink3),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (final s in l.secoes)
                        _Secao(secao: s, itens: l.daSecao(s), listaId: l.listaId),
                      const SizedBox(height: 22),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _escolherIntervalo(BuildContext context, WidgetRef ref) async {
    final agora = DateTime.now();
    final faixa = await showDateRangePicker(
      context: context,
      firstDate: DateTime(agora.year - 1),
      lastDate: DateTime(agora.year + 2),
      initialDateRange: DateTimeRange(
        start: ref.read(intervaloProvider).de.comoDateTime,
        end: ref.read(intervaloProvider).ate.comoDateTime,
      ),
    );
    if (faixa == null) return;
    ref
        .read(intervaloProvider.notifier)
        .definir(DataPura.de(faixa.start), DataPura.de(faixa.end));
  }
}

class _Faixa extends StatelessWidget {
  final String texto;
  final bool ativa;
  final VoidCallback onTap;

  const _Faixa({
    required this.texto,
    required this.ativa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    return ChoiceChip(
      label: Text(texto),
      selected: ativa,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: cores.marinho,
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: ativa ? Colors.white : cores.ink2),
      side: BorderSide(color: ativa ? cores.marinho : cores.linha),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _Secao extends StatelessWidget {
  final SecaoMercado secao;
  final List<ItemNaTela> itens;
  final int listaId;

  const _Secao({
    required this.secao,
    required this.itens,
    required this.listaId,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(rotuloSecao(secao).toUpperCase(),
                      style: t.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                Text('${itens.length} itens',
                    style: t.labelMedium?.copyWith(color: cores.ink3)),
              ],
            ),
          ),
          for (final i in itens) _Item(item: i, listaId: listaId),
        ],
      ),
    );
  }
}

class _Item extends ConsumerWidget {
  final ItemNaTela item;
  final int listaId;

  const _Item({required this.item, required this.listaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () async {
            await ref
                .read(repoMercadoProvider)
                .marcar(listaId, item.alimentoId, !item.marcado);
            ref.invalidate(listaMercadoProvider);
          },
          child: Opacity(
            opacity: item.marcado ? .42 : 1,
            child: Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: cores.linha),
              ),
              child: Row(
                children: [
                  Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      color: item.marcado ? cores.marinho : null,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: item.marcado ? cores.marinho : cores.ink3,
                          width: 1.5),
                    ),
                    child: item.marcado
                        ? const Icon(Icons.check,
                            size: 12, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.nome,
                      style: t.bodyMedium?.copyWith(
                        decoration: item.marcado
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Text(_medida(item),
                      style: t.labelMedium?.copyWith(color: cores.ink3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _medida(ItemNaTela i) {
    final v = i.valor;
    final texto = v == v.roundToDouble()
        ? '${v.round()}'
        : v.toStringAsFixed(1).replaceAll('.', ',');
    return '$texto ${i.unidade}';
  }
}
