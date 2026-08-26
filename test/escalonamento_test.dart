import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/escalonamento.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  double e(double q, Unidade u, int porcoes, int rendimento) =>
      escalarQuantidade(
          quantidade: q, unidade: u, porcoes: porcoes, rendimento: rendimento);

  test('unidade continua multiplica direto', () {
    expect(e(120, Unidade.g, 2, 1), 240);
    expect(e(200, Unidade.ml, 2, 1), 400);
  });

  test('unidade continua mantem o decimal', () {
    expect(e(100, Unidade.g, 3, 2), 150);
    expect(e(1, Unidade.colherSopa, 3, 2), 1.5);
  });

  test('unidade discreta arredonda para cima', () {
    expect(e(1, Unidade.unidade, 3, 2), 2);
    expect(e(1, Unidade.dente, 3, 2), 2);
    expect(e(2, Unidade.fatia, 3, 2), 3);
  });

  test('discreta que da inteiro exato nao infla', () {
    expect(e(1, Unidade.unidade, 2, 1), 2);
    expect(e(3, Unidade.unidade, 1, 1), 3);
  });

  test('a gosto e pitada nao escalam', () {
    expect(e(1, Unidade.aGosto, 4, 1), 1);
    expect(e(1, Unidade.pitada, 4, 1), 1);
  });

  test('reduzir porcao tambem funciona', () {
    expect(e(400, Unidade.g, 1, 4), 100);
  });

  test('reduzir discreta ainda arredonda para cima', () {
    // meia unidade continua sendo uma unidade inteira na panela
    expect(e(1, Unidade.unidade, 1, 2), 1);
  });

  test('resultado inteiro exato nao infla por erro de ponto flutuante', () {
    // com `quantidade * (porcoes / rendimento)` isto dava 28
    expect(e(21, Unidade.unidade, 9, 7), 27);
    expect(e(25, Unidade.fatia, 11, 5), 55);
    expect(e(27, Unidade.dente, 7, 3), 63);
  });

  test('rendimento zero nao divide por zero', () {
    expect(e(100, Unidade.g, 2, 0), 100);
  });
}
