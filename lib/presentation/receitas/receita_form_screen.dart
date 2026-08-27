import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../../domain/nutricao.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'receitas_provider.dart';

/// Quantidade no campo de texto. Inteiro quando é inteiro; vírgula decimal,
/// que é como ela escreve meia colher.
String _textoQuantidade(double v) => v == v.roundToDouble()
    ? '${v.round()}'
    : v.toString().replaceAll('.', ',');

/// Lê de volta o que ela digitou. Aceita vírgula e ponto; vazio conta como
/// zero, para o painel de macros acompanhar enquanto ela apaga e redigita.
double _lerQuantidade(String texto) =>
    double.tryParse(texto.trim().replaceAll(',', '.')) ?? 0;

/// Linha em edição. Mutável de propósito: é estado de formulário.
class _LinhaIng {
  int alimentoId;
  String nome;
  double quantidade;
  Unidade unidade;
  String? observacao;

  /// A quantidade é campo de texto (spec D8 / risco 2 da seção 18: ela corrige
  /// o que estiver errado sem depender de código), então cada linha carrega o
  /// controller dela. `late` para poder ler `quantidade` já atribuída.
  late final TextEditingController ctrlQtd =
      TextEditingController(text: _textoQuantidade(quantidade));

  _LinhaIng({
    required this.alimentoId,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    this.observacao,
  });
}

class ReceitaFormScreen extends ConsumerStatefulWidget {
  final int? receitaId;
  const ReceitaFormScreen({super.key, this.receitaId});

  @override
  ConsumerState<ReceitaFormScreen> createState() => _FormState();
}

class _FormState extends ConsumerState<ReceitaFormScreen> {
  final _nome = TextEditingController();
  final _preparo = TextEditingController();
  var _categoria = CategoriaReceita.proteina;
  var _rende = 1;
  var _tempo = 20;
  final _ingredientes = <_LinhaIng>[];
  var _salvando = false;

  /// Falha do carregamento, guardada para a tela poder mostrar saida.
  /// Sem isto o FutureBuilder ficava em `connectionState != done` para sempre:
  /// um spinner eterno, nem o botao Cancelar desenhado.
  Object? _erro;

  // A Future e criada UMA vez. `FutureBuilder(future: _carregar())` dentro do
  // build criaria uma nova a cada rebuild, e `_carregar` chama setState —
  // o guard evitava o pior, mas o padrao certo e carregar uma vez so.
  late final Future<void> _futuroCarregar;

  bool get _novo => widget.receitaId == null;

  @override
  void initState() {
    super.initState();
    _futuroCarregar = _carregar();
  }

  @override
  void dispose() {
    _nome.dispose();
    _preparo.dispose();
    for (final l in _ingredientes) {
      l.ctrlQtd.dispose();
    }
    super.dispose();
  }

  Future<void> _carregar() async {
    if (_novo) return;
    final DetalheReceita d;
    try {
      d = await ref.read(detalheProvider(widget.receitaId!).future);
    } catch (e) {
      if (mounted) setState(() => _erro = e);
      return;
    }
    if (!mounted) return;
    setState(() {
      _nome.text = d.receita.nome;
      _preparo.text = d.receita.modoPreparo;
      _categoria = d.receita.categoria;
      _rende = d.receita.rendimentoPorcoes;
      _tempo = d.receita.tempoPreparoMin;
      for (final l in _ingredientes) {
        l.ctrlQtd.dispose();
      }
      _ingredientes
        ..clear()
        ..addAll(d.ingredientes.map((i) => _LinhaIng(
              alimentoId: i.alimentoId,
              nome: i.nome,
              quantidade: i.quantidade,
              unidade: i.unidade,
              observacao: i.observacao,
            )));
    });
  }

  /// Nutrição recalculada na hora a partir das linhas em edição.
  Future<Nutrientes> _calcular() async {
    final db = ref.read(bancoProvider);
    final alimentos = {
      for (final a in await db.select(db.alimentos).get()) a.id: a,
    };
    final conversoes = <int, Map<Unidade, double>>{};
    for (final c in await db.select(db.conversoes).get()) {
      conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
    }

    var n = Nutrientes.zero;
    for (final l in _ingredientes) {
      final a = alimentos[l.alimentoId];
      if (a == null) continue;
      final gramas = emGramas(
        unidade: l.unidade,
        quantidade: l.quantidade,
        conversoes: conversoes[a.id] ?? const {},
        alimentoId: a.id,
      );
      n = n +
          nutrienteDe(
            por100g: Nutrientes(
              kcal: a.kcal100g,
              carboidrato: a.carboidratoG,
              proteina: a.proteinaG,
              gordura: a.gorduraG,
              fibra: a.fibraG,
              sodio: a.sodioMg,
            ),
            gramas: gramas,
          );
    }
    return n;
  }

