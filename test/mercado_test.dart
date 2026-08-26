import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/mercado.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  // 1 arroz (kg, mercearia) · 2 ovo (unidade, mercearia) · 3 alface (un, hortifruti)
  const conversoes = {
    1: {Unidade.g: 1.0, Unidade.xicara: 180.0},
    2: {Unidade.g: 1.0, Unidade.unidade: 50.0},
    3: {Unidade.g: 1.0, Unidade.unidade: 300.0},
  };
  const secoes = {
    1: SecaoMercado.mercearia,
    2: SecaoMercado.mercearia,
    3: SecaoMercado.hortifruti,
  };
  const compras = {
    1: UnidadeCompra.kg,
    2: UnidadeCompra.unidade,
    3: UnidadeCompra.unidade,
  };

  List<ItemMercado> agregar(List<LinhaIngrediente> linhas) => agregarMercado(
        linhas: linhas,
        conversoes: conversoes,
        secoes: secoes,
        unidadesCompra: compras,
      );

  group('agregarMercado', () {
    test('soma o mesmo alimento em uma linha so', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 120),
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 240),
      ]);
      expect(r, hasLength(1));
      expect(r.single.gramas, 360);
    });

    test('soma unidades diferentes do mesmo alimento', () {
      // 2 ovos (100 g) + 100 g de ovo = 200 g
      final r = agregar(const [
        LinhaIngrediente(
            alimentoId: 2, unidade: Unidade.unidade, quantidade: 2),
        LinhaIngrediente(alimentoId: 2, unidade: Unidade.g, quantidade: 100),
      ]);
      expect(r.single.gramas, 200);
    });

    test('ignora ingrediente a gosto', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 100),
        LinhaIngrediente(
            alimentoId: 1, unidade: Unidade.aGosto, quantidade: 1),
      ]);
      expect(r.single.gramas, 100);
    });

    test('ordena por secao seguindo o percurso do mercado', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 100),
        LinhaIngrediente(alimentoId: 3, unidade: Unidade.g, quantidade: 300),
      ]);
      expect(r.map((e) => e.secao).toList(),
          [SecaoMercado.hortifruti, SecaoMercado.mercearia]);
    });

    test('devolve lista vazia para entrada vazia', () {
      expect(agregar(const []), isEmpty);
    });

    test('carrega secao e unidade de compra no item', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 2, unidade: Unidade.g, quantidade: 50),
      ]);
      expect(r.single.secao, SecaoMercado.mercearia);
      expect(r.single.unidadeCompra, UnidadeCompra.unidade);
    });
  });

  group('formatarCompra', () {
    test('vira quilo a partir de mil gramas', () {
      final f = formatarCompra(
          gramas: 1200, compra: UnidadeCompra.kg, gramasPorUnidade: null);
      expect(f.valor, closeTo(1.2, 0.001));
      expect(f.unidade, 'kg');
    });

    test('abaixo de mil continua em grama', () {
      final f = formatarCompra(
          gramas: 800, compra: UnidadeCompra.kg, gramasPorUnidade: null);
      expect(f.valor, 800);
      expect(f.unidade, 'g');
    });

    test('mil gramas exatos ja viram quilo', () {
      final f = formatarCompra(
          gramas: 1000, compra: UnidadeCompra.kg, gramasPorUnidade: null);
      expect(f.valor, 1);
      expect(f.unidade, 'kg');
    });

    test('litro segue a mesma regra', () {
      final f = formatarCompra(
          gramas: 3000, compra: UnidadeCompra.litro, gramasPorUnidade: null);
      expect(f.valor, 3);
      expect(f.unidade, 'L');
    });

    test('unidade divide pela massa e arredonda para cima', () {
      // 260 g de ovo com 50 g por ovo = 5,2 ovos = 6 ovos
      final f = formatarCompra(
          gramas: 260, compra: UnidadeCompra.unidade, gramasPorUnidade: 50);
      expect(f.valor, 6);
      expect(f.unidade, 'un');
    });

    test('unidade sem massa cadastrada cai em grama em vez de estourar', () {
      final f = formatarCompra(
          gramas: 260, compra: UnidadeCompra.unidade, gramasPorUnidade: null);
      expect(f.unidade, 'g');
    });
  });

  test('ordemSecoes cobre todas as secoes, sem repetir', () {
    expect(ordemSecoes.toSet(), SecaoMercado.values.toSet());
    expect(ordemSecoes, hasLength(SecaoMercado.values.length));
  });
}
