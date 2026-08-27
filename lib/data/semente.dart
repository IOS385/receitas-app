import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/modelos.dart';
import '../domain/porcoes.dart';
import 'app_database.dart';

/// Carrega a semente para dentro do banco, de forma idempotente.
///
/// Rodar duas vezes não duplica nada. Linha que a usuária editou — marcada com
/// `origem = 'usuario'` — nunca é sobrescrita (spec seção 12).
Future<void> carregarSemente(
  AppDatabase db, {
  required String Function(String nome) lerAsset,
  required int versao,
}) async {
  List<dynamic> ler(String nome) =>
      jsonDecode(lerAsset(nome)) as List<dynamic>;

  await db.transaction(() async {
    // --- alimentos
    for (final raw in ler('alimentos.json')) {
      final a = raw as Map<String, dynamic>;
      await db.into(db.alimentos).insertOnConflictUpdate(AlimentosCompanion(
            id: Value(a['id'] as int),
            nome: Value(a['nome'] as String),
            tacoCodigo: Value(a['taco'] as String?),
            kcal100g: Value((a['kcal'] as num).toDouble()),
            carboidratoG: Value((a['carb'] as num).toDouble()),
            proteinaG: Value((a['prot'] as num).toDouble()),
            gorduraG: Value((a['gord'] as num).toDouble()),
            fibraG: Value((a['fibra'] as num).toDouble()),
            sodioMg: Value((a['sodio'] as num).toDouble()),
            secaoMercado:
                Value(SecaoMercado.values.byName(a['secao'] as String)),
            unidadeCompra:
                Value(UnidadeCompra.values.byName(a['compra'] as String)),
          ));
    }

    // --- conversoes
    for (final raw in ler('conversoes.json')) {
      final c = raw as Map<String, dynamic>;
      await db.into(db.conversoes).insertOnConflictUpdate(ConversoesCompanion(
            alimentoId: Value(c['alimento'] as int),
            unidade: Value(Unidade.values.byName(c['unidade'] as String)),
            gramas: Value((c['gramas'] as num).toDouble()),
          ));
    }

    // --- receitas e ingredientes
    for (final raw in ler('receitas.json')) {
      final r = raw as Map<String, dynamic>;
      final id = r['id'] as int;

      final existente = await (db.select(db.receitas)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

      // O que ela encostou é dela: seed nunca sobrescreve.
      if (existente != null && existente.origem == 'usuario') continue;

      await db.into(db.receitas).insertOnConflictUpdate(ReceitasCompanion(
            id: Value(id),
            nome: Value(r['nome'] as String),
            categoria:
                Value(CategoriaReceita.values.byName(r['categoria'] as String)),
            rendimentoPorcoes: Value(r['rende'] as int),
            tempoPreparoMin: Value(r['tempo'] as int),
            modoPreparo: Value(r['preparo'] as String),
            origem: const Value('seed'),
          ));

      await (db.delete(db.receitaIngredientes)
            ..where((t) => t.receitaId.equals(id)))
          .go();

      final ingredientes = r['ingredientes'] as List<dynamic>;
      for (var i = 0; i < ingredientes.length; i++) {
        final ing = ingredientes[i] as Map<String, dynamic>;
        await db
            .into(db.receitaIngredientes)
            .insert(ReceitaIngredientesCompanion.insert(
              receitaId: id,
              alimentoId: ing['alimento'] as int,
              ordem: i,
              quantidade: (ing['quantidade'] as num).toDouble(),
              unidade: Unidade.values.byName(ing['unidade'] as String),
              observacao: Value(ing['observacao'] as String?),
            ));
      }
    }

    // --- combos
    for (final raw in ler('combos.json')) {
      final c = raw as Map<String, dynamic>;
      final id = c['id'] as int;

      await db.into(db.combos).insertOnConflictUpdate(CombosCompanion(
            id: Value(id),
            nome: Value(c['nome'] as String),
            tipo: Value(TipoCombo.values.byName(c['tipo'] as String)),
            origem: const Value('seed'),
          ));

      await (db.delete(db.comboReceitas)..where((t) => t.comboId.equals(id)))
          .go();

      final receitas = (c['receitas'] as List<dynamic>).cast<int>();
      for (var i = 0; i < receitas.length; i++) {
        await db.into(db.comboReceitas).insert(ComboReceitasCompanion.insert(
              comboId: id,
              receitaId: receitas[i],
              ordem: i,
            ));
      }
    }

    // --- ciclo
    var maiorPosicao = 0;
    for (final raw in ler('ciclo.json')) {
      final c = raw as Map<String, dynamic>;
      final posicao = c['posicao'] as int;
      if (posicao > maiorPosicao) maiorPosicao = posicao;
      await db.into(db.cicloItens).insertOnConflictUpdate(CicloItensCompanion(
            posicao: Value(posicao),
            tipoSlot: Value(TipoCombo.values.byName(c['tipo'] as String)),
            comboId: Value(c['combo'] as int),
          ));
    }

    // --- regras de porcao
    for (final entrada in regrasPadrao.entries) {
      final (slot, util) = entrada.key;
      await db.into(db.regrasPorcao).insertOnConflictUpdate(
          RegrasPorcaoCompanion(
              slot: Value(slot),
              diaUtil: Value(util),
              porcoes: Value(entrada.value)));
    }

    // --- config: só grava o que ainda não existe, para não pisar na escolha dela
    Future<void> configPadrao(String chave, String valor) async {
      final atual = await (db.select(db.config)
            ..where((t) => t.chave.equals(chave)))
          .getSingleOrNull();
      if (atual != null) return;
      await db
          .into(db.config)
          .insert(ConfigCompanion.insert(chave: chave, valor: valor));
    }

    // O tamanho vem do proprio ciclo.json, nao de um numero cravado aqui.
    // Fixar 33 com 4 posicoes cadastradas transforma conteudo parcial em
    // travamento duro: `resolverRefeicao` estoura StateError na primeira
    // posicao sem combo, e o Mercado (sete dias seguidos) sempre pega uma.
    await configPadrao('tamanho_ciclo', '$maiorPosicao');
    await configPadrao(
        'data_inicio_ciclo', DataPura.de(DateTime.now()).iso);
    await configPadrao('tema', 'sistema');

    await db.into(db.config).insertOnConflictUpdate(
        ConfigCompanion.insert(chave: 'seed_version', valor: '$versao'));
  });
}
