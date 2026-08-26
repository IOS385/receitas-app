import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/espelho.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  test('cafe da tarde espelha o cafe da manha', () {
    expect(slotBase(SlotRefeicao.cafeTarde), SlotRefeicao.cafeManha);
  });

  test('jantar espelha o almoco', () {
    expect(slotBase(SlotRefeicao.jantar), SlotRefeicao.almoco);
  });

  test('slots base sao base de si mesmos', () {
    expect(slotBase(SlotRefeicao.cafeManha), SlotRefeicao.cafeManha);
    expect(slotBase(SlotRefeicao.almoco), SlotRefeicao.almoco);
  });

  test('ehEspelhado separa os dois pares', () {
    expect(ehEspelhado(SlotRefeicao.cafeTarde), isTrue);
    expect(ehEspelhado(SlotRefeicao.jantar), isTrue);
    expect(ehEspelhado(SlotRefeicao.cafeManha), isFalse);
    expect(ehEspelhado(SlotRefeicao.almoco), isFalse);
  });

  test('o espelho nao e circular', () {
    for (final s in SlotRefeicao.values) {
      expect(slotBase(slotBase(s)), slotBase(s),
          reason: 'slotBase precisa ser idempotente para $s');
    }
  });

  test('tipo do slot agrupa cafes e refeicoes', () {
    expect(tipoDoSlot(SlotRefeicao.cafeManha), TipoCombo.cafe);
    expect(tipoDoSlot(SlotRefeicao.cafeTarde), TipoCombo.cafe);
    expect(tipoDoSlot(SlotRefeicao.almoco), TipoCombo.refeicao);
    expect(tipoDoSlot(SlotRefeicao.jantar), TipoCombo.refeicao);
  });
}
