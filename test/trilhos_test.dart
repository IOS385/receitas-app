import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lib/domain nao importa flutter nem drift', () {
    final dir = Directory('lib/domain');
    if (!dir.existsSync()) return;

    final proibidos = <String>[];
    for (final f in dir.listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final texto = f.readAsStringSync();
      for (final pacote in const ['flutter', 'drift']) {
        final regex = RegExp(
          r'''^\s*(import|export)\s+['"]package:''' + pacote + r'''/''',
          multiLine: true,
        );
        if (regex.hasMatch(texto)) {
          proibidos.add('${f.path} importa/exporta package:$pacote/');
        }
      }
    }
    expect(proibidos, isEmpty, reason: proibidos.join('\n'));
  });

  test('nenhum arquivo de lib faz chamada de rede', () {
    final proibidos = <String>[];
    final httpRegex = RegExp(
      r'''^\s*(import|export)\s+['"]package:http/''',
      multiLine: true,
    );
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart') || f.path.endsWith('.g.dart')) continue;
      final texto = f.readAsStringSync();
      if (httpRegex.hasMatch(texto)) {
        proibidos.add('${f.path} usa package:http/');
      }
      for (final agulha in const ['HttpClient(', 'WebSocket.']) {
        if (texto.contains(agulha)) proibidos.add('${f.path} usa $agulha');
      }
    }
    expect(proibidos, isEmpty, reason: proibidos.join('\n'));
  });
}
