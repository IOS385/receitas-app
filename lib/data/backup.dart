import 'dart:convert';
// drift.dart reexporta Uint8List hoje; import explícito para não depender
// disso se o reexport sumir numa atualização futura do drift.
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:drift/drift.dart';

import 'app_database.dart';

/// Formato do arquivo de backup. Subir só se o layout mudar de forma
/// incompatível.
const int formatoBackup = 1;

/// Serializa o banco inteiro num JSON legível.
Future<String> exportarJson(AppDatabase db) async {
  final tabelas = <String, List<Map<String, dynamic>>>{};

  for (final t in db.allTables) {
    final linhas = await db.customSelect('SELECT * FROM ${t.actualTableName}')
        .get();
    tabelas[t.actualTableName] =
        linhas.map((l) => Map<String, dynamic>.from(l.data)).toList();
  }

  final versao = tabelas['config']
      ?.firstWhere((l) => l['chave'] == 'seed_version',
          orElse: () => <String, dynamic>{'valor': null})['valor'];

  return const JsonEncoder.withIndent('  ').convert({
    'formato': formatoBackup,
    'seed_version': versao,
    'exportado_em': DateTime.now().toIso8601String(),
    'tabelas': tabelas,
  });
}

/// Substitui o conteúdo do aparelho pelo do arquivo.
///
/// Roda inteiro dentro de uma transação: JSON quebrado no meio não deixa o
/// banco pela metade.
Future<void> importarJson(AppDatabase db, String texto) async {
  final Map<String, dynamic> mapa;
  try {
    mapa = jsonDecode(texto) as Map<String, dynamic>;
  } on FormatException catch (e) {
    throw Exception('arquivo de backup invalido: ${e.message}');
  }

  final tabelas = mapa['tabelas'];
  if (tabelas is! Map<String, dynamic>) {
    throw Exception('arquivo de backup sem a secao "tabelas"');
  }

  await db.transaction(() async {
    await db.customStatement('PRAGMA foreign_keys = OFF');

    // Apaga na ordem inversa para não brigar com dependência.
    for (final t in db.allTables.toList().reversed) {
      await db.customStatement('DELETE FROM ${t.actualTableName}');
    }

    for (final t in db.allTables) {
      final linhas = tabelas[t.actualTableName];
      if (linhas is! List) continue;

      for (final raw in linhas) {
        final linha = Map<String, dynamic>.from(raw as Map);
        final colunas = linha.keys.toList();
        final marcadores = List.filled(colunas.length, '?').join(', ');

        await db.customInsert(
          'INSERT INTO ${t.actualTableName} '
          '(${colunas.join(', ')}) VALUES ($marcadores)',
          variables: colunas.map((c) => _variavel(linha[c])).toList(),
        );
      }
    }

    await db.customStatement('PRAGMA foreign_keys = ON');
  });
}

Variable<Object> _variavel(Object? v) => switch (v) {
      null => const Variable<String>(null),
      final int i => Variable<int>(i),
      final double d => Variable<double>(d),
      final bool b => Variable<bool>(b),
      final Uint8List u => Variable<Uint8List>(u),
      _ => Variable<String>(v.toString()),
    };
