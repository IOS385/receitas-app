import 'package:flutter/material.dart';

class ReceitaScreen extends StatelessWidget {
  final int receitaId;
  const ReceitaScreen({super.key, required this.receitaId});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Receita $receitaId')));
}
