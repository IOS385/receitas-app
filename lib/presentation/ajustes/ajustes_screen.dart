import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/backup.dart';
import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'ajustes_provider.dart';

class AjustesScreen extends ConsumerWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final resumo = ref.watch(resumoProvider);
    final regras = ref.watch(regrasPorcaoProvider);
    final modo = ref.watch(temaModoProvider).value ?? ThemeMode.system;

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
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.chevron_left, size: 19),
                      label: const Text('Voltar'),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: const Size(44, 44)),
                    ),
                  ],
                ),
                Text('Ajustes',
                    style: t.displaySmall?.copyWith(color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Grupo(titulo: 'O ciclo', children: [
                  resumo.maybeWhen(
                    data: (r) => _Linha(
                      titulo: 'Começou em',
                      nota: 'o dia 1 das receitas caiu aqui',
                      valor: DataPura(r.inicio).rotuloCurto,
                      onTap: () => _escolherInicio(context, ref, r.inicio),
                    ),
                    orElse: () => const _Linha(
                        titulo: 'Começou em', nota: '', valor: '…'),
                  ),
                  resumo.maybeWhen(
                    data: (r) => _Linha(
                      titulo: 'Tamanho do ciclo',
                      nota: 'volta pro dia 1 depois disso',
                      valor: '${r.tamanho} dias',
                    ),
                    orElse: () => const _Linha(
                        titulo: 'Tamanho do ciclo', nota: '', valor: '…'),
                  ),
                ]),

                _Grupo(titulo: 'Porções', children: [
                  regras.maybeWhen(
                    data: (m) => _TabelaPorcoes(regras: m),
                    orElse: () => const SizedBox(height: 40),
                  ),
                ]),

                _Grupo(titulo: 'Aparência', children: [
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                          value: ThemeMode.light, label: Text('Claro')),
                      ButtonSegment(
                          value: ThemeMode.dark, label: Text('Escuro')),
                      ButtonSegment(
                          value: ThemeMode.system, label: Text('Sistema')),
                    ],
                    selected: {modo},
                    onSelectionChanged: (s) =>
                        ref.read(temaModoProvider.notifier).definir(s.first),
                  ),
                ]),

                _Grupo(titulo: 'Seus dados', children: [
                  _Linha(
                    titulo: 'Exportar backup',
                    nota: 'um arquivo .json com tudo',
                    valor: '→',
                    onTap: () => _exportar(context, ref),
                  ),
                  _Linha(
                    titulo: 'Importar backup',
                    nota: 'substitui o que está no aparelho',
                    valor: '→',
                    onTap: () => _importar(context, ref),
                  ),
                ]),

                _Grupo(titulo: 'Sobre', children: [
                  resumo.maybeWhen(
                    data: (r) => _Linha(
                      titulo: 'No aparelho',
                      nota: '${r.receitas} receitas · ${r.combos} refeições · '
                          '${r.alimentos} alimentos',
                      valor: '',
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const _Linha(
                    titulo: 'Funciona sem internet',
                    nota: 'nada sai do telefone',
                    valor: '✓',
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _escolherInicio(
      BuildContext context, WidgetRef ref, String atual) async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: DataPura(atual).comoDateTime,
      firstDate: DateTime.utc(2020),
      lastDate: DateTime.utc(2035),
      helpText: 'Quando o dia 1 do ciclo caiu',
    );
    if (escolhida == null) return;

    await ref
        .read(repoConfigProvider)
        .definir('data_inicio_ciclo', DataPura.de(escolhida).iso);
    ref.invalidate(resumoProvider);
    ref.invalidate(diaProvider);
  }

  Future<void> _exportar(BuildContext context, WidgetRef ref) async {
    final texto = await exportarJson(ref.read(bancoProvider));
    final pasta = await getTemporaryDirectory();
    final arquivo = File(p.join(pasta.path,
        'refeicoes-backup-${DataPura.de(DateTime.now()).iso}.json'));
    await arquivo.writeAsString(texto);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(arquivo.path)],
        text: 'Backup do app de refeições',
      ),
    );
  }

  Future<void> _importar(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importar backup?'),
        content: const Text(
            'Tudo que está no aparelho é substituído pelo conteúdo do '
            'arquivo. Não tem como desfazer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Importar')),
        ],
      ),
    );
    if (ok != true) return;

    final escolha = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (escolha.isEmpty) return;
    final caminho = escolha.first.path;
    if (caminho == null) return;

    try {
      final texto = await File(caminho).readAsString();
      await importarJson(ref.read(bancoProvider), texto);
      // Os OITO, nao tres: ver `providersDoBanco`.
      for (final p in providersDoBanco) {
        ref.invalidate(p);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup importado.')));
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Não deu: $e')));
      }
    }
  }
}

class _Grupo extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const _Grupo({required this.titulo, required this.children});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(titulo.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary)),
            ),
            ...children,
          ],
        ),
      );
}

class _Linha extends StatelessWidget {
  final String titulo;
  final String nota;
  final String valor;
  final VoidCallback? onTap;

  const _Linha({
    required this.titulo,
    required this.nota,
    required this.valor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    final corpo = Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(titulo,
                    style: t.bodyMedium?.copyWith(
                        fontVariations: const [FontVariation('wght', 700)])),
                if (nota.isNotEmpty)
                  Text(nota,
                      style: t.bodySmall?.copyWith(color: cores.ink3)),
              ],
            ),
          ),
          if (valor.isNotEmpty)
            Text(valor,
                style: t.labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );

    if (onTap == null) {
      return Padding(padding: const EdgeInsets.only(bottom: 5), child: corpo);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: corpo,
        ),
      ),
    );
  }
}

class _TabelaPorcoes extends StatelessWidget {
  final Map<(SlotRefeicao, bool), int> regras;
  const _TabelaPorcoes({required this.regras});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    Widget celula(String texto, {bool cabecalho = false, Color? cor}) =>
        Expanded(
          child: Center(
            child: Text(
              texto,
              style: cabecalho
                  ? t.labelSmall?.copyWith(color: cores.ink3, fontSize: 8.5)
                  : t.titleMedium?.copyWith(color: cor),
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: cores.superficie2,
              border: Border(bottom: BorderSide(color: cores.linha)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('REFEIÇÃO',
                      style: t.labelSmall
                          ?.copyWith(color: cores.ink3, fontSize: 8.5)),
                ),
                celula('SEG–SEX', cabecalho: true),
                celula('SÁB–DOM', cabecalho: true),
              ],
            ),
          ),
          for (final slot in SlotRefeicao.values)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                border: slot == SlotRefeicao.jantar
                    ? null
                    : Border(bottom: BorderSide(color: cores.linha)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(rotuloSlot(slot),
                        style: t.bodyMedium?.copyWith(color: cores.ink2)),
                  ),
                  celula('${regras[(slot, true)] ?? 1}'),
                  celula('${regras[(slot, false)] ?? 1}', cor: cores.brasa),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
