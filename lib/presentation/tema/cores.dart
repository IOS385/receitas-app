import 'package:flutter/material.dart';

/// Tokens da direção Esmalte (spec seção 11.1). A panela de ágata: branco
/// esmaltado, marinho salpicado, aro escuro onde o esmalte termina.
abstract final class Esmalte {
  // invariantes
  static const marinho = Color(0xFF14263F);
  static const marinhoEscuro = Color(0xFF0B1927);
  static const aro = Color(0xFF0A1017);

  // claro
  static const anilClaro = Color(0xFF2C4A73);
  static const superficieClaro = Color(0xFFFFFFFF);
  static const fundoClaro = Color(0xFFE9EDF0);
  static const superficie2Claro = Color(0xFFF3F7F9);
  static const brasaClaro = Color(0xFFC7412B);
  static const inkClaro = Color(0xFF0E1519);
  static const ink2Claro = Color(0xFF3E4A55);
  static const ink3Claro = Color(0xFF7C8B98);
  static const linhaClaro = Color(0xFFD5DEE4);

  // escuro
  static const anilEscuro = Color(0xFF3C5F87);
  static const superficieEscuro = Color(0xFF16232F);
  static const fundoEscuro = Color(0xFF0E1720);
  static const superficie2Escuro = Color(0xFF1D2C3A);
  static const brasaEscuro = Color(0xFFE4694E);
  static const inkEscuro = Color(0xFFEAF0F4);
  static const ink2Escuro = Color(0xFFAAB9C6);
  static const ink3Escuro = Color(0xFF74889A);
  static const linhaEscuro = Color(0xFF25374A);
}

/// O que o Material não tem lugar para guardar: o aro do cartão, o campo
/// marinho do respingo e a brasa.
@immutable
class CoresEsmalte extends ThemeExtension<CoresEsmalte> {
  final Color aro;
  final Color marinho;
  final Color brasa;
  final Color superficie2;
  final Color linha;
  final Color ink2;
  final Color ink3;

  const CoresEsmalte({
    required this.aro,
    required this.marinho,
    required this.brasa,
    required this.superficie2,
    required this.linha,
    required this.ink2,
    required this.ink3,
  });

  static const claro = CoresEsmalte(
    aro: Esmalte.aro,
    marinho: Esmalte.marinho,
    brasa: Esmalte.brasaClaro,
    superficie2: Esmalte.superficie2Claro,
    linha: Esmalte.linhaClaro,
    ink2: Esmalte.ink2Claro,
    ink3: Esmalte.ink3Claro,
  );

  static const escuro = CoresEsmalte(
    aro: Esmalte.aro,
    marinho: Esmalte.marinhoEscuro,
    brasa: Esmalte.brasaEscuro,
    superficie2: Esmalte.superficie2Escuro,
    linha: Esmalte.linhaEscuro,
    ink2: Esmalte.ink2Escuro,
    ink3: Esmalte.ink3Escuro,
  );

  @override
  CoresEsmalte copyWith({
    Color? aro,
    Color? marinho,
    Color? brasa,
    Color? superficie2,
    Color? linha,
    Color? ink2,
    Color? ink3,
  }) =>
      CoresEsmalte(
        aro: aro ?? this.aro,
        marinho: marinho ?? this.marinho,
        brasa: brasa ?? this.brasa,
        superficie2: superficie2 ?? this.superficie2,
        linha: linha ?? this.linha,
        ink2: ink2 ?? this.ink2,
        ink3: ink3 ?? this.ink3,
      );

  @override
  CoresEsmalte lerp(ThemeExtension<CoresEsmalte>? outro, double t) {
    if (outro is! CoresEsmalte) return this;
    return CoresEsmalte(
      aro: Color.lerp(aro, outro.aro, t)!,
      marinho: Color.lerp(marinho, outro.marinho, t)!,
      brasa: Color.lerp(brasa, outro.brasa, t)!,
      superficie2: Color.lerp(superficie2, outro.superficie2, t)!,
      linha: Color.lerp(linha, outro.linha, t)!,
      ink2: Color.lerp(ink2, outro.ink2, t)!,
      ink3: Color.lerp(ink3, outro.ink3, t)!,
    );
  }
}

/// Atalho: `context.esmalte.brasa`.
extension EsmalteDoContexto on BuildContext {
  CoresEsmalte get esmalte =>
      Theme.of(this).extension<CoresEsmalte>() ?? CoresEsmalte.claro;
}
