import 'modelos.dart';

/// O slot de onde este slot herda conteúdo. Café da tarde repete o café da
/// manhã e o jantar repete o almoço — é o que o plano de origem já faz.
SlotRefeicao slotBase(SlotRefeicao slot) => switch (slot) {
      SlotRefeicao.cafeTarde => SlotRefeicao.cafeManha,
      SlotRefeicao.jantar => SlotRefeicao.almoco,
      SlotRefeicao.cafeManha => SlotRefeicao.cafeManha,
      SlotRefeicao.almoco => SlotRefeicao.almoco,
    };

bool ehEspelhado(SlotRefeicao slot) => slotBase(slot) != slot;

/// Qual pool do ciclo alimenta este slot.
TipoCombo tipoDoSlot(SlotRefeicao slot) =>
    slotBase(slot) == SlotRefeicao.cafeManha
        ? TipoCombo.cafe
        : TipoCombo.refeicao;
