import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/domain/porcoes.dart';

void main() {
  // 2026-09-04 e uma sexta; 2026-09-05 sabado; 2026-09-06 domingo;
  // 2026-09-07 segunda.
  const sexta = DataPura('2026-09-04');
  const sabado = DataPura('2026-09-05');
  const domingo = DataPura('2026-09-06');
  const segunda = DataPura('2026-09-07');

  int p(SlotRefeicao s, DataPura d) =>
      porcoesDoSlot(slot: s, data: d, regras: regrasPadrao);

  test('reconhece dia util', () {
    expect(ehDiaUtil(sexta), isTrue);
    expect(ehDiaUtil(segunda), isTrue);
    expect(ehDiaUtil(sabado), isFalse);
    expect(ehDiaUtil(domingo), isFalse);
  });

  test('durante a semana ela almoca sozinha', () {
    expect(p(SlotRefeicao.cafeManha, sexta), 1);
    expect(p(SlotRefeicao.almoco, sexta), 1);
  });

  test('durante a semana a tarde e a noite sao dois', () {
    expect(p(SlotRefeicao.cafeTarde, sexta), 2);
    expect(p(SlotRefeicao.jantar, sexta), 2);
  });

  test('no fim de semana tudo e dois', () {
    for (final slot in SlotRefeicao.values) {
      expect(p(slot, sabado), 2, reason: '$slot no sabado');
      expect(p(slot, domingo), 2, reason: '$slot no domingo');
    }
  });

  test('regrasPadrao cobre as oito combinacoes', () {
    expect(regrasPadrao.length, 8);
    for (final slot in SlotRefeicao.values) {
      for (final util in [true, false]) {
        expect(regrasPadrao.containsKey((slot, util)), isTrue,
            reason: 'falta ($slot, $util)');
      }
    }
  });

  test('aceita regra customizada', () {
    const custom = {
      (SlotRefeicao.almoco, true): 3,
      (SlotRefeicao.almoco, false): 4,
    };
    expect(
        porcoesDoSlot(
            slot: SlotRefeicao.almoco, data: sexta, regras: custom),
        3);
    expect(
        porcoesDoSlot(
            slot: SlotRefeicao.almoco, data: sabado, regras: custom),
        4);
  });

  test('regra faltando cai em uma porcao em vez de estourar', () {
    expect(
        porcoesDoSlot(
            slot: SlotRefeicao.jantar, data: sexta, regras: const {}),
        1);
  });
}
