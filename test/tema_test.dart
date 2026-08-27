import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/presentation/tema/cores.dart';
import 'package:refeicoes_app/presentation/tema/respingo.dart';
import 'package:refeicoes_app/presentation/tema/tema.dart';

void main() {
  test('tema claro e escuro trazem a extensao Esmalte', () {
    expect(temaClaro().extension<CoresEsmalte>(), isNotNull);
    expect(temaEscuro().extension<CoresEsmalte>(), isNotNull);
  });

  test('a brasa muda entre claro e escuro; o aro nao', () {
    final claro = temaClaro().extension<CoresEsmalte>()!;
    final escuro = temaEscuro().extension<CoresEsmalte>()!;
    expect(claro.brasa, isNot(escuro.brasa));
    expect(claro.aro, escuro.aro);
  });

  test('o dia gigante usa DarkerGrotesque', () {
    final t = temaClaro().textTheme;
    expect(t.displayLarge!.fontFamily, 'DarkerGrotesque');
    expect(t.displayLarge!.fontSize, 66);
  });

  test('DarkerGrotesque nunca aparece abaixo de 17px', () {
    final t = temaClaro().textTheme;
    final estilos = [
      t.displayLarge, t.displaySmall, t.titleLarge, t.titleMedium,
      t.bodyMedium, t.bodySmall, t.labelSmall, t.labelMedium,
    ];
    for (final e in estilos) {
      if (e?.fontFamily == 'DarkerGrotesque') {
        expect(e!.fontSize, greaterThanOrEqualTo(17),
            reason: 'DarkerGrotesque em ${e.fontSize}px');
      }
    }
  });

  test('fonte variavel declara o eixo de peso', () {
    final t = temaClaro().textTheme;
    expect(t.displayLarge!.fontVariations, isNotEmpty);
    expect(t.displayLarge!.fontVariations!.first.axis, 'wght');
    expect(t.bodyMedium!.fontVariations, isNotEmpty);
  });

  test('todo estilo de fonte variavel declara o eixo wght', () {
    final t = temaClaro().textTheme;
    final porNome = <String, TextStyle?>{
      'displayLarge': t.displayLarge,
      'displaySmall': t.displaySmall,
      'titleLarge': t.titleLarge,
      'titleMedium': t.titleMedium,
      'bodyMedium': t.bodyMedium,
      'bodySmall': t.bodySmall,
      'labelSmall': t.labelSmall,
      'labelMedium': t.labelMedium,
    };

    for (final entrada in porNome.entries) {
      final e = entrada.value!;
      if (e.fontFamily == 'IBMPlexMono') {
        // fonte estatica: o peso vem do arquivo declarado no pubspec,
        // nao de um eixo variavel
        continue;
      }
      expect(e.fontVariations, isNotNull,
          reason: '${entrada.key} usa fonte variavel e precisa de fontVariations '
              '— fontWeight nao move o eixo wght');
      expect(e.fontVariations!.map((v) => v.axis), contains('wght'),
          reason: '${entrada.key} sem o eixo wght');
    }
  });

  test('medida usa monoespacada', () {
    expect(temaClaro().textTheme.labelMedium!.fontFamily, 'IBMPlexMono');
  });

  test('o respingo repinta so quando a base muda', () {
    const a = PinturaRespingo(base: Esmalte.marinho);
    const b = PinturaRespingo(base: Esmalte.marinhoEscuro);
    expect(a.shouldRepaint(a), isFalse);
    expect(b.shouldRepaint(a), isTrue);
  });

  testWidgets('CampoRespingo pinta e escreve em branco', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: temaClaro(),
      home: const Scaffold(
        body: CampoRespingo(child: Text('Setembro 2026')),
      ),
    ));

    expect(find.text('Setembro 2026'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    final texto = tester.widget<DefaultTextStyle>(
      find.descendant(
        of: find.byType(CampoRespingo),
        matching: find.byType(DefaultTextStyle),
      ).first,
    );
    expect(texto.style.color, Colors.white);
  });

  testWidgets('CampoRespingo pinta o aro e usa icone branco', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: temaClaro(),
      home: const Scaffold(
        body: CampoRespingo(child: Icon(Icons.more_horiz)),
      ),
    ));

    final iconThemes = tester
        .widgetList<IconTheme>(find.descendant(
          of: find.byType(CampoRespingo),
          matching: find.byType(IconTheme),
        ))
        .toList();
    expect(iconThemes.any((it) => it.data.color == Colors.white), isTrue,
        reason: 'conteudo sobre o campo marinho precisa de icone branco');

    final container = tester.widget<Container>(find.descendant(
      of: find.byType(CampoRespingo),
      matching: find.byType(Container),
    ).first);
    final borda = (container.decoration as BoxDecoration).border as Border;
    expect(borda.bottom.color, Esmalte.aro,
        reason: 'o aro escuro sob a barra e assinatura da direcao visual');
    expect(borda.bottom.width, 2);
  });
}
