import 'package:drift/drift.dart';

import '../domain/modelos.dart';

/// Grava `DataPura` como texto ISO `YYYY-MM-DD`. É o que mantém a promessa de
/// data pura: nada de fuso, nada de instante, e ordenável como string.
class DataPuraConverter extends TypeConverter<DataPura, String> {
  const DataPuraConverter();

  @override
  DataPura fromSql(String fromDb) => DataPura(fromDb);

  @override
  String toSql(DataPura value) => value.iso;
}
