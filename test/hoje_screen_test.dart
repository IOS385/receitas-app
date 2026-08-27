import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
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
    const iso = '2026-09-04';
    await abrir(tester, iso: iso);

    expect(find.text('04'), findsOneWidget);
    expect(find.text('SEXTA'), findsOneWidget);
    expect(find.text('dia 4 de ${tamanhoDoCiclo()}'), findsOneWidget);
    expect(find.text('KCAL NO DIA'), findsOneWidget);

    // relacional de proposito: prova que a TELA renderiza o que o REPOSITORIO
    // calcula, sem cravar um numero que quebra se a semente mudar
    final esperado = (await RepoPlano(db, RepoConfig(db)).dia(DataPura(iso)))
        .total
        .kcal
        .round();
    expect(find.text('$esperado'), findsOneWidget,
        reason: 'o total do cabecalho tem de ser o que o repositorio calcula');
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
    // sexta: almoço 1 e jantar 2, café da manhã 1 e café da tarde 2 — aqui
    // "em dobro" e verdade
    await abrir(tester);

    expect(find.text('repete o almoço, em dobro'), findsOneWidget);
    expect(find.text('repete o café da manhã, em dobro'), findsOneWidget);
    // so os dois slots base tem botao
    expect(find.text('SUBSTITUIR'), findsNWidgets(2));
  });

  testWidgets('no fim de semana nao diz em dobro, porque nao e',
      (tester) async {
    // sabado: os quatro slots vem com 2 porções. Nao ha dobro nenhum, e o
    // selo "2 porções" aparece nos dois cartoes do par.
    await abrir(tester, iso: '2026-09-05');

    expect(find.text('repete o almoço'), findsOneWidget);
    expect(find.text('repete o café da manhã'), findsOneWidget);
    expect(find.textContaining('em dobro'), findsNothing,
        reason: 'sabado tem 2 porções em todo slot — "em dobro" e mentira');
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

    // Com a foto do prato no cartao, o SUBSTITUIR do segundo cartao nasce
    // abaixo de 915 dp. Sem rolar, o tap erra e apenas AVISA — nao reprova.
    await tester.ensureVisible(find.text('SUBSTITUIR').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('SUBSTITUIR').last);
    await tester.pumpAndSettle();

    expect(find.text('Trocar só um componente'), findsOneWidget,
        reason: 'a folha abre no nivel componente — ver o comentario de ordem '
            'em substituir_sheet.dart');
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
