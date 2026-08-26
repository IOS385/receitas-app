import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/domain/resolucao.dart';

void main() {
  const data = DataPura('2026-09-04');

  // ciclo minimo: posicao 4 tem cafe 40 e refeicao 41
  const ciclo = {
    (4, TipoCombo.cafe): 40,
    (4, TipoCombo.refeicao): 41,
  };

  // combo 40 = [tapioca 1, mamao 2, suco 3]
  // combo 41 = [arroz 10, feijao 11, picadinho 12, batata 13, salada 14]
  // combo 99 = [strogonoff 20, arroz 10]
  const componentes = {
    40: [1, 2, 3],
    41: [10, 11, 12, 13, 14],
    99: [20, 10],
  };

  RefeicaoResolvida r(
    SlotRefeicao slot, {
    Map<(DataPura, SlotRefeicao), int> combos = const {},
    Map<(DataPura, SlotRefeicao), Map<int, int?>> comps = const {},
    int porcoes = 1,
  }) =>
      resolverRefeicao(
        data: data,
        slot: slot,
        posicao: 4,
        porcoes: porcoes,
        ciclo: ciclo,
        componentesDoCombo: componentes,
        overridesCombo: combos,
        overridesComponente: comps,
      );

  group('sem nenhuma excecao', () {
    test('cafe da manha pega o combo de cafe do ciclo', () {
      final res = r(SlotRefeicao.cafeManha);
      expect(res.comboId, 40);
      expect(res.receitaIds, [1, 2, 3]);
      expect(res.espelhoIntacto, isTrue);
    });

    test('almoco pega o combo de refeicao do ciclo', () {
      expect(r(SlotRefeicao.almoco).comboId, 41);
    });

    test('cafe da tarde espelha o cafe da manha', () {
      final res = r(SlotRefeicao.cafeTarde);
      expect(res.comboId, 40);
      expect(res.receitaIds, [1, 2, 3]);
      expect(res.espelhoIntacto, isTrue);
    });

    test('jantar espelha o almoco', () {
      expect(r(SlotRefeicao.jantar).comboId, 41);
    });

    test('carrega as porcoes recebidas', () {
      expect(r(SlotRefeicao.jantar, porcoes: 2).porcoes, 2);
    });
  });

  group('substituicao de combo', () {
    test('override no almoco troca o combo', () {
      final res = r(SlotRefeicao.almoco,
          combos: {(data, SlotRefeicao.almoco): 99});
      expect(res.comboId, 99);
      expect(res.receitaIds, [20, 10]);
    });

    test('override no almoco arrasta o jantar junto', () {
      final res = r(SlotRefeicao.jantar,
          combos: {(data, SlotRefeicao.almoco): 99});
      expect(res.comboId, 99, reason: 'o espelho ainda esta intacto');
      expect(res.espelhoIntacto, isTrue);
    });

    test('override no jantar solta o espelho', () {
      final res = r(SlotRefeicao.jantar,
          combos: {(data, SlotRefeicao.jantar): 99});
      expect(res.comboId, 99);
      expect(res.espelhoIntacto, isFalse);
    });

    test('override no jantar nao volta para o almoco', () {
      final res = r(SlotRefeicao.almoco,
          combos: {(data, SlotRefeicao.jantar): 99});
      expect(res.comboId, 41, reason: 'o almoco continua o do ciclo');
    });

    test('override proprio vence o override do slot base', () {
      final res = r(SlotRefeicao.jantar, combos: {
        (data, SlotRefeicao.almoco): 99,
        (data, SlotRefeicao.jantar): 40,
      });
      expect(res.comboId, 40);
      expect(res.espelhoIntacto, isFalse);
    });
  });

  group('substituicao de componente', () {
    test('troca um componente e preserva a ordem', () {
      final res = r(SlotRefeicao.almoco, comps: {
        (data, SlotRefeicao.almoco): {12: 20},
      });
      expect(res.receitaIds, [10, 11, 20, 13, 14]);
    });

    test('componente com destino nulo e removido', () {
      final res = r(SlotRefeicao.almoco, comps: {
        (data, SlotRefeicao.almoco): {14: null},
      });
      expect(res.receitaIds, [10, 11, 12, 13]);
    });

    test('troca no almoco reflete no jantar com espelho intacto', () {
      final res = r(SlotRefeicao.jantar, comps: {
        (data, SlotRefeicao.almoco): {12: 20},
      });
      expect(res.receitaIds, [10, 11, 20, 13, 14]);
    });

    test('slot com override de combo proprio nao herda componente do base', () {
      final res = r(SlotRefeicao.jantar,
          combos: {(data, SlotRefeicao.jantar): 41},
          comps: {
            (data, SlotRefeicao.almoco): {12: 20},
          });
      expect(res.receitaIds, [10, 11, 12, 13, 14],
          reason: 'o jantar se soltou do espelho e ignora o almoco');
    });

    test('camada do slot roda depois da camada do base', () {
      final res = r(SlotRefeicao.jantar, comps: {
        (data, SlotRefeicao.almoco): {12: 20},
        (data, SlotRefeicao.jantar): {20: 13},
      });
      expect(res.receitaIds, [10, 11, 13, 13, 14]);
    });

    test('substituicao de componente sozinha nao solta o espelho', () {
      final res = r(SlotRefeicao.jantar, comps: {
        (data, SlotRefeicao.jantar): {12: 20},
      });
      expect(res.espelhoIntacto, isTrue);
      expect(res.comboId, 41);
    });
  });

  group('falha alto', () {
    test('posicao sem combo no ciclo estoura', () {
      expect(
        () => resolverRefeicao(
          data: data,
          slot: SlotRefeicao.almoco,
          posicao: 7,
          porcoes: 1,
          ciclo: ciclo,
          componentesDoCombo: componentes,
          overridesCombo: const {},
          overridesComponente: const {},
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('combo sem componentes cadastrados estoura', () {
      expect(
        () => r(SlotRefeicao.almoco,
            combos: {(data, SlotRefeicao.almoco): 555}),
        throwsA(isA<StateError>()),
      );
    });
  });
}
