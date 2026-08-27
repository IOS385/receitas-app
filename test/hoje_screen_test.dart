import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_screen.dart';
import 'package:refeicoes_app/presentation/widgets/cartao_esmalte.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  /// Abre a tela numa data fixa: sexta, 4 de setembro de 2026 (posição 4).
  Future<void> abrir(WidgetTester tester,
      {String iso = '2026-09-04',
      Brightness brilho = Brightness.light}) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(
      const HojeScreen(),
      db: db,
      brilho: brilho,
      overrides: [
        dataSelecionadaProvider.overrideWith(() => _DataFixa(DataPura(iso))),
      ],
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('mostra os quatro horarios', (tester) async {
    await abrir(tester);

    expect(find.text('CAFÉ DA MANHÃ'), findsOneWidget);
    expect(find.text('ALMOÇO'), findsOneWidget);
    expect(find.text('CAFÉ DA TARDE'), findsOneWidget);
    expect(find.text('JANTAR'), findsOneWidget);
    expect(find.byType(CartaoEsmalte), findsNWidgets(4));
  });

  testWidgets('cabecalho traz dia, posicao no ciclo e kcal', (tester) async {
    await abrir(tester);

    expect(find.text('04'), findsOneWidget);
    expect(find.text('SEXTA'), findsOneWidget);
    expect(find.text('dia 4 de 4'), findsOneWidget);
    expect(find.text('KCAL NO DIA'), findsOneWidget);
  });

  testWidgets('sexta mostra 1 porcao no almoco e 2 no jantar',
      (tester) async {
    await abrir(tester);
    expect(find.text('1 porção'), findsNWidgets(2)); // cafe da manha e almoco
    expect(find.text('2 porções'), findsNWidgets(2)); // cafe da tarde e jantar
  });

  testWidgets('sabado mostra 2 porcoes nos quatro', (tester) async {
    await abrir(tester, iso: '2026-09-05');
    expect(find.text('2 porções'), findsNWidgets(4));
    expect(find.text('1 porção'), findsNothing);
  });

  testWidgets('espelhado diz que repete e nao oferece substituir',
      (tester) async {
    await abrir(tester);

    expect(find.text('repete almoço, em dobro'), findsOneWidget);
    expect(find.text('repete café da manhã, em dobro'), findsOneWidget);
    // so os dois slots base tem botao
    expect(find.text('SUBSTITUIR'), findsNWidgets(2));
  });

  testWidgets('cartao espelhado fica apagado', (tester) async {
    await abrir(tester);

    final cartoes = tester
        .widgetList<CartaoEsmalte>(find.byType(CartaoEsmalte))
        .toList();
    expect(cartoes.where((c) => c.apagado), hasLength(2));
  });

  testWidgets('mostra a quantidade escalada de cada componente',
      (tester) async {
    await abrir(tester);
    // arroz do almoco: 120 g com 1 porcao
    expect(find.text('120 g'), findsWidgets);
    // arroz do jantar: 240 g com 2 porcoes
    expect(find.text('240 g'), findsWidgets);
  });

  testWidgets('abre a folha de substituicao', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('SUBSTITUIR').last);
    await tester.pumpAndSettle();

    expect(find.text('Trocar a refeição inteira'), findsOneWidget);
  });

  testWidgets('renderiza no modo escuro sem estourar', (tester) async {
    await abrir(tester, brilho: Brightness.dark);
    expect(tester.takeException(), isNull);
    expect(find.byType(CartaoEsmalte), findsNWidgets(4));
  });
}

class _DataFixa extends DataSelecionada {
  final DataPura inicial;
  _DataFixa(this.inicial);

  @override
  DataPura build() => inicial;
}
