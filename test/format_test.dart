import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/format.dart';

void main() {
  group('qtd', () {
    test('grama arredonda para inteiro', () {
      expect(qtd(119.6, Unidade.g), '120 g');
      expect(qtd(240, Unidade.g), '240 g');
    });

    test('mililitro tambem', () {
      expect(qtd(200, Unidade.ml), '200 ml');
    });

    test('colher arredonda para meio', () {
      expect(qtd(1.5, Unidade.colherSopa), '1,5 col. sopa');
      expect(qtd(1.2, Unidade.colherSopa), '1 col. sopa');
      expect(qtd(1.8, Unidade.colherSopa), '2 col. sopa');
    });

    test('discreta pluraliza', () {
      expect(qtd(1, Unidade.dente), '1 dente');
      expect(qtd(2, Unidade.dente), '2 dentes');
      expect(qtd(5, Unidade.folha), '5 folhas');
    });

    test('unidade nao pluraliza a abreviacao', () {
      expect(qtd(2, Unidade.unidade), '2 un');
    });

    test('sem medida vira texto', () {
      expect(qtd(1, Unidade.aGosto), 'a gosto');
      expect(qtd(1, Unidade.pitada), 'uma pitada');
    });
  });

  test('kcal arredonda', () {
    expect(kcal(437.6), '438 kcal');
  });

  test('rotulos dos slots', () {
    expect(rotuloSlot(SlotRefeicao.cafeManha), 'Café da manhã');
    expect(rotuloSlot(SlotRefeicao.cafeTarde), 'Café da tarde');
  });

  test('vegetal aparece como Legume na tela', () {
    expect(rotuloCategoria(CategoriaReceita.vegetal), 'Legume');
  });

  test('porcoes no singular e no plural', () {
    expect(porcoesTexto(1), '1 porção');
    expect(porcoesTexto(2), '2 porções');
  });

  test('data longa em portugues', () {
    expect(dataLonga(const DataPura('2026-09-04')), 'sexta, 4 de setembro');
    expect(dataLonga(const DataPura('2026-09-05')), 'sábado, 5 de setembro');
  });
}
