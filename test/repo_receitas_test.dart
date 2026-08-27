import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_receitas.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

import 'util_teste.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

void main() {
  late AppDatabase db;
  late RepoReceitas repo;

  setUp(() async {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    repo = RepoReceitas(db);
  });
  tearDown(() async => db.close());

  test('listar traz as receitas ativas da semente', () async {
    expect(await repo.listar(), hasLength(quantosNaSemente('receitas.json')));
  });

  test('listar filtra por categoria', () async {
    final proteinas = await repo.listar(categoria: CategoriaReceita.proteina);
    expect(proteinas, isNotEmpty);
    expect(proteinas.every((r) => r.categoria == CategoriaReceita.proteina),
        isTrue);
    expect(proteinas.length,
        lessThan(quantosNaSemente('receitas.json')));
  });

  test('listar filtra por busca, sem diferenciar maiuscula', () async {
    final r = await repo.listar(busca: 'TAPIOCA');
    // Tres receitas de tapioca depois dos 33 dias. O que o teste prova e a
    // insensibilidade a caixa, nao a quantidade.
    expect(r, isNotEmpty);
    expect(r.every((x) => x.nome.toLowerCase().contains('tapioca')), isTrue);
  });

  test('salvar nova receita marca origem usuario', () async {
    final id = await repo.salvar(
      nome: 'Sopa de teste',
      categoria: CategoriaReceita.proteina,
      rendimentoPorcoes: 1,
      tempoPreparoMin: 10,
      modoPreparo: 'Bata os ovos.\nMexa em fogo baixo.',
      ingredientes: [
        (alimentoId: 25, quantidade: 2, unidade: Unidade.unidade, observacao: null),
      ],
    );

    final r = await repo.porId(id);
    expect(r!.origem, 'usuario');
    expect(await repo.ingredientesDe(id), hasLength(1));
  });

  test('salvar receita de semente transfere a posse para o usuario', () async {
    final antes = await repo.porId(1);
    expect(antes!.origem, 'seed');

    await repo.salvar(
      id: 1,
      nome: 'Arroz do jeito dela',
      categoria: antes.categoria,
      rendimentoPorcoes: antes.rendimentoPorcoes,
      tempoPreparoMin: antes.tempoPreparoMin,
      modoPreparo: antes.modoPreparo,
      ingredientes: [
        (alimentoId: 1, quantidade: 150, unidade: Unidade.g, observacao: null),
      ],
    );

    final depois = await repo.porId(1);
    expect(depois!.nome, 'Arroz do jeito dela');
    expect(depois.origem, 'usuario');
  });

  test('salvar substitui a lista de ingredientes inteira', () async {
    final antes = (await repo.ingredientesDe(1)).length;
    expect(antes, greaterThan(1));

    final r = await repo.porId(1);
    await repo.salvar(
      id: 1,
      nome: r!.nome,
      categoria: r.categoria,
      rendimentoPorcoes: r.rendimentoPorcoes,
      tempoPreparoMin: r.tempoPreparoMin,
      modoPreparo: r.modoPreparo,
      ingredientes: [
        (alimentoId: 1, quantidade: 100, unidade: Unidade.g, observacao: null),
      ],
    );

    expect(await repo.ingredientesDe(1), hasLength(1),
        reason: 'a lista antiga tem de ser substituida, nao acrescentada');
  });

  test('excluir desativa em vez de apagar', () async {
    await repo.excluir(22);

    expect(await repo.porId(22), isNotNull,
        reason: 'a linha continua no banco para nao abrir buraco no historico');
    expect((await repo.porId(22))!.ativa, isFalse);
    expect((await repo.listar()).any((r) => r.id == 22), isFalse);
  });

  test('combosDoTipo separa cafe de refeicao', () async {
    final cafes = await repo.combosDoTipo(TipoCombo.cafe);
    final refeicoes = await repo.combosDoTipo(TipoCombo.refeicao);

    expect(cafes, hasLength(tamanhoDoCiclo()));
    expect(refeicoes, hasLength(tamanhoDoCiclo()));
    expect(cafes.every((c) => c.tipo == TipoCombo.cafe), isTrue);
  });
}
