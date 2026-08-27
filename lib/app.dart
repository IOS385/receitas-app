import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database_provider.dart';
import 'presentation/ajustes/ajustes_provider.dart';
import 'presentation/hoje/hoje_screen.dart';
import 'presentation/mercado/mercado_screen.dart';
import 'presentation/mes/mes_screen.dart';
import 'presentation/receitas/receitas_screen.dart';
import 'presentation/tema/tema.dart';

/// Política de retry do app: nenhuma.
///
/// App offline total, SQLite local, sem rede em lugar nenhum — toda falha de
/// provider aqui é determinística: conversão de unidade faltando, receita
/// inexistente, erro de banco. O padrão do riverpod 3
/// (`ProviderContainer.defaultRetry`) reexecuta o provider até dez vezes com
/// backoff, ~38 s no total, e enquanto isso mantém o estado em `AsyncLoading`
/// **com** o erro anexado — então `.future` não completa e os branches
/// `error:` que as telas já têm nunca disparam. Reexecutar não conserta nada
/// aqui; só troca "erro visível em 100 ms" por "gira meio minuto".
///
/// `envolver()` em `test/util_teste.dart` usa esta MESMA função, de propósito:
/// harness que diverge do app é o que escondeu o C1 (override de
/// `tamanho_ciclo`) e o I4 por vinte e duas revisões.
Duration? semRetry(int tentativa, Object erro) => null;

class AppRefeicoes extends ConsumerWidget {
  const AppRefeicoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modo = ref.watch(temaModoProvider).value ?? ThemeMode.system;

    return MaterialApp(
      title: 'Refeições',
      debugShowCheckedModeBanner: false,
      theme: temaClaro(),
      darkTheme: temaEscuro(),
      themeMode: modo,
      home: const Casca(),
    );
  }
}

/// Quatro abas fixas, nada escondido em menu. Ajustes fica atrás do `⋯` da
/// barra superior de cada tela.
class Casca extends ConsumerStatefulWidget {
  const Casca({super.key});

  @override
  ConsumerState<Casca> createState() => _CascaState();
}

class _CascaState extends ConsumerState<Casca> {
  int _aba = 0;

  static const _telas = [
    HojeScreen(),
    MesScreen(),
    MercadoScreen(),
    ReceitasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final semeadura = ref.watch(semeaduraProvider);

    return semeadura.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Não foi possível preparar os dados.\n\n$e',
                textAlign: TextAlign.center),
          ),
        ),
      ),
      data: (_) => Scaffold(
        body: IndexedStack(index: _aba, children: _telas),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _aba,
          onDestinationSelected: (i) => setState(() => _aba = i),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.today_outlined),
                selectedIcon: Icon(Icons.today),
                label: 'Hoje'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: 'Mês'),
            NavigationDestination(
                icon: Icon(Icons.checklist_outlined),
                selectedIcon: Icon(Icons.checklist),
                label: 'Mercado'),
            NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Receitas'),
          ],
        ),
      ),
    );
  }
}
