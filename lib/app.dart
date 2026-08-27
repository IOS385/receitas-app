import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database_provider.dart';
import 'presentation/hoje/hoje_screen.dart';
import 'presentation/mercado/mercado_screen.dart';
import 'presentation/mes/mes_screen.dart';
import 'presentation/receitas/receitas_screen.dart';
import 'presentation/tema/tema.dart';

class AppRefeicoes extends ConsumerWidget {
  const AppRefeicoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Refeições',
      debugShowCheckedModeBanner: false,
      theme: temaClaro(),
      darkTheme: temaEscuro(),
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