  Future<void> _salvar() async {
    if (_nome.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dê um nome à receita.')));
      return;
    }
    if (_ingredientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicione pelo menos um ingrediente.')));
      return;
    }

    setState(() => _salvando = true);
    await ref.read(repoReceitasProvider).salvar(
          id: widget.receitaId,
          nome: _nome.text.trim(),
          categoria: _categoria,
          rendimentoPorcoes: _rende,
          tempoPreparoMin: _tempo,
          modoPreparo: _preparo.text.trim(),
          ingredientes: _ingredientes
              .map((l) => (
                    alimentoId: l.alimentoId,
                    quantidade: l.quantidade,
                    unidade: l.unidade,
                    observacao: l.observacao,
                  ))
              .toList(),
        );

    ref.invalidate(catalogoProvider);
    ref.invalidate(diaProvider);
    if (widget.receitaId != null) {
      ref.invalidate(detalheProvider(widget.receitaId!));
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return FutureBuilder<void>(
      future: _futuroCarregar,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final erro = _erro ?? snap.error;
        if (erro != null) return _telaDeErro(erro);

        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              CampoRespingo(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              minimumSize: const Size(44, 44)),
                          child: const Text('Cancelar'),
                        ),
                        const Spacer(),
                        if (!_novo)
                          IconButton(
                            tooltip: 'Excluir',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: _confirmarExclusao,
                          ),
                      ],
                    ),
                    Text(_novo ? 'Nova receita' : 'Editar receita',
                        style: t.displaySmall?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rotulo('Nome'),
                    TextField(
                      controller: _nome,
                      style: t.titleMedium,
                      decoration: _campo(context, 'Nome do prato'),
                    ),

                    _rotulo('Categoria'),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (final c in CategoriaReceita.values)
                          ChoiceChip(
                            label: Text(rotuloCategoria(c)),
                            selected: _categoria == c,
                            showCheckmark: false,
                            selectedColor: cores.marinho,
                            labelStyle: t.bodySmall?.copyWith(
                                color: _categoria == c
                                    ? Colors.white
                                    : cores.ink2),
                            onSelected: (_) =>
                                setState(() => _categoria = c),
                          ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _rotulo('Rende'),
                              _Contador(
                                valor: '$_rende ${_rende == 1 ? 'porção' : 'porções'}',
                                onMenos: _rende > 1
                                    ? () => setState(() => _rende--)
                                    : null,
                                onMais: () => setState(() => _rende++),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _rotulo('Tempo'),
                              _Contador(
                                valor: '$_tempo min',
                                onMenos: _tempo > 5
                                    ? () => setState(() => _tempo -= 5)
                                    : null,
                                onMais: () => setState(() => _tempo += 5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    _rotulo('Ingredientes'),
                    for (var i = 0; i < _ingredientes.length; i++)
                      _linhaIngrediente(i),
                    OutlinedButton.icon(
                      onPressed: _adicionarIngrediente,
                      icon: const Icon(Icons.add, size: 17),
                      label: const Text('Adicionar ingrediente'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),

                    _rotulo('Modo de preparo'),
                    TextField(
                      controller: _preparo,
                      maxLines: null,
                      minLines: 4,
                      decoration: _campo(
                          context, 'Um passo por linha'),
                    ),

                    _rotulo('Valor nutricional'),
                    _PainelCalculado(calcular: _calcular),

                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: _salvando ? null : _salvar,
                      child: Text(_salvando ? 'Salvando…' : 'Salvar receita'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Saida quando a receita nao pode ser montada. O importante e o Voltar:
  /// sem ele ela fica presa numa tela sem nenhum botao.
  Widget _telaDeErro(Object erro) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.chevron_left, size: 19),
                label: const Text('Voltar'),
                style: TextButton.styleFrom(
                    minimumSize: const Size(44, 44)),
              ),
              const SizedBox(height: 12),
              Text('Não foi possível abrir esta receita.',
                  style: t.titleMedium),
              const SizedBox(height: 8),
              Text(_recado(erro), style: t.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rotulo(String texto) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 7),
        child: Text(texto.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary)),
      );

  InputDecoration _campo(BuildContext context, String dica) {
    final cores = context.esmalte;
    return InputDecoration(
      hintText: dica,
      isDense: true,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: cores.linha),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: cores.linha),
      ),
    );
  }

