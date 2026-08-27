import 'package:flutter/material.dart';

import '../tema/cores.dart';

/// Foto do prato montado, encaixada com uma margem de louça em volta: o cartão
/// é o prato e a comida fica na aba dele. Tratamento "Prato", escolhido em
/// `mocks/04-esmalte-com-fotos.html`.
///
/// A foto é sempre do **combo** — o prato inteiro como ela vê na mesa. Receita
/// solta ("Arroz branco") não tem foto própria e não usa este widget.
class FotoPrato extends StatelessWidget {
  /// Asset da foto. Nulo devolve altura zero: nenhum espaço reservado, nenhuma
  /// moldura vazia.
  final String? caminho;

  /// Proporção do recorte. Os assets já saem em 16:9 (ver
  /// `assets/pratos/PROCEDENCIA.json`), então o padrão não recorta nada.
  final double proporcao;

  /// Refeição espelhada: a foto desbota junto com o cartão, do mesmo jeito que
  /// o aro vira cinza.
  final bool apagado;

  const FotoPrato({
    super.key,
    required this.caminho,
    this.proporcao = 16 / 9,
    this.apagado = false,
  });

  @override
  Widget build(BuildContext context) {
    final caminho = this.caminho;
    if (caminho == null) return const SizedBox.shrink();

    final cores = context.esmalte;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: AspectRatio(
        aspectRatio: proporcao,
        child: Opacity(
          opacity: apagado ? .55 : 1,
          child: LayoutBuilder(
            builder: (_, limites) => Image.asset(
              caminho,
              fit: BoxFit.cover,
              // Decodifica no tamanho em que aparece, não nos 900 px do
              // arquivo: a Hoje mantém quatro fotos vivas ao mesmo tempo.
              cacheWidth: limites.maxWidth.isFinite
                  ? (limites.maxWidth * dpr).round()
                  : null,
              // Asset ausente não pode derrubar a tela. O Plano 2 sobe 66
              // fotos; uma faltando é erro de conteúdo, não tela vermelha.
              errorBuilder: (_, _, _) => ColoredBox(
                color: cores.superficie2,
                child: Center(
                  child: Icon(Icons.restaurant_outlined,
                      size: 20, color: cores.linha),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
