import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'cores.dart';

/// O campo marinho salpicado — o elemento-assinatura da direção.
///
/// Semente fixa de propósito: o padrão precisa ser o mesmo em todo repaint e
/// em todo teste. Três camadas com raios e densidades diferentes, para não
/// parecer grade.
class PinturaRespingo extends CustomPainter {
  final Color base;

  const PinturaRespingo({required this.base});

  static const _camadas = [
    (passo: 37.0, raio: .9, opacidade: .80),
    (passo: 53.0, raio: .7, opacidade: .44),
    (passo: 71.0, raio: 1.3, opacidade: .26),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final rnd = math.Random(7);
    for (final c in _camadas) {
      final tinta = Paint()..color = Colors.white.withValues(alpha: c.opacidade);
      final colunas = (size.width / c.passo).ceil() + 1;
      final linhas = (size.height / c.passo).ceil() + 1;

      for (var i = 0; i < colunas; i++) {
        for (var j = 0; j < linhas; j++) {
          final dx = (i + rnd.nextDouble()) * c.passo;
          final dy = (j + rnd.nextDouble()) * c.passo;
          canvas.drawCircle(Offset(dx, dy), c.raio, tinta);
        }
      }
    }
  }

  @override
  bool shouldRepaint(PinturaRespingo antigo) => antigo.base != base;
}

/// Envelope pronto: campo salpicado com conteúdo em branco por cima.
class CampoRespingo extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CampoRespingo({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 13, 16, 15),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PinturaRespingo(base: context.esmalte.marinho),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.esmalte.aro, width: 2),
          ),
        ),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: Colors.white),
          child: IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: child,
          ),
        ),
      ),
    );
  }
}
