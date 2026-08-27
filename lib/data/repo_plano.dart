import 'package:drift/drift.dart';

import '../domain/ciclo.dart';
import '../domain/escalonamento.dart';
import '../domain/modelos.dart';
import '../domain/nutricao.dart';
import '../domain/porcoes.dart';
import '../domain/resolucao.dart';
import 'app_database.dart';
import 'repo_config.dart';

class IngredienteEscalado {
  final int alimentoId;
  final String nome;
  final double quantidade;
  final Unidade unidade;
  final String? observacao;

  const IngredienteEscalado({
    required this.alimentoId,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    this.observacao,
  });
}

class ComponenteDoDia {
  final int receitaId;
  final String nome;
  final CategoriaReceita categoria;
  final List<IngredienteEscalado> ingredientes;
  final Nutrientes nutrientes;

  const ComponenteDoDia({
    required this.receitaId,
    required this.nome,
    required this.categoria,
    required this.ingredientes,
    required this.nutrientes,
  });
}

class RefeicaoDoDia {
  final SlotRefeicao slot;
  final int porcoes;
  final int comboId;
  final String comboNome;

  /// Asset da foto do prato, ou nulo. Vem do combo, nao da receita.
  final String? comboFoto;

  final bool espelhoIntacto;
  final List<ComponenteDoDia> componentes;
  final Nutrientes nutrientes;

  const RefeicaoDoDia({
    required this.slot,
    required this.porcoes,
    required this.comboId,
    required this.comboNome,
    required this.comboFoto,
    required this.espelhoIntacto,
    required this.componentes,
    required this.nutrientes,
  });
}

class DiaResolvido {
  final DataPura data;
  final int posicao;
  final int tamanhoCiclo;
  final List<RefeicaoDoDia> refeicoes;

  const DiaResolvido({
    required this.data,
    required this.posicao,
    required this.tamanhoCiclo,
    required this.refeicoes,
  });

  Nutrientes get total =>
      refeicoes.fold(Nutrientes.zero, (a, r) => a + r.nutrientes);
}

class RepoPlano {
  final AppDatabase db;
  final RepoConfig config;

  const RepoPlano(this.db, this.config);

