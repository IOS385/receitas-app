import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/domain/nutricao.dart';

void main() {
  const conversoesOvo = {Unidade.g: 1.0, Unidade.unidade: 50.0};

  group('emGramas', () {
    test('grama passa pela tabela, sem atalho', () {
      expect(
          emGramas(
              unidade: Unidade.g,
              quantidade: 150,
              conversoes: conversoesOvo,
              alimentoId: 1),
          150);
    });

    test('unidade converte pela tabela', () {
      expect(
          emGramas(
              unidade: Unidade.unidade,
              quantidade: 2,
              conversoes: conversoesOvo,
              alimentoId: 1),
          100);
    });

    test('a gosto vale zero grama', () {
      expect(
          emGramas(
              unidade: Unidade.aGosto,
              quantidade: 1,
              conversoes: conversoesOvo,
              alimentoId: 1),
          0);
    });

    test('conversao faltando estoura alto, nao devolve zero calado', () {
      expect(
        () => emGramas(
            unidade: Unidade.xicara,
            quantidade: 1,
            conversoes: conversoesOvo,
            alimentoId: 7),
        throwsA(isA<ConversaoAusente>()
            .having((e) => e.alimentoId, 'alimentoId', 7)
            .having((e) => e.unidade, 'unidade', Unidade.xicara)),
      );
    });
  });

  group('nutrienteDe', () {
    const arrozPor100g = Nutrientes(
        kcal: 128, carboidrato: 28.1, proteina: 2.5,
        gordura: 0.2, fibra: 1.6, sodio: 1);

    test('cem gramas devolve a tabela inteira', () {
      final n = nutrienteDe(por100g: arrozPor100g, gramas: 100);
      expect(n.kcal, closeTo(128, 0.001));
      expect(n.proteina, closeTo(2.5, 0.001));
    });

    test('escala proporcional a grama', () {
      final n = nutrienteDe(por100g: arrozPor100g, gramas: 240);
      expect(n.kcal, closeTo(307.2, 0.01));
      expect(n.carboidrato, closeTo(67.44, 0.01));
    });

    test('zero grama devolve zero nutriente', () {
      final n = nutrienteDe(por100g: arrozPor100g, gramas: 0);
      expect(n.kcal, 0);
      expect(n.sodio, 0);
    });

    test('soma de ingredientes acumula', () {
      final total = nutrienteDe(por100g: arrozPor100g, gramas: 100) +
          nutrienteDe(por100g: arrozPor100g, gramas: 100);
      expect(total.kcal, closeTo(256, 0.001));
    });
  });
}
