/// Vocabulário do domínio. Dart puro: nada aqui conhece Flutter nem banco.
library;

enum SlotRefeicao { cafeManha, almoco, cafeTarde, jantar }

enum TipoCombo { cafe, refeicao }

enum CategoriaReceita {
  base, proteina, leguminosa, vegetal, salada, molho, bebida, pao, fruta,
}

enum Unidade {
  g, ml, unidade, colherSopa, colherCha, xicara, dente, fatia, folha,
  pitada, aGosto,
}

enum SecaoMercado {
  hortifruti, acougue, padaria, laticinios, mercearia, congelados, bebidas,
}

enum UnidadeCompra { kg, litro, unidade }

/// Unidades que só existem em número inteiro. Meio ovo não vai na panela.
const Set<Unidade> unidadesDiscretas = {
  Unidade.unidade, Unidade.dente, Unidade.fatia, Unidade.folha,
};

/// Unidades sem medida: não escalam e não somam nutriente (spec 8.2).
const Set<Unidade> unidadesSemMedida = {Unidade.pitada, Unidade.aGosto};

/// Data pura (ano-mês-dia), sem hora e sem fuso. Guardada como ISO `YYYY-MM-DD`,
/// que é também a forma persistida no banco.
extension type const DataPura(String iso) {
  factory DataPura.de(DateTime d) {
    final ano = d.year.toString().padLeft(4, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return DataPura('$ano-$mes-$dia');
  }

  /// Sempre UTC — é o que impede diferença de dias de errar por fuso.
  DateTime get comoDateTime {
    final p = iso.split('-');
    return DateTime.utc(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
  }

  String get rotuloCurto {
    final p = iso.split('-');
    return '${p[2]}/${p[1]}';
  }
}

/// Valores nutricionais absolutos de uma porção já escalada.
class Nutrientes {
  final double kcal;
  final double carboidrato;
  final double proteina;
  final double gordura;
  final double fibra;
  final double sodio;

  const Nutrientes({
    required this.kcal,
    required this.carboidrato,
    required this.proteina,
    required this.gordura,
    required this.fibra,
    required this.sodio,
  });

  static const Nutrientes zero = Nutrientes(
    kcal: 0, carboidrato: 0, proteina: 0, gordura: 0, fibra: 0, sodio: 0,
  );

  Nutrientes operator +(Nutrientes o) => Nutrientes(
        kcal: kcal + o.kcal,
        carboidrato: carboidrato + o.carboidrato,
        proteina: proteina + o.proteina,
        gordura: gordura + o.gordura,
        fibra: fibra + o.fibra,
        sodio: sodio + o.sodio,
      );

  Nutrientes escalar(double f) => Nutrientes(
        kcal: kcal * f,
        carboidrato: carboidrato * f,
        proteina: proteina * f,
        gordura: gordura * f,
        fibra: fibra * f,
        sodio: sodio * f,
      );
}

/// O que o motor devolve para um par (data, slot).
class RefeicaoResolvida {
  final SlotRefeicao slot;
  final int porcoes;
  final int comboId;
  final List<int> receitaIds;

  /// Falso quando este slot tem substituição própria e por isso deixou de
  /// espelhar o slot base.
  final bool espelhoIntacto;

  const RefeicaoResolvida({
    required this.slot,
    required this.porcoes,
    required this.comboId,
    required this.receitaIds,
    required this.espelhoIntacto,
  });
}
