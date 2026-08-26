import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/ciclo.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  const inicio = DataPura('2026-09-01');
  int pos(String iso) =>
      posicaoNoCiclo(inicio: inicio, data: DataPura(iso), tamanho: 33);

  test('o dia do inicio e a posicao 1', () {
    expect(pos('2026-09-01'), 1);
  });

  test('avanca um por dia', () {
    expect(pos('2026-09-02'), 2);
    expect(pos('2026-09-04'), 4);
  });

  test('o ultimo dia do ciclo e 33', () {
    expect(pos('2026-10-03'), 33);
  });

  test('depois do 33 volta para 1', () {
    expect(pos('2026-10-04'), 1);
    expect(pos('2026-10-05'), 2);
  });

  test('data anterior ao inicio nao devolve zero nem negativo', () {
    expect(pos('2026-08-31'), 33);
    expect(pos('2026-08-30'), 32);
    expect(pos('2026-07-30'), 1);
  });

  test('atravessa a virada de ano', () {
    const natal = DataPura('2026-12-20');
    expect(
      posicaoNoCiclo(
          inicio: natal, data: const DataPura('2027-01-05'), tamanho: 33),
      17,
    );
  });

  test('respeita ano bissexto', () {
    expect(
      posicaoNoCiclo(
          inicio: const DataPura('2028-02-28'),
          data: const DataPura('2028-03-01'),
          tamanho: 33),
      3,
    );
  });

  test('o tamanho e parametro, nao constante', () {
    expect(
      posicaoNoCiclo(
          inicio: inicio, data: const DataPura('2026-09-08'), tamanho: 7),
      1,
    );
  });

  test('sempre devolve entre 1 e o tamanho', () {
    for (var i = -400; i < 400; i++) {
      final d = DataPura.de(inicio.comoDateTime.add(Duration(days: i)));
      final p = posicaoNoCiclo(inicio: inicio, data: d, tamanho: 33);
      expect(p, inInclusiveRange(1, 33), reason: 'falhou em ${d.iso}');
    }
  });
}
