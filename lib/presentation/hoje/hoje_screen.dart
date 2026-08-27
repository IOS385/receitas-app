import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repo_plano.dart';
import '../../domain/modelos.dart';
import '../ajustes/ajustes_screen.dart';
import '../format.dart';
import '../receitas/receita_screen.dart';
import '../substituir/substituir_sheet.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import '../widgets/cartao_esmalte.dart';
import 'hoje_provider.dart';

class HojeScreen extends ConsumerWidget {
  const HojeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dia = ref.watch(diaProvider);
    final data = ref.watch(dataSelecionadaProvider);

    return Scaffold(
      body: dia.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e', textAlign: TextAlign.center),
          ),
        ),
        data: (d) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(diaProvider),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _Cabecalho(dia: d),
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 13, 11, 24),
                child: Column(
                  children: [
                    for (final r in d.refeicoes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BlocoRefeicao(
                          refeicao: r,
                          data: data,
                          porcoesBase: d.refeicoes
                              .firstWhere((b) => b.slot == slotBaseDe(r.slot),
                                  orElse: () => r)
                              .porcoes,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cabecalho extends ConsumerWidget {
  final DiaResolvido dia;
  const _Cabecalho({required this.dia});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final dt = dia.data.comoDateTime;

    return CampoRespingo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${mesNome(dt.month)} ${dt.year}'.toUpperCase(),
                  style: t.labelSmall?.copyWith(color: Colors.white70),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                tooltip: 'Ajustes',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AjustesScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dt.day.toString().padLeft(2, '0'),
                  style: t.displayLarge?.copyWith(color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(diaDaSemana(dia.data).toUpperCase(),
                          style:
                              t.labelSmall?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 2),
                      Text('dia ${dia.posicao} de ${dia.tamanhoCiclo}',
                          style: t.labelMedium
                              ?.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${dia.total.kcal.round()}',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white)),
                    Text('KCAL NO DIA',
                        style: t.labelSmall
                            ?.copyWith(color: Colors.white70, fontSize: 8.5)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Um dos quatro horários do dia. Espelhado vem apagado, sem aro e sem rodapé.
class BlocoRefeicao extends ConsumerWidget {
  final RefeicaoDoDia refeicao;
  final DataPura data;

  /// Porções do slot de onde este repete. Serve para dizer "em dobro" só
  /// quando é dobro de verdade — no fim de semana almoço e jantar empatam.
  final int porcoesBase;

  const BlocoRefeicao({
    super.key,
    required this.refeicao,
    required this.data,
    required this.porcoesBase,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;
    final espelhado = refeicao.espelhoIntacto && ehEspelhadoSlot(refeicao.slot);

    return CartaoEsmalte(
      apagado: espelhado,
      onTap: refeicao.componentes.isEmpty
          ? null
          : () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ReceitaScreen(
                    receitaId: refeicao.componentes.first.receitaId),
              )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(rotuloSlot(refeicao.slot).toUpperCase(),
                    style: t.labelSmall?.copyWith(
                        color: espelhado
                            ? cores.ink3
                            : Theme.of(context).colorScheme.primary)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 2.5),
                decoration: BoxDecoration(
                  color: cores.superficie2,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: cores.linha),
                ),
                child: Text(porcoesTexto(refeicao.porcoes),
                    style: t.labelMedium?.copyWith(color: cores.ink2)),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(refeicao.comboNome,
              style: t.titleLarge
                  ?.copyWith(color: espelhado ? cores.ink3 : null)),
          const SizedBox(height: 9),
          if (espelhado) ...[
            Text(
              // Derivado das porções: no sábado almoço = 2 e jantar = 2, e
              // "em dobro" ao lado de dois selos "2 porções" e mentira.
              // A spec seção 10 pede só "repete o almoço".
              'repete o ${rotuloSlot(slotBaseDe(refeicao.slot)).toLowerCase()}'
              '${refeicao.porcoes == porcoesBase * 2 ? ', em dobro' : ''}',
              style: t.bodySmall
                  ?.copyWith(color: cores.ink3, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 7),
            for (final c in refeicao.componentes)
              _LinhaComponente(componente: c),
          ] else ...[
            for (final c in refeicao.componentes)
              _LinhaComponente(componente: c),
            const SizedBox(height: 11),
            Divider(height: 1, color: cores.linha),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${refeicao.nutrientes.kcal.round()} kcal · '
                    '${refeicao.nutrientes.proteina.round()} g prot',
                    style: t.labelMedium?.copyWith(color: cores.ink3),
                  ),
                ),
                TextButton(
                  onPressed: () => abrirSubstituir(
                      context: context, data: data, refeicao: refeicao),
                  style: TextButton.styleFrom(
                    foregroundColor: cores.brasa,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: const Size(44, 44),
                  ),
                  child: Text('SUBSTITUIR',
                      style: t.labelSmall?.copyWith(color: cores.brasa)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LinhaComponente extends StatelessWidget {
  final ComponenteDoDia componente;
  const _LinhaComponente({required this.componente});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    // A medida principal do componente: o primeiro ingrediente COM MEDIDA
    // (qualquer unidade que nao seja `aGosto`/`pitada`) — pode ser discreta,
    // como `2 fatia`, nao necessariamente massa. A ordem vem do cadastro da
    // receita, onde o ingrediente principal vem primeiro.
    final principal = componente.ingredientes.firstWhere(
      (i) => !unidadesSemMedida.contains(i.unidade),
      orElse: () => componente.ingredientes.isEmpty
          ? const IngredienteEscalado(
              alimentoId: 0, nome: '', quantidade: 0, unidade: Unidade.g)
          : componente.ingredientes.first,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                Text(componente.nome, style: t.bodyMedium?.copyWith(color: cores.ink2)),
          ),
          const SizedBox(width: 10),
          Text(qtd(principal.quantidade, principal.unidade),
              style: t.labelMedium?.copyWith(color: cores.ink3)),
        ],
      ),
    );
  }
}
