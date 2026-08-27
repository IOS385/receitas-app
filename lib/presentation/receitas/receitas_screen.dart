import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/modelos.dart';
import '../format.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'receita_form_screen.dart';
import 'receita_screen.dart';
import 'receitas_provider.dart';

class ReceitasScreen extends ConsumerWidget {
  const ReceitasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogo = ref.watch(catalogoProvider);
    final filtro = ref.watch(filtroProvider);
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova receita',
        backgroundColor: cores.marinho,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const ReceitaFormScreen(),
        )),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          CampoRespingo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CATÁLOGO',
                    style: t.labelSmall?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                catalogo.maybeWhen(
                  data: (l) => Text('${l.length} receitas',
                      style: t.displaySmall?.copyWith(color: Colors.white)),
                  orElse: () => Text('Receitas',
                      style: t.displaySmall?.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 0),
            child: TextField(
              onChanged: (v) => ref.read(filtroProvider.notifier).buscar(v),
              decoration: InputDecoration(
                hintText: 'Buscar receita',
                prefixIcon: const Icon(Icons.search, size: 19),
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(99),
                  borderSide: BorderSide(color: cores.linha),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(99),
                  borderSide: BorderSide(color: cores.linha),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(13, 9, 13, 4),
              children: [
                _Filtro(
                  texto: 'Todas',
                  ativo: filtro.categoria == null,
                  onTap: () =>
                      ref.read(filtroProvider.notifier).categoria(null),
                ),
                for (final c in CategoriaReceita.values)
                  _Filtro(
                    texto: rotuloCategoria(c),
                    ativo: filtro.categoria == c,
                    onTap: () =>
                        ref.read(filtroProvider.notifier).categoria(c),
                  ),
              ],
            ),
          ),
          Expanded(
            child: catalogo.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e', style: t.bodySmall)),
              data: (lista) => lista.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          'Nenhuma receita com esse filtro.\n'
                          'Toque no + para criar uma.',
                          textAlign: TextAlign.center,
                          style: t.bodyMedium?.copyWith(color: cores.ink3),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(13, 7, 13, 88),
                      itemCount: lista.length,
                      itemBuilder: (context, i) {
                        final r = lista[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    ReceitaScreen(receitaId: r.id),
                              )),
                              child: Container(
                                constraints:
                                    const BoxConstraints(minHeight: 52),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: cores.linha),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(r.nome,
                                              style: t.titleMedium,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${rotuloCategoria(r.categoria)} · '
                                            '${r.tempoPreparoMin} min · '
                                            'rende ${r.rendimentoPorcoes}',
                                            style: t.labelMedium
                                                ?.copyWith(color: cores.ink3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (r.origem == 'usuario')
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8),
                                        child: Icon(Icons.edit_outlined,
                                            size: 15, color: cores.ink3),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Filtro extends StatelessWidget {
  final String texto;
  final bool ativo;
  final VoidCallback onTap;

  const _Filtro({
    required this.texto,
    required this.ativo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ChoiceChip(
        label: Text(texto),
        selected: ativo,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: cores.marinho,
        backgroundColor: Theme.of(context).colorScheme.surface,
        side: BorderSide(color: ativo ? cores.marinho : cores.linha),
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ativo ? Colors.white : cores.ink2),
      ),
    );
  }
}