  /// Monta o dia inteiro: quatro slots resolvidos, escalados e somados.
  Future<DiaResolvido> dia(DataPura data) async {
    final inicio = await config.inicioCiclo();
    final tamanho = await config.tamanhoCiclo();
    final regrasPorcao = await config.regras();
    final posicao =
        posicaoNoCiclo(inicio: inicio, data: data, tamanho: tamanho);

    final ciclo = {
      for (final c in await db.select(db.cicloItens).get())
        (c.posicao, c.tipoSlot): c.comboId,
    };

    final componentesDoCombo = <int, List<int>>{};
    final ligacoes = await (db.select(db.comboReceitas)
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get();
    for (final l in ligacoes) {
      componentesDoCombo.putIfAbsent(l.comboId, () => []).add(l.receitaId);
    }

    final overridesCombo = {
      for (final o in await (db.select(db.overridesCombo)
            ..where((t) => t.data.equals(data.iso)))
          .get())
        (o.data, o.slot): o.comboId,
    };

    final overridesComponente =
        <(DataPura, SlotRefeicao), Map<int, int?>>{};
    for (final o in await (db.select(db.overridesComponente)
          ..where((t) => t.data.equals(data.iso)))
        .get()) {
      overridesComponente
          .putIfAbsent((o.data, o.slot), () => {})[o.receitaOriginalId] =
          o.receitaNovaId;
    }

    final combos = {
      for (final c in await db.select(db.combos).get()) c.id: c,
    };
    final receitas = {
      for (final r in await db.select(db.receitas).get()) r.id: r,
    };
    final alimentos = {
      for (final a in await db.select(db.alimentos).get()) a.id: a,
    };

    final conversoes = <int, Map<Unidade, double>>{};
    for (final c in await db.select(db.conversoes).get()) {
      conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
    }

    final ingredientesPorReceita = <int, List<ReceitaIngrediente>>{};
    for (final i in await (db.select(db.receitaIngredientes)
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get()) {
      ingredientesPorReceita.putIfAbsent(i.receitaId, () => []).add(i);
    }

    final refeicoes = <RefeicaoDoDia>[];
    for (final slot in SlotRefeicao.values) {
      final porcoes =
          porcoesDoSlot(slot: slot, data: data, regras: regrasPorcao);

      final res = resolverRefeicao(
        data: data,
        slot: slot,
        posicao: posicao,
        porcoes: porcoes,
        ciclo: ciclo,
        componentesDoCombo: componentesDoCombo,
        overridesCombo: overridesCombo,
        overridesComponente: overridesComponente,
      );

      final componentes = <ComponenteDoDia>[];
      var nutrRefeicao = Nutrientes.zero;

      for (final rid in res.receitaIds) {
        final receita = receitas[rid];
        if (receita == null) continue;

        final escalados = <IngredienteEscalado>[];
        var nutrReceita = Nutrientes.zero;

        for (final ing in ingredientesPorReceita[rid] ?? const []) {
          final quantidade = escalarQuantidade(
            quantidade: ing.quantidade,
            unidade: ing.unidade,
            porcoes: porcoes,
            rendimento: receita.rendimentoPorcoes,
          );
          final alimento = alimentos[ing.alimentoId];
          if (alimento == null) continue;

          escalados.add(IngredienteEscalado(
            alimentoId: alimento.id,
            nome: alimento.nome,
            quantidade: quantidade,
            unidade: ing.unidade,
            observacao: ing.observacao,
          ));

          // Nutrição sobre a quantidade JÁ arredondada (spec seção 7).
          final gramas = emGramas(
            unidade: ing.unidade,
            quantidade: quantidade,
            conversoes: conversoes[alimento.id] ?? const {},
            alimentoId: alimento.id,
          );
          nutrReceita = nutrReceita +
              nutrienteDe(
                por100g: Nutrientes(
                  kcal: alimento.kcal100g,
                  carboidrato: alimento.carboidratoG,
                  proteina: alimento.proteinaG,
                  gordura: alimento.gorduraG,
                  fibra: alimento.fibraG,
                  sodio: alimento.sodioMg,
                ),
                gramas: gramas,
              );
        }

        componentes.add(ComponenteDoDia(
          receitaId: rid,
          nome: receita.nome,
          categoria: receita.categoria,
          ingredientes: escalados,
          nutrientes: nutrReceita,
        ));
        nutrRefeicao = nutrRefeicao + nutrReceita;
      }

      refeicoes.add(RefeicaoDoDia(
        slot: slot,
        porcoes: porcoes,
        comboId: res.comboId,
        comboNome: combos[res.comboId]?.nome ?? '',
        comboFoto: combos[res.comboId]?.fotoPath,
        espelhoIntacto: res.espelhoIntacto,
        componentes: componentes,
        nutrientes: nutrRefeicao,
      ));
    }

    return DiaResolvido(
      data: data,
      posicao: posicao,
      tamanhoCiclo: tamanho,
      refeicoes: refeicoes,
    );
  }

  Future<void> substituirCombo({
    required DataPura data,
    required SlotRefeicao slot,
    required int comboId,
  }) =>
      db.into(db.overridesCombo).insertOnConflictUpdate(
          OverridesComboCompanion.insert(
              data: data, slot: slot, comboId: comboId));

  /// [receitaNovaId] nulo remove o componente do prato naquele dia.
  Future<void> substituirComponente({
    required DataPura data,
    required SlotRefeicao slot,
    required int receitaOriginalId,
    required int? receitaNovaId,
  }) =>
      db.into(db.overridesComponente).insertOnConflictUpdate(
          OverridesComponenteCompanion.insert(
            data: data,
            slot: slot,
            receitaOriginalId: receitaOriginalId,
            receitaNovaId: Value(receitaNovaId),
          ));

  /// Devolve o slot ao ciclo, restaurando o espelho.
  Future<void> limparOverrides(DataPura data, SlotRefeicao slot) async {
    await (db.delete(db.overridesCombo)
          ..where((t) => t.data.equals(data.iso) & t.slot.equalsValue(slot)))
        .go();
    await (db.delete(db.overridesComponente)
          ..where((t) => t.data.equals(data.iso) & t.slot.equalsValue(slot)))
        .go();
  }

  /// Datas do intervalo que têm alguma substituição — alimenta o ponto de
  /// brasa no calendário.
  Future<Set<DataPura>> diasEditados(DataPura de, DataPura ate) async {
    final combos = await (db.select(db.overridesCombo)
          ..where((t) => t.data.isBetweenValues(de.iso, ate.iso)))
        .get();
    final comps = await (db.select(db.overridesComponente)
          ..where((t) => t.data.isBetweenValues(de.iso, ate.iso)))
        .get();
    return {...combos.map((e) => e.data), ...comps.map((e) => e.data)};
  }
}
