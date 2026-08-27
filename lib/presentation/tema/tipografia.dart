import 'package:flutter/material.dart';

/// Peso em fonte variável: `fontWeight` sozinho não move o eixo `wght`.
List<FontVariation> _peso(double w) => [FontVariation('wght', w)];

/// Escala da spec 11.2.
///
/// `DarkerGrotesque` só entra em corpo ≥ 17 px — abaixo disso a família perde
/// legibilidade. Toda medida (grama, kcal, quantidade) usa `IBMPlexMono`, para
/// alinhar em coluna.
TextTheme textThemeEsmalte(Color ink) => TextTheme(
      // o número gigante do dia
      displayLarge: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 66,
        height: .78,
        letterSpacing: -3,
        color: ink,
      ),
      // título de tela
      displaySmall: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 33,
        height: .95,
        letterSpacing: -1.2,
        color: ink,
      ),
      // título de prato
      titleLarge: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 23,
        height: 1,
        letterSpacing: -.7,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 19,
        height: 1.05,
        letterSpacing: -.5,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Manrope',
        fontVariations: _peso(500),
        fontSize: 13,
        height: 1.45,
        color: ink,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Manrope',
        fontVariations: _peso(500),
        fontSize: 11.5,
        height: 1.4,
        color: ink,
      ),
      // rótulo em caixa alta
      labelSmall: TextStyle(
        fontFamily: 'Manrope',
        fontVariations: _peso(800),
        fontSize: 10,
        letterSpacing: 1.6,
        color: ink,
      ),
      // medida
      labelMedium: const TextStyle(
        fontFamily: 'IBMPlexMono',
        fontSize: 10.5,
        height: 1.3,
      ).copyWith(color: ink),
    );
