import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repo_plano.dart';
import '../../domain/espelho.dart';
import '../../domain/modelos.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../mes/mes_provider.dart';
import '../tema/cores.dart';
import '../widgets/foto_prato.dart';

/// Abre a folha de substituição de uma refeição.
Future<void> abrirSubstituir({
  required BuildContext context,
  required DataPura data,
  required RefeicaoDoDia refeicao,
}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SubstituirSheet(data: data, refeicao: refeicao),
    );

class SubstituirSheet extends ConsumerWidget {
  final DataPura data;
  final RefeicaoDoDia refeicao;

  const SubstituirSheet({
    super.key,
    required this.data,
    required this.refeicao,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;
    final combos = ref.watch(_combosProvider(tipoDoSlot(refeicao.slot)));

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cores.marinho, width: 2.5)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .84,
      ),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 13),
                decoration: BoxDecoration(
                  color: cores.linha,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Text('Substituir ${rotuloSlot(refeicao.slot).toLowerCase()}',
                style: t.titleLarge),
            const SizedBox(height: 3),
            Text(
              '${dataLonga(data)} · ${porcoesTexto(refeicao.porcoes)} · '
              'só neste dia',
              style: t.labelMedium?.copyWith(color: cores.ink3),
            ),
            const SizedBox(height: 16),

            // Ordem: componente ANTES do combo, e a inversao e deliberada.
            //
            // Com os 33 dias, a lista de refeicoes inteiras tem 32 opcoes, cada
            // uma com foto: cerca de 5300 dp. Combo primeiro deixava o segundo
            // nivel inalcancavel na pratica. Componente primeiro custa ~250 dp
            // ao caso comum (cinco linhas curtas) e a primeira foto ainda
            // aparece sem rolar, nos 769 dp da folha.
            _Rotulo('Trocar só um componente'),
            for (final comp in refeicao.componentes)
              _Opcao(
                titulo: comp.nome,
                subtitulo: rotuloCategoria(comp.categoria),
                onTap: () => _trocarComponente(context, ref, comp),
              ),

            const SizedBox(height: 6),
            _Rotulo('Ou trocar a refeição inteira'),
            combos.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e', style: t.bodySmall),
              data: (lista) => Column(
                children: [
                  for (final c in lista.where((c) => c.id != refeicao.comboId))
                    _Opcao(
                      titulo: c.nome,
                      // Sem subtítulo: a foto do prato diz o que "combo 5"
                      // nunca disse a ela.
                      foto: c.fotoPath,
                      onTap: () async {
                        await ref.read(repoPlanoProvider).substituirCombo(
                            data: data, slot: refeicao.slot, comboId: c.id);
                        ref.invalidate(diaProvider);
                        ref.invalidate(diasEditadosProvider);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () async {
                await ref
                    .read(repoPlanoProvider)
                    .limparOverrides(data, refeicao.slot);
                ref.invalidate(diaProvider);
                ref.invalidate(diasEditadosProvider);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Voltar ao plano original'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _trocarComponente(
    BuildContext context,
    WidgetRef ref,
    ComponenteDoDia comp,
  ) async {
    final alternativas = await ref
        .read(repoReceitasProvider)
        .listar(categoria: comp.categoria);

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15),
          children: [
            Text('Trocar ${comp.nome}',
                style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final r in alternativas.where((r) => r.id != comp.receitaId))
              ListTile(
                title: Text(r.nome),
                subtitle: Text('${r.tempoPreparoMin} min'),
                onTap: () async {
                  await ref.read(repoPlanoProvider).substituirComponente(
                        data: data,
                        slot: refeicao.slot,
                        receitaOriginalId: comp.receitaId,
                        receitaNovaId: r.id,
                      );
                  ref.invalidate(diaProvider);
                  ref.invalidate(diasEditadosProvider);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('Tirar do prato hoje'),
              onTap: () async {
                await ref.read(repoPlanoProvider).substituirComponente(
                      data: data,
                      slot: refeicao.slot,
                      receitaOriginalId: comp.receitaId,
                      receitaNovaId: null,
                    );
                ref.invalidate(diaProvider);
                ref.invalidate(diasEditadosProvider);
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

final _combosProvider =
    FutureProvider.family<List<Combo>, TipoCombo>((ref, tipo) =>
        ref.watch(repoReceitasProvider).combosDoTipo(tipo));

class _Rotulo extends StatelessWidget {
  final String texto;
  const _Rotulo(this.texto);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(texto,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary)),
      );
}

class _Opcao extends StatelessWidget {
  final String titulo;

  /// Nulo quando a foto já diz o que o subtítulo diria.
  final String? subtitulo;

  /// Foto do prato, quando a opção é um combo inteiro. Componente solto
  /// (uma receita) não tem foto.
  final String? foto;

  final VoidCallback onTap;

  const _Opcao({
    required this.titulo,
    this.subtitulo,
    this.foto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: cores.linha),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FotoPrato(caminho: foto),
                if (foto != null) const SizedBox(height: 9),
                Text(titulo,
                    style: t.bodyMedium
                        ?.copyWith(fontVariations: const [
                      FontVariation('wght', 700)
                    ])),
                if (subtitulo != null) ...[
                  const SizedBox(height: 1),
                  Text(subtitulo!,
                      style: t.labelMedium?.copyWith(color: cores.ink3)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
