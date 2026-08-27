import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/presentation/tema/cores.dart';
import 'package:refeicoes_app/presentation/tema/tema.dart';
import 'package:refeicoes_app/presentation/widgets/cartao_esmalte.dart';

void main() {
  Widget comTema(Widget child) => MaterialApp(
        theme: temaClaro(),
        home: Scaffold(body: child),
      );

  testWidgets('cartao normal tem aro marinho no topo', (tester) async {
    await tester.pumpWidget(comTema(
      const CartaoEsmalte(child: Text('Almoço')),
    ));

    final container = tester.widget<Container>(find.descendant(
      of: find.byType(CartaoEsmalte),
      matching: find.byType(Container),
    ).first);
    final borda = (container.decoration as BoxDecoration).border as Border;

    expect(borda.top.color, Esmalte.marinho);
    expect(borda.top.width, 2.5);
  });

  testWidgets('cartao apagado perde o aro', (tester) async {
    await tester.pumpWidget(comTema(
      const CartaoEsmalte(apagado: true, child: Text('Jantar')),
    ));

    final container = tester.widget<Container>(find.descendant(
      of: find.byType(CartaoEsmalte),
      matching: find.byType(Container),
    ).first);
    final deco = container.decoration as BoxDecoration;
    final borda = deco.border as Border;

    expect(borda.top.color, Esmalte.linhaClaro);
    expect(deco.color, Esmalte.superficie2Claro);
  });

  testWidgets('cartao com onTap responde ao toque', (tester) async {
    var toques = 0;
    await tester.pumpWidget(comTema(
      CartaoEsmalte(onTap: () => toques++, child: const Text('Toca')),
    ));

    await tester.tap(find.text('Toca'));
    await tester.pumpAndSettle();
    expect(toques, 1);
  });

  testWidgets('cartao sem onTap nao cria area de toque', (tester) async {
    await tester.pumpWidget(comTema(
      const CartaoEsmalte(child: Text('Estatico')),
    ));
    expect(
      find.descendant(
          of: find.byType(CartaoEsmalte), matching: find.byType(InkWell)),
      findsNothing,
    );
  });
}