  Widget _linhaIngrediente(int i) {
    final l = _ingredientes[i];
    final cores = context.esmalte;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: cores.linha),
        ),
        // Larguras fixas somam 200 dp; num viewport de 412 dp sobram ~164 dp
        // para o nome, que elide. Nada aqui pode virar Expanded solto: a linha
        // ja era apertada com o texto da medida no lugar dos campos.
        child: Row(
          children: [
            Expanded(
              child: Text(l.nome,
                  style: t.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(
              width: 54,
              child: TextField(
                key: ValueKey('qtd-${l.nome}'),
                controller: l.ctrlQtd,
                textAlign: TextAlign.end,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: t.labelMedium?.copyWith(fontSize: 12.5),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
                onChanged: (texto) =>
                    setState(() => l.quantidade = _lerQuantidade(texto)),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 92,
              child: DropdownButton<Unidade>(
                key: ValueKey('unidade-${l.nome}'),
                value: l.unidade,
                isExpanded: true,
                isDense: true,
                style: t.labelMedium?.copyWith(color: cores.ink2),
                items: [
                  for (final u in Unidade.values)
                    DropdownMenuItem(
                      value: u,
                      child: Text(rotuloUnidade(u),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (u) {
                  if (u == null) return;
                  setState(() => l.unidade = u);
                },
              ),
            ),
            IconButton(
              tooltip: 'Remover ${l.nome}',
              icon: const Icon(Icons.close, size: 17),
              onPressed: () =>
                  setState(() => _ingredientes.removeAt(i).ctrlQtd.dispose()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _adicionarIngrediente() async {
    final alimentos = await ref.read(repoReceitasProvider).alimentos();
    if (!mounted) return;

    final escolhido = await showModalBottomSheet<Alimento>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(ctx).size.height * .6,
          child: ListView.builder(
            itemCount: alimentos.length,
            itemBuilder: (ctx, i) => ListTile(
              title: Text(alimentos[i].nome),
              onTap: () => Navigator.of(ctx).pop(alimentos[i]),
            ),
          ),
        ),
      ),
    );
    if (escolhido == null || !mounted) return;

    setState(() => _ingredientes.add(_LinhaIng(
          alimentoId: escolhido.id,
          nome: escolhido.nome,
          quantidade: 100,
          unidade: Unidade.g,
        )));
  }

  Future<void> _confirmarExclusao() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir receita?'),
        content: const Text(
            'Ela sai do catálogo. Dias que já usaram a receita continuam '
            'como estão.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (ok != true) return;

    await ref.read(repoReceitasProvider).excluir(widget.receitaId!);
    ref.invalidate(catalogoProvider);
    if (mounted) Navigator.of(context).pop();
  }
}

/// Recado de tela cheia, em vez do `toString()` cru da exceção.
String _recado(Object erro) => erro is ConversaoAusente
    ? 'Falta a conversão de unidade de um ingrediente. Corrija a unidade da '
        'linha e a conta volta.'
    : '$erro';

/// Motivo curto, em minúscula, para emendar numa frase de uma linha.
String _motivo(Object erro) => erro is ConversaoAusente
    ? 'falta conversão de unidade para um ingrediente'
    : '$erro';

class _Contador extends StatelessWidget {
  final String valor;
  final VoidCallback? onMenos;
  final VoidCallback? onMais;

  const _Contador({
    required this.valor,
    required this.onMenos,
    required this.onMais,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(valor,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          IconButton(
              icon: const Icon(Icons.remove, size: 17),
              onPressed: onMenos,
              tooltip: 'Menos'),
          IconButton(
              icon: const Icon(Icons.add, size: 17),
              onPressed: onMais,
              tooltip: 'Mais'),
        ],
      ),
    );
  }
}

/// Painel travado. A nutrição não é campo de formulário: vem dos ingredientes.
class _PainelCalculado extends StatelessWidget {
  final Future<Nutrientes> Function() calcular;
  const _PainelCalculado({required this.calcular});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cores.superficie2,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculado dos ingredientes pela tabela TACO. Muda sozinho quando '
            'você edita a lista acima — não dá pra digitar à mão.',
            style: t.labelMedium?.copyWith(color: cores.ink3),
          ),
          const SizedBox(height: 10),
          FutureBuilder<Nutrientes>(
            future: calcular(),
            builder: (context, snap) {
              // Zero calado e pior que quebrar (ver nutricao.dart:5-9): sem
              // este branch uma conversao faltando virava "0 KCAL" na tela,
              // ela salvava, e Receita e Hoje quebravam depois.
              if (snap.hasError) {
                return Text('Não foi possível calcular: ${_motivo(snap.error!)}',
                    style: t.labelMedium?.copyWith(color: cores.brasa));
              }
              final n = snap.data ?? Nutrientes.zero;
              return Row(
                children: [
                  for (final v in [
                    (n.kcal, 'KCAL'),
                    (n.proteina, 'PROT G'),
                    (n.carboidrato, 'CARB G'),
                    (n.gordura, 'GORD G'),
                  ])
                    Expanded(
                      child: Column(
                        children: [
                          Text('${v.$1.round()}', style: t.titleMedium),
                          Text(v.$2,
                              style: t.labelSmall
                                  ?.copyWith(color: cores.ink3, fontSize: 7.5)),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
