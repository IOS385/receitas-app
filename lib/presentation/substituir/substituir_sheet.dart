import 'package:flutter/material.dart';

import '../../data/repo_plano.dart';
import '../../domain/modelos.dart';

Future<void> abrirSubstituir({
  required BuildContext context,
  required DataPura data,
  required RefeicaoDoDia refeicao,
}) =>
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Trocar a refeição inteira'),
      ),
    );
