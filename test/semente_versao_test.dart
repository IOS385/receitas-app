import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/database_provider.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/semente.dart';

import 'util_teste.dart';

/// Os cinco JSONs da semente, na ordem em que `semeaduraProvider` os carrega.
const _arquivos = [
  'alimentos.json',
  'conversoes.json',
  'receitas.json',
  'combos.json',
  'ciclo.json',
];

/// FNV-1a de 32 bits sobre os arquivos concatenados. Determinístico e sem
/// dependência nova — só precisa detectar que o conteúdo mudou.
int _impressao() {
  var h = 0x811C9DC5;
  for (final nome in _arquivos) {
    for (final u in lerSementeDoDisco(nome).codeUnits) {
      h = ((h ^ u) * 0x01000193) & 0xFFFFFFFF;
    }
  }
  return h;
}

/// Impressão do conteúdo de cada versão da semente. **Uma linha por versão.**
///
/// Mudar um JSON sem subir [versaoSemente] reprova o teste abaixo — e é o que
/// tem de acontecer: sem subir a versão, o app já instalado no aparelho dela
/// nunca recarrega e a mudança fica invisível.
const _impressoes = <int, int>{
  2: 2473329268,
  3: 870492733,
  // Mesma impressao da 3 de proposito: a 4 nao mudou conteudo, subiu para
  // forcar a recarga e consertar `tamanho_ciclo`. O invariante desta tabela e
  // "conteudo mudou => versao sobe", nao o contrario.
  4: 870492733,
};

void main() {
  test('mudar a semente sem subir versaoSemente reprova', () {
    expect(_impressoes.containsKey(versaoSemente), isTrue,
        reason: 'versaoSemente $versaoSemente nao tem impressao registrada — '
            'rode o teste, pegue o valor do erro e some uma linha em _impressoes');

    expect(_impressao(), _impressoes[versaoSemente],
        reason: 'o conteudo de assets/semente/ mudou desde a versao '
            '$versaoSemente. Suba versaoSemente e registre a impressao nova. '
            'Sem isso a mudanca so aparece em instalacao limpa: o app dela '
            'compara seed_version e volta calado.');
  });

  test('as fotos chegam num banco que veio da versao antiga', () async {
    // O caminho que falhou de verdade. `bancoDeTeste()` sempre semeia do zero,
    // entao a suite inteira era cega para a atualizacao por cima.
    final db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
    addTearDown(db.close);

    // --- estado de quem ja tinha o APK: semente na versao 1, sem foto e com
    // um ciclo de 4 dias
    await carregarSemente(db, lerAsset: lerSementeDoDisco, versao: 1);
    await db.update(db.combos).write(const CombosCompanion(
          fotoPath: Value(null),
        ));
    final config = RepoConfig(db);
    await config.definir('tamanho_ciclo', '4');
    await config.definir('tema', 'escuro');
    await config.definir('data_inicio_ciclo', '2026-01-15');

    // E uma receita que ela editou, para provar que a recarga nao a atropela.
    await (db.update(db.receitas)..where((t) => t.id.equals(1))).write(
        const ReceitasCompanion(
            nome: Value('Arroz do jeito dela'), origem: Value('usuario')));

    expect(await config.ler('seed_version'), '1');
    expect(
        (await db.select(db.combos).get()).every((c) => c.fotoPath == null),
        isTrue,
        reason: 'ponto de partida: nenhum combo tem foto');

    // --- a guarda de semeaduraProvider tem de decidir recarregar
    final gravada = await config.ler('seed_version');
    expect(gravada == '$versaoSemente', isFalse,
        reason: 'com a versao igual o app volta calado e nada recarrega');

    // --- abertura do app novo
    await carregarSemente(db, lerAsset: lerSementeDoDisco, versao: versaoSemente);

    final combos = await db.select(db.combos).get();
    expect(combos, hasLength(quantosNaSemente('combos.json')));
    for (final c in combos) {
      expect(c.fotoPath, isNotNull,
          reason: 'combo ${c.id} ficou sem foto depois da recarga');
      expect(c.fotoPath, startsWith('assets/pratos/combo-'));
    }

    final dela = await (db.select(db.receitas)..where((t) => t.id.equals(1)))
        .getSingle();
    expect(dela.nome, 'Arroz do jeito dela',
        reason: 'a recarga nao pode desfazer o que ela editou');
    expect(dela.origem, 'usuario');

    expect(await config.ler('seed_version'), '$versaoSemente');

    // --- e a config derivada tem de ACOMPANHAR o conteudo novo
    //
    // Este bloco existe porque a versao 3 subiu de 4 para 33 dias e o aparelho
    // dele continuou voltando ao dia 1 no quinto dia: os 66 combos entraram, a
    // folha Substituir passou a lista-los, e `tamanho_ciclo` ficou em '4'
    // porque a semente o gravava so quando ausente — tratando dado derivado
    // como se fosse escolha dela.
    expect(await config.ler('tamanho_ciclo'), '${tamanhoDoCiclo()}',
        reason: 'tamanho_ciclo e DERIVADO do ciclo.json: recarga tem de '
            'atualizar, senao o ciclo trunca no tamanho antigo para sempre');
    expect(await config.tamanhoCiclo(), tamanhoDoCiclo());

    // --- ja a escolha dela NAO pode ser tocada
    expect(await config.ler('tema'), 'escuro',
        reason: 'tema e escolha dela, a semente nao pisa');
    expect(await config.ler('data_inicio_ciclo'), '2026-01-15',
        reason: 'a data de inicio que ela ajustou tem de sobreviver');
  });

  test('todo combo da semente aponta para uma foto', () {
    // Complementa o teste de disco em foto_prato_test: aqui a garantia e que o
    // JSON nao tem combo sem o campo, que passaria calado como null.
    final combos = lerSementeDoDisco('combos.json');
    expect(combos.split('"id"').length - 1, 66,
        reason: '33 posicoes x 2 tipos — cafe e refeicao');
    expect(combos.split('"foto"').length - 1, 66,
        reason: 'combo sem "foto" no JSON entra com foto_path nula e o cartao '
            'fica sem foto, sem erro nenhum');
  });
}
