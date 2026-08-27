import 'package:flutter/material.dart';

import '../tema/cores.dart';

/// Cartão de esmalte branco com 2,5 px de marinho na borda de cima — a faixa
/// escura onde o esmalte termina e o aço aparece.
///
/// Com [apagado] em true o aro vira cinza e o fundo recua: é como uma refeição
/// espelhada se distingue de uma original sem ler uma palavra.
class CartaoEsmalte extends StatelessWidget {
  final Widget child;
  final bool apagado;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const CartaoEsmalte({
    super.key,
    required this.child,
    this.apagado = false,
    this.onTap,
    this.padding = const EdgeInsets.fromLTRB(14, 13, 14, 12),
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    final tema = Theme.of(context);
    final raio = BorderRadius.circular(12);

    // O aro tem cor diferente no topo — Flutter só pinta `Border` com
    // `borderRadius` quando as cores dos lados são uniformes (senão lança
    // "A borderRadius can only be given on borders with uniform colors."
    // em box_border.dart). O arredondamento sai da decoração e vira um
    // ClipRRect por fora, mantendo o `Border` não-uniforme igual ao pedido.
    final corpo = ClipRRect(
      borderRadius: raio,
      child: Container(
        decoration: BoxDecoration(
          color: apagado ? cores.superficie2 : tema.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: apagado ? cores.linha : cores.marinho,
              width: 2.5,
            ),
            left: BorderSide(color: cores.linha),
            right: BorderSide(color: cores.linha),
            bottom: BorderSide(color: cores.linha),
          ),
        ),
        padding: padding,
        child: child,
      ),
    );

    if (onTap == null) return corpo;

    return Material(
      color: Colors.transparent,
      borderRadius: raio,
      child: InkWell(
        onTap: onTap,
        borderRadius: raio,
        child: corpo,
      ),
    );
  }
}
