import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  group('DataPura', () {
    test('formata com zero a esquerda', () {
      expect(DataPura.de(DateTime(2026, 9, 4)).iso, '2026-09-04');
      expect(DataPura.de(DateTime(2026, 12, 31)).iso, '2026-12-31');
    });

    test('ida e volta preserva o dia', () {
      final d = DataPura.de(DateTime(2027, 1, 5));
      expect(d.comoDateTime, DateTime.utc(2027, 1, 5));
    });

    test('ignora a hora do DateTime de origem', () {
      final cedo = DataPura.de(DateTime(2026, 9, 4, 0, 1));
      final tarde = DataPura.de(DateTime(2026, 9, 4, 23, 59));
      expect(cedo, tarde);
    });
  });

  group('Nutrientes', () {
    const a = Nutrientes(kcal: 100, carboidrato: 10, proteina: 5,
        gordura: 2, fibra: 1, sodio: 50);

    test('soma campo a campo', () {
      final s = a + a;
      expect(s.kcal, 200);
      expect(s.proteina, 10);
      expect(s.sodio, 100);
    });

    test('zero e elemento neutro', () {
      expect((a + Nutrientes.zero).kcal, a.kcal);
      expect((a + Nutrientes.zero).sodio, a.sodio);
    });

    test('escalar multiplica todos os campos', () {
      final m = a.escalar(0.5);
      expect(m.kcal, 50);
      expect(m.carboidrato, 5);
      expect(m.fibra, 0.5);
    });
  });

  group('conjuntos de unidade', () {
    test('discretas sao exatamente as quatro contaveis', () {
      expect(unidadesDiscretas, {
        Unidade.unidade, Unidade.dente, Unidade.fatia, Unidade.folha,
      });
    });

    test('sem medida sao pitada e a gosto', () {
      expect(unidadesSemMedida, {Unidade.pitada, Unidade.aGosto});
    });

    test('grama nao e discreta nem sem medida', () {
      expect(unidadesDiscretas.contains(Unidade.g), isFalse);
      expect(unidadesSemMedida.contains(Unidade.g), isFalse);
    });
  });
}
