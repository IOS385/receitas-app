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
      for (final pacote in const ['package:flutter/', 'package:drift/']) {
        if (texto.contains("import '$pacote")) {
          proibidos.add('${f.path} importa $pacote');
        }
      }
    }
    expect(proibidos, isEmpty, reason: proibidos.join('\n'));
  });

  test('nenhum arquivo de lib faz chamada de rede', () {
    final proibidos = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart') || f.path.endsWith('.g.dart')) continue;
      final texto = f.readAsStringSync();
      for (final agulha in const ['package:http/', 'HttpClient(', 'WebSocket.']) {
        if (texto.contains(agulha)) proibidos.add('${f.path} usa $agulha');
      }
    }
    expect(proibidos, isEmpty, reason: proibidos.join('\n'));
  });
}
