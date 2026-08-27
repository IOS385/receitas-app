import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/backup.dart';
import 'package:refeicoes_app/data/database_provider.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/ajustes/ajustes_provider.dart';
import 'package:refeicoes_app/presentation/ajustes/ajustes_screen.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/mercado/mercado_provider.dart';
import 'package:refeicoes_app/presentation/mes/mes_provider.dart';
import 'package:refeicoes_app/presentation/receitas/receitas_provider.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(envolver(const AjustesScreen(), db: db));
    await tester.pumpAndSettle();
  }

  testWidgets('mostra os quatro grupos', (tester) async {
    await abrir(tester);

    expect(find.text('O CICLO'), findsOneWidget);
    expect(find.text('PORÇÕES'), findsOneWidget);
    expect(find.text('APARÊNCIA'), findsOneWidget);
    expect(find.text('SEUS DADOS'), findsOneWidget);
    expect(find.text('SOBRE'), findsOneWidget);
  });

  testWidgets('tabela de porcoes traz os quatro horarios e as duas colunas',
      (tester) async {
    await abrir(tester);

    expect(find.text('SEG–SEX'), findsOneWidget);
    expect(find.text('SÁB–DOM'), findsOneWidget);
    expect(find.text('Café da manhã'), findsOneWidget);
    await tester.ensureVisible(find.text('Jantar'));
    await tester.pumpAndSettle();
    expect(find.text('Jantar'), findsOneWidget);
  });

  testWidgets('mostra o resumo do que esta no aparelho', (tester) async {
    await abrir(tester);

    await tester.ensureVisible(find.textContaining('24 receitas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('24 receitas'), findsOneWidget);
    expect(find.textContaining('8 refeições'), findsOneWidget);
    expect(find.textContaining('40 alimentos'), findsOneWidget);
  });

  testWidgets('diz que funciona sem internet', (tester) async {
    await abrir(tester);
    await tester.ensureVisible(find.text('Funciona sem internet'));
    await tester.pumpAndSettle();
    expect(find.text('Funciona sem internet'), findsOneWidget);
    expect(find.text('nada sai do telefone'), findsOneWidget);
  });

  testWidgets('mostra o inicio e o tamanho do ciclo', (tester) async {
    await abrir(tester);

    expect(find.text('Começou em'), findsOneWidget);
    expect(find.text('01/09'), findsOneWidget);
    expect(find.text('4 dias'), findsOneWidget);
  });

  testWidgets('trocar aparencia persiste em config', (tester) async {
    await abrir(tester);

    await tester.ensureVisible(find.text('Escuro'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Escuro'));
    await tester.pumpAndSettle();

    expect(await RepoConfig(db).ler('tema'), 'escuro');
  });

  testWidgets('aparencia salva volta selecionada', (tester) async {
    await RepoConfig(db).definir('tema', 'claro');
    await abrir(tester);

    final botao = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>));
    expect(botao.selected, {ThemeMode.light});
  });

  testWidgets('importar pede confirmacao antes de qualquer coisa',
      (tester) async {
    await abrir(tester);

    await tester.ensureVisible(find.text('Importar backup'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Importar backup'));
    await tester.pumpAndSettle();

    expect(find.text('Importar backup?'), findsOneWidget);
    expect(find.textContaining('Não tem como desfazer'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(await db.select(db.alimentos).get(), hasLength(40));
  });

  test('importar backup nao deixa provider nenhum com dado velho', () async {
    final hoje = DataPura.de(DateTime.now());

    // Um backup com conteudo DIFERENTE: nome de receita, tema e um dia
    // substituido — um sintoma por provider que ficava de fora.
    final origem = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
    await carregarSemente(origem, lerAsset: lerSementeDoDisco, versao: 1);
    await (origem.update(origem.receitas)..where((t) => t.id.equals(1)))
        .write(const ReceitasCompanion(nome: Value('Arroz do backup')));
    await RepoConfig(origem).definir('tema', 'escuro');
    await RepoPlano(origem, RepoConfig(origem))
        .substituirCombo(data: hoje, slot: SlotRefeicao.almoco, comboId: 5);
    final arquivo = await exportarJson(origem);
    await origem.close();

    final c = ProviderContainer(overrides: [
      bancoProvider.overrideWithValue(db),
      semeaduraProvider.overrideWith((ref) async {}),
    ]);
    addTearDown(c.dispose);

    // aquece os oito, como a usuaria faz ao passear pelas abas antes de importar
    for (final p in providersDoBanco) {
      c.invalidate(p);
    }
    final catalogoVelho = await c.read(catalogoProvider.future);
    final listaVelha = await c.read(listaMercadoProvider.future);
    await c.read(temaModoProvider.future);
    await c.read(diasEditadosProvider.future);
    await c.read(resumoProvider.future);
    await c.read(regrasPorcaoProvider.future);
    await c.read(diaProvider.future);
    expect(catalogoVelho.map((r) => r.nome), isNot(contains('Arroz do backup')));
    expect(listaVelha.itens, isNotEmpty);

    await importarJson(db, arquivo);
    for (final p in providersDoBanco) {
      c.invalidate(p);
    }

    expect((await c.read(catalogoProvider.future)).map((r) => r.nome),
        contains('Arroz do backup'),
        reason: 'a aba Receitas mostrava o catalogo antigo');
    expect(await c.read(temaModoProvider.future), ThemeMode.dark,
        reason: 'o tema do arquivo nao era aplicado');
    expect(await c.read(diasEditadosProvider.future), contains(hoje),
        reason: 'o ponto de brasa do Mes ficava velho');
    final listaNova = await c.read(listaMercadoProvider.future);
    expect(listaNova.itens, isNotEmpty,
        reason: 'o Mercado apontava para um listaId que o import apagou');
    expect(listaNova.listaId, isNot(listaVelha.listaId));
    expect((await c.read(resumoProvider.future)).receitas, 24);
  });

  testWidgets('renderiza no escuro sem estourar', (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(
        envolver(const AjustesScreen(), db: db, brilho: Brightness.dark));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
