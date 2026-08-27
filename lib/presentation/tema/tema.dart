import 'package:flutter/material.dart';

import 'cores.dart';
import 'tipografia.dart';

ThemeData temaClaro() => _montar(
      brilho: Brightness.light,
      fundo: Esmalte.fundoClaro,
      superficie: Esmalte.superficieClaro,
      ink: Esmalte.inkClaro,
      primaria: Esmalte.marinho,
      extensao: CoresEsmalte.claro,
    );

ThemeData temaEscuro() => _montar(
      brilho: Brightness.dark,
      fundo: Esmalte.fundoEscuro,
      superficie: Esmalte.superficieEscuro,
      ink: Esmalte.inkEscuro,
      primaria: Esmalte.anilEscuro,
      extensao: CoresEsmalte.escuro,
    );

ThemeData _montar({
  required Brightness brilho,
  required Color fundo,
  required Color superficie,
  required Color ink,
  required Color primaria,
  required CoresEsmalte extensao,
}) {
  final esquema = ColorScheme.fromSeed(
    seedColor: Esmalte.marinho,
    brightness: brilho,
  ).copyWith(
    primary: primaria,
    surface: superficie,
    onSurface: ink,
    error: extensao.brasa,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: fundo,
    textTheme: textThemeEsmalte(ink),
    fontFamily: 'Manrope',
    extensions: [extensao],
    dividerColor: extensao.linha,
    cardTheme: CardThemeData(
      color: superficie,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: extensao.linha),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: extensao.marinho,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: superficie,
      indicatorColor: Colors.transparent,
      height: 62,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
