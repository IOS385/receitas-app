import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/format.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/mes/mes_provider.dart';
import 'package:refeicoes_app/presentation/mes/mes_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;
  const sexta = DataPura('2026-09-04');

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(
      const MesScreen(),
      db: db,
      overrides: [
        dataSelecionadaProvider.overrideWith(() => _DataFixa(sexta)),
      ],
    ));
    await tester.pumpAndSettle();
  }

  test('diasNoMes cobre mes curto, longo e bissexto', () {
    expect(diasNoMes(2026, 9), 30);
    expect(diasNoMes(2026, 10), 31);
    expect(diasNoMes(2026, 2), 28);
    expect(diasNoMes(2028, 2), 29);
  });

  test('primeiroDiaDaSemana devolve coluna de 0 a 6', () {
    // 2026-09-01 e uma terca -> coluna 2 (domingo = 0)
    expect(primeiroDiaDaSemana(2026, 9), 2);
    for (var m = 1; m <= 12; m++) {
      expect(primeiroDiaDaSemana(2026, m), inInclusiveRange(0, 6));
    }
  });

  testWidgets('mostra o mes e os trinta dias', (tester) async {
    await abrir(tester);

    expect(find.text('SETEMBRO 2026'), findsOneWidget);
    expect(find.text('O mês'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('31'), findsNothing);
  });

  testWidgets('resumo do dia selecionado aparece embaixo', (tester) async {
    await abrir(tester);

    expect(find.text('Sexta, 4 de setembro'), findsOneWidget);
    expect(find.textContaining('dia 4 de 4'), findsOneWidget);
    expect(find.textContaining('1 porção no café e no almoço'),
        findsOneWidget);
    expect(find.text('TOTAL DO DIA'), findsOneWidget);
  });

  testWidgets('escolher um sabado troca a regra de porcao', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    expect(find.text('Sábado, 5 de setembro'), findsOneWidget);
    expect(find.textContaining('2 porções o dia todo'), findsOneWidget);
  });

  testWidgets('folhear troca o mes sem mexer no dia escolhido',
      (tester) async {
    await abrir(tester);

    await tester.tap(find.byTooltip('Mês seguinte'));
    await tester.pumpAndSettle();

    expect(find.text('OUTUBRO 2026'), findsOneWidget);
    expect(find.text('31'), findsOneWidget);
    // o resumo continua no dia 4 de setembro
    expect(find.text('Sexta, 4 de setembro'), findsOneWidget);
  });

  testWidgets('folhear sobrevive a mudanca de data vinda de fora',
      (tester) async {
    telaDeCelular(tester);
    // Sem override de dataSelecionadaProvider: usa a data real de hoje, como
    // outra tela faria ao chamar `avancar`/`ir`/`hoje` no notifier real.
    await tester.pumpWidget(envolver(const MesScreen(), db: db));
    await tester.pumpAndSettle();

    final agora = DateTime.now();
    final proximo = DateTime.utc(agora.year, agora.month + 1);
    final rotuloProximo = '${mesNome(proximo.month)} ${proximo.year}'.toUpperCase();

    // folheia um mes adiante
    await tester.tap(find.byTooltip('Mês seguinte'));
    await tester.pumpAndSettle();
    expect(find.text(rotuloProximo), findsOneWidget);

    // outra tela troca a data selecionada — o Mes nao pode voltar sozinho
    final elemento = tester.element(find.byType(MesScreen));
    final container = ProviderScope.containerOf(elemento);
    container.read(dataSelecionadaProvider.notifier).avancar(1);
    await tester.pumpAndSettle();

    expect(find.text(rotuloProximo), findsOneWidget,
        reason: 'mudanca de data vinda de fora nao pode descartar o folhear');
  });

  testWidgets('dia sem substituicao nao tem contagem', (tester) async {
    await abrir(tester);
    expect(find.text('0 neste mês'), findsOneWidget);
  });

  testWidgets('dia substituido entra na contagem', (tester) async {
    await RepoPlano(db, RepoConfig(db)).substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);

    await abrir(tester);
    expect(find.text('1 neste mês'), findsOneWidget);
  });

  testWidgets('cada dia e um botao acessivel', (tester) async {
    await abrir(tester);

    final semantica = tester.getSemantics(find.text('4').first);
    expect(semantica.label, contains('4 de setembro'));
  });
}

class _DataFixa extends DataSelecionada {
  final DataPura inicial;
  _DataFixa(this.inicial);

  @override
  DataPura build() => inicial;
}
