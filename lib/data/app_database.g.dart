// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AlimentosTable extends Alimentos
    with TableInfo<$AlimentosTable, Alimento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlimentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tacoCodigoMeta = const VerificationMeta(
    'tacoCodigo',
  );
  @override
  late final GeneratedColumn<String> tacoCodigo = GeneratedColumn<String>(
    'taco_codigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kcal100gMeta = const VerificationMeta(
    'kcal100g',
  );
  @override
  late final GeneratedColumn<double> kcal100g = GeneratedColumn<double>(
    'kcal100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carboidratoGMeta = const VerificationMeta(
    'carboidratoG',
  );
  @override
  late final GeneratedColumn<double> carboidratoG = GeneratedColumn<double>(
    'carboidrato_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinaGMeta = const VerificationMeta(
    'proteinaG',
  );
  @override
  late final GeneratedColumn<double> proteinaG = GeneratedColumn<double>(
    'proteina_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gorduraGMeta = const VerificationMeta(
    'gorduraG',
  );
  @override
  late final GeneratedColumn<double> gorduraG = GeneratedColumn<double>(
    'gordura_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fibraGMeta = const VerificationMeta('fibraG');
  @override
  late final GeneratedColumn<double> fibraG = GeneratedColumn<double>(
    'fibra_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sodioMgMeta = const VerificationMeta(
    'sodioMg',
  );
  @override
  late final GeneratedColumn<double> sodioMg = GeneratedColumn<double>(
    'sodio_mg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SecaoMercado, String>
  secaoMercado = GeneratedColumn<String>(
    'secao_mercado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SecaoMercado>($AlimentosTable.$convertersecaoMercado);
  @override
  late final GeneratedColumnWithTypeConverter<UnidadeCompra, String>
  unidadeCompra = GeneratedColumn<String>(
    'unidade_compra',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<UnidadeCompra>($AlimentosTable.$converterunidadeCompra);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    tacoCodigo,
    kcal100g,
    carboidratoG,
    proteinaG,
    gorduraG,
    fibraG,
    sodioMg,
    secaoMercado,
    unidadeCompra,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alimentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Alimento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('taco_codigo')) {
      context.handle(
        _tacoCodigoMeta,
        tacoCodigo.isAcceptableOrUnknown(data['taco_codigo']!, _tacoCodigoMeta),
      );
    }
    if (data.containsKey('kcal100g')) {
      context.handle(
        _kcal100gMeta,
        kcal100g.isAcceptableOrUnknown(data['kcal100g']!, _kcal100gMeta),
      );
    } else if (isInserting) {
      context.missing(_kcal100gMeta);
    }
    if (data.containsKey('carboidrato_g')) {
      context.handle(
        _carboidratoGMeta,
        carboidratoG.isAcceptableOrUnknown(
          data['carboidrato_g']!,
          _carboidratoGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carboidratoGMeta);
    }
    if (data.containsKey('proteina_g')) {
      context.handle(
        _proteinaGMeta,
        proteinaG.isAcceptableOrUnknown(data['proteina_g']!, _proteinaGMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinaGMeta);
    }
    if (data.containsKey('gordura_g')) {
      context.handle(
        _gorduraGMeta,
        gorduraG.isAcceptableOrUnknown(data['gordura_g']!, _gorduraGMeta),
      );
    } else if (isInserting) {
      context.missing(_gorduraGMeta);
    }
    if (data.containsKey('fibra_g')) {
      context.handle(
        _fibraGMeta,
        fibraG.isAcceptableOrUnknown(data['fibra_g']!, _fibraGMeta),
      );
    } else if (isInserting) {
      context.missing(_fibraGMeta);
    }
    if (data.containsKey('sodio_mg')) {
      context.handle(
        _sodioMgMeta,
        sodioMg.isAcceptableOrUnknown(data['sodio_mg']!, _sodioMgMeta),
      );
    } else if (isInserting) {
      context.missing(_sodioMgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alimento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alimento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      tacoCodigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}taco_codigo'],
      ),
      kcal100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal100g'],
      )!,
      carboidratoG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carboidrato_g'],
      )!,
      proteinaG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}proteina_g'],
      )!,
      gorduraG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gordura_g'],
      )!,
      fibraG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fibra_g'],
      )!,
      sodioMg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sodio_mg'],
      )!,
      secaoMercado: $AlimentosTable.$convertersecaoMercado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}secao_mercado'],
        )!,
      ),
      unidadeCompra: $AlimentosTable.$converterunidadeCompra.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unidade_compra'],
        )!,
      ),
    );
  }

  @override
  $AlimentosTable createAlias(String alias) {
    return $AlimentosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SecaoMercado, String, String>
  $convertersecaoMercado = const EnumNameConverter<SecaoMercado>(
    SecaoMercado.values,
  );
  static JsonTypeConverter2<UnidadeCompra, String, String>
  $converterunidadeCompra = const EnumNameConverter<UnidadeCompra>(
    UnidadeCompra.values,
  );
}

class Alimento extends DataClass implements Insertable<Alimento> {
  final int id;
  final String nome;
  final String? tacoCodigo;
  final double kcal100g;
  final double carboidratoG;
  final double proteinaG;
  final double gorduraG;
  final double fibraG;
  final double sodioMg;
  final SecaoMercado secaoMercado;
  final UnidadeCompra unidadeCompra;
  const Alimento({
    required this.id,
    required this.nome,
    this.tacoCodigo,
    required this.kcal100g,
    required this.carboidratoG,
    required this.proteinaG,
    required this.gorduraG,
    required this.fibraG,
    required this.sodioMg,
    required this.secaoMercado,
    required this.unidadeCompra,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || tacoCodigo != null) {
      map['taco_codigo'] = Variable<String>(tacoCodigo);
    }
    map['kcal100g'] = Variable<double>(kcal100g);
    map['carboidrato_g'] = Variable<double>(carboidratoG);
    map['proteina_g'] = Variable<double>(proteinaG);
    map['gordura_g'] = Variable<double>(gorduraG);
    map['fibra_g'] = Variable<double>(fibraG);
    map['sodio_mg'] = Variable<double>(sodioMg);
    {
      map['secao_mercado'] = Variable<String>(
        $AlimentosTable.$convertersecaoMercado.toSql(secaoMercado),
      );
    }
    {
      map['unidade_compra'] = Variable<String>(
        $AlimentosTable.$converterunidadeCompra.toSql(unidadeCompra),
      );
    }
    return map;
  }

  AlimentosCompanion toCompanion(bool nullToAbsent) {
    return AlimentosCompanion(
      id: Value(id),
      nome: Value(nome),
      tacoCodigo: tacoCodigo == null && nullToAbsent
          ? const Value.absent()
          : Value(tacoCodigo),
      kcal100g: Value(kcal100g),
      carboidratoG: Value(carboidratoG),
      proteinaG: Value(proteinaG),
      gorduraG: Value(gorduraG),
      fibraG: Value(fibraG),
      sodioMg: Value(sodioMg),
      secaoMercado: Value(secaoMercado),
      unidadeCompra: Value(unidadeCompra),
    );
  }

  factory Alimento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alimento(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      tacoCodigo: serializer.fromJson<String?>(json['tacoCodigo']),
      kcal100g: serializer.fromJson<double>(json['kcal100g']),
      carboidratoG: serializer.fromJson<double>(json['carboidratoG']),
      proteinaG: serializer.fromJson<double>(json['proteinaG']),
      gorduraG: serializer.fromJson<double>(json['gorduraG']),
      fibraG: serializer.fromJson<double>(json['fibraG']),
      sodioMg: serializer.fromJson<double>(json['sodioMg']),
      secaoMercado: $AlimentosTable.$convertersecaoMercado.fromJson(
        serializer.fromJson<String>(json['secaoMercado']),
      ),
      unidadeCompra: $AlimentosTable.$converterunidadeCompra.fromJson(
        serializer.fromJson<String>(json['unidadeCompra']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'tacoCodigo': serializer.toJson<String?>(tacoCodigo),
      'kcal100g': serializer.toJson<double>(kcal100g),
      'carboidratoG': serializer.toJson<double>(carboidratoG),
      'proteinaG': serializer.toJson<double>(proteinaG),
      'gorduraG': serializer.toJson<double>(gorduraG),
      'fibraG': serializer.toJson<double>(fibraG),
      'sodioMg': serializer.toJson<double>(sodioMg),
      'secaoMercado': serializer.toJson<String>(
        $AlimentosTable.$convertersecaoMercado.toJson(secaoMercado),
      ),
      'unidadeCompra': serializer.toJson<String>(
        $AlimentosTable.$converterunidadeCompra.toJson(unidadeCompra),
      ),
    };
  }

  Alimento copyWith({
    int? id,
    String? nome,
    Value<String?> tacoCodigo = const Value.absent(),
    double? kcal100g,
    double? carboidratoG,
    double? proteinaG,
    double? gorduraG,
    double? fibraG,
    double? sodioMg,
    SecaoMercado? secaoMercado,
    UnidadeCompra? unidadeCompra,
  }) => Alimento(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    tacoCodigo: tacoCodigo.present ? tacoCodigo.value : this.tacoCodigo,
    kcal100g: kcal100g ?? this.kcal100g,
    carboidratoG: carboidratoG ?? this.carboidratoG,
    proteinaG: proteinaG ?? this.proteinaG,
    gorduraG: gorduraG ?? this.gorduraG,
    fibraG: fibraG ?? this.fibraG,
    sodioMg: sodioMg ?? this.sodioMg,
    secaoMercado: secaoMercado ?? this.secaoMercado,
    unidadeCompra: unidadeCompra ?? this.unidadeCompra,
  );
  Alimento copyWithCompanion(AlimentosCompanion data) {
    return Alimento(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      tacoCodigo: data.tacoCodigo.present
          ? data.tacoCodigo.value
          : this.tacoCodigo,
      kcal100g: data.kcal100g.present ? data.kcal100g.value : this.kcal100g,
      carboidratoG: data.carboidratoG.present
          ? data.carboidratoG.value
          : this.carboidratoG,
      proteinaG: data.proteinaG.present ? data.proteinaG.value : this.proteinaG,
      gorduraG: data.gorduraG.present ? data.gorduraG.value : this.gorduraG,
      fibraG: data.fibraG.present ? data.fibraG.value : this.fibraG,
      sodioMg: data.sodioMg.present ? data.sodioMg.value : this.sodioMg,
      secaoMercado: data.secaoMercado.present
          ? data.secaoMercado.value
          : this.secaoMercado,
      unidadeCompra: data.unidadeCompra.present
          ? data.unidadeCompra.value
          : this.unidadeCompra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alimento(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('tacoCodigo: $tacoCodigo, ')
          ..write('kcal100g: $kcal100g, ')
          ..write('carboidratoG: $carboidratoG, ')
          ..write('proteinaG: $proteinaG, ')
          ..write('gorduraG: $gorduraG, ')
          ..write('fibraG: $fibraG, ')
          ..write('sodioMg: $sodioMg, ')
          ..write('secaoMercado: $secaoMercado, ')
          ..write('unidadeCompra: $unidadeCompra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    tacoCodigo,
    kcal100g,
    carboidratoG,
    proteinaG,
    gorduraG,
    fibraG,
    sodioMg,
    secaoMercado,
    unidadeCompra,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alimento &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.tacoCodigo == this.tacoCodigo &&
          other.kcal100g == this.kcal100g &&
          other.carboidratoG == this.carboidratoG &&
          other.proteinaG == this.proteinaG &&
          other.gorduraG == this.gorduraG &&
          other.fibraG == this.fibraG &&
          other.sodioMg == this.sodioMg &&
          other.secaoMercado == this.secaoMercado &&
          other.unidadeCompra == this.unidadeCompra);
}

class AlimentosCompanion extends UpdateCompanion<Alimento> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> tacoCodigo;
  final Value<double> kcal100g;
  final Value<double> carboidratoG;
  final Value<double> proteinaG;
  final Value<double> gorduraG;
  final Value<double> fibraG;
  final Value<double> sodioMg;
  final Value<SecaoMercado> secaoMercado;
  final Value<UnidadeCompra> unidadeCompra;
  const AlimentosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.tacoCodigo = const Value.absent(),
    this.kcal100g = const Value.absent(),
    this.carboidratoG = const Value.absent(),
    this.proteinaG = const Value.absent(),
    this.gorduraG = const Value.absent(),
    this.fibraG = const Value.absent(),
    this.sodioMg = const Value.absent(),
    this.secaoMercado = const Value.absent(),
    this.unidadeCompra = const Value.absent(),
  });
  AlimentosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.tacoCodigo = const Value.absent(),
    required double kcal100g,
    required double carboidratoG,
    required double proteinaG,
    required double gorduraG,
    required double fibraG,
    required double sodioMg,
    required SecaoMercado secaoMercado,
    required UnidadeCompra unidadeCompra,
  }) : nome = Value(nome),
       kcal100g = Value(kcal100g),
       carboidratoG = Value(carboidratoG),
       proteinaG = Value(proteinaG),
       gorduraG = Value(gorduraG),
       fibraG = Value(fibraG),
       sodioMg = Value(sodioMg),
       secaoMercado = Value(secaoMercado),
       unidadeCompra = Value(unidadeCompra);
  static Insertable<Alimento> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? tacoCodigo,
    Expression<double>? kcal100g,
    Expression<double>? carboidratoG,
    Expression<double>? proteinaG,
    Expression<double>? gorduraG,
    Expression<double>? fibraG,
    Expression<double>? sodioMg,
    Expression<String>? secaoMercado,
    Expression<String>? unidadeCompra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (tacoCodigo != null) 'taco_codigo': tacoCodigo,
      if (kcal100g != null) 'kcal100g': kcal100g,
      if (carboidratoG != null) 'carboidrato_g': carboidratoG,
      if (proteinaG != null) 'proteina_g': proteinaG,
      if (gorduraG != null) 'gordura_g': gorduraG,
      if (fibraG != null) 'fibra_g': fibraG,
      if (sodioMg != null) 'sodio_mg': sodioMg,
      if (secaoMercado != null) 'secao_mercado': secaoMercado,
      if (unidadeCompra != null) 'unidade_compra': unidadeCompra,
    });
  }

  AlimentosCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String?>? tacoCodigo,
    Value<double>? kcal100g,
    Value<double>? carboidratoG,
    Value<double>? proteinaG,
    Value<double>? gorduraG,
    Value<double>? fibraG,
    Value<double>? sodioMg,
    Value<SecaoMercado>? secaoMercado,
    Value<UnidadeCompra>? unidadeCompra,
  }) {
    return AlimentosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tacoCodigo: tacoCodigo ?? this.tacoCodigo,
      kcal100g: kcal100g ?? this.kcal100g,
      carboidratoG: carboidratoG ?? this.carboidratoG,
      proteinaG: proteinaG ?? this.proteinaG,
      gorduraG: gorduraG ?? this.gorduraG,
      fibraG: fibraG ?? this.fibraG,
      sodioMg: sodioMg ?? this.sodioMg,
      secaoMercado: secaoMercado ?? this.secaoMercado,
      unidadeCompra: unidadeCompra ?? this.unidadeCompra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (tacoCodigo.present) {
      map['taco_codigo'] = Variable<String>(tacoCodigo.value);
    }
    if (kcal100g.present) {
      map['kcal100g'] = Variable<double>(kcal100g.value);
    }
    if (carboidratoG.present) {
      map['carboidrato_g'] = Variable<double>(carboidratoG.value);
    }
    if (proteinaG.present) {
      map['proteina_g'] = Variable<double>(proteinaG.value);
    }
    if (gorduraG.present) {
      map['gordura_g'] = Variable<double>(gorduraG.value);
    }
    if (fibraG.present) {
      map['fibra_g'] = Variable<double>(fibraG.value);
    }
    if (sodioMg.present) {
      map['sodio_mg'] = Variable<double>(sodioMg.value);
    }
    if (secaoMercado.present) {
      map['secao_mercado'] = Variable<String>(
        $AlimentosTable.$convertersecaoMercado.toSql(secaoMercado.value),
      );
    }
    if (unidadeCompra.present) {
      map['unidade_compra'] = Variable<String>(
        $AlimentosTable.$converterunidadeCompra.toSql(unidadeCompra.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlimentosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('tacoCodigo: $tacoCodigo, ')
          ..write('kcal100g: $kcal100g, ')
          ..write('carboidratoG: $carboidratoG, ')
          ..write('proteinaG: $proteinaG, ')
          ..write('gorduraG: $gorduraG, ')
          ..write('fibraG: $fibraG, ')
          ..write('sodioMg: $sodioMg, ')
          ..write('secaoMercado: $secaoMercado, ')
          ..write('unidadeCompra: $unidadeCompra')
          ..write(')'))
        .toString();
  }
}

class $ConversoesTable extends Conversoes
    with TableInfo<$ConversoesTable, Conversao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _alimentoIdMeta = const VerificationMeta(
    'alimentoId',
  );
  @override
  late final GeneratedColumn<int> alimentoId = GeneratedColumn<int>(
    'alimento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alimentos (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Unidade, String> unidade =
      GeneratedColumn<String>(
        'unidade',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Unidade>($ConversoesTable.$converterunidade);
  static const VerificationMeta _gramasMeta = const VerificationMeta('gramas');
  @override
  late final GeneratedColumn<double> gramas = GeneratedColumn<double>(
    'gramas',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [alimentoId, unidade, gramas];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Conversao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('alimento_id')) {
      context.handle(
        _alimentoIdMeta,
        alimentoId.isAcceptableOrUnknown(data['alimento_id']!, _alimentoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alimentoIdMeta);
    }
    if (data.containsKey('gramas')) {
      context.handle(
        _gramasMeta,
        gramas.isAcceptableOrUnknown(data['gramas']!, _gramasMeta),
      );
    } else if (isInserting) {
      context.missing(_gramasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {alimentoId, unidade};
  @override
  Conversao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conversao(
      alimentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alimento_id'],
      )!,
      unidade: $ConversoesTable.$converterunidade.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unidade'],
        )!,
      ),
      gramas: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gramas'],
      )!,
    );
  }

  @override
  $ConversoesTable createAlias(String alias) {
    return $ConversoesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Unidade, String, String> $converterunidade =
      const EnumNameConverter<Unidade>(Unidade.values);
}

class Conversao extends DataClass implements Insertable<Conversao> {
  final int alimentoId;
  final Unidade unidade;
  final double gramas;
  const Conversao({
    required this.alimentoId,
    required this.unidade,
    required this.gramas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['alimento_id'] = Variable<int>(alimentoId);
    {
      map['unidade'] = Variable<String>(
        $ConversoesTable.$converterunidade.toSql(unidade),
      );
    }
    map['gramas'] = Variable<double>(gramas);
    return map;
  }

  ConversoesCompanion toCompanion(bool nullToAbsent) {
    return ConversoesCompanion(
      alimentoId: Value(alimentoId),
      unidade: Value(unidade),
      gramas: Value(gramas),
    );
  }

  factory Conversao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conversao(
      alimentoId: serializer.fromJson<int>(json['alimentoId']),
      unidade: $ConversoesTable.$converterunidade.fromJson(
        serializer.fromJson<String>(json['unidade']),
      ),
      gramas: serializer.fromJson<double>(json['gramas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'alimentoId': serializer.toJson<int>(alimentoId),
      'unidade': serializer.toJson<String>(
        $ConversoesTable.$converterunidade.toJson(unidade),
      ),
      'gramas': serializer.toJson<double>(gramas),
    };
  }

  Conversao copyWith({int? alimentoId, Unidade? unidade, double? gramas}) =>
      Conversao(
        alimentoId: alimentoId ?? this.alimentoId,
        unidade: unidade ?? this.unidade,
        gramas: gramas ?? this.gramas,
      );
  Conversao copyWithCompanion(ConversoesCompanion data) {
    return Conversao(
      alimentoId: data.alimentoId.present
          ? data.alimentoId.value
          : this.alimentoId,
      unidade: data.unidade.present ? data.unidade.value : this.unidade,
      gramas: data.gramas.present ? data.gramas.value : this.gramas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conversao(')
          ..write('alimentoId: $alimentoId, ')
          ..write('unidade: $unidade, ')
          ..write('gramas: $gramas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(alimentoId, unidade, gramas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conversao &&
          other.alimentoId == this.alimentoId &&
          other.unidade == this.unidade &&
          other.gramas == this.gramas);
}

class ConversoesCompanion extends UpdateCompanion<Conversao> {
  final Value<int> alimentoId;
  final Value<Unidade> unidade;
  final Value<double> gramas;
  final Value<int> rowid;
  const ConversoesCompanion({
    this.alimentoId = const Value.absent(),
    this.unidade = const Value.absent(),
    this.gramas = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversoesCompanion.insert({
    required int alimentoId,
    required Unidade unidade,
    required double gramas,
    this.rowid = const Value.absent(),
  }) : alimentoId = Value(alimentoId),
       unidade = Value(unidade),
       gramas = Value(gramas);
  static Insertable<Conversao> custom({
    Expression<int>? alimentoId,
    Expression<String>? unidade,
    Expression<double>? gramas,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (alimentoId != null) 'alimento_id': alimentoId,
      if (unidade != null) 'unidade': unidade,
      if (gramas != null) 'gramas': gramas,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversoesCompanion copyWith({
    Value<int>? alimentoId,
    Value<Unidade>? unidade,
    Value<double>? gramas,
    Value<int>? rowid,
  }) {
    return ConversoesCompanion(
      alimentoId: alimentoId ?? this.alimentoId,
      unidade: unidade ?? this.unidade,
      gramas: gramas ?? this.gramas,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (alimentoId.present) {
      map['alimento_id'] = Variable<int>(alimentoId.value);
    }
    if (unidade.present) {
      map['unidade'] = Variable<String>(
        $ConversoesTable.$converterunidade.toSql(unidade.value),
      );
    }
    if (gramas.present) {
      map['gramas'] = Variable<double>(gramas.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversoesCompanion(')
          ..write('alimentoId: $alimentoId, ')
          ..write('unidade: $unidade, ')
          ..write('gramas: $gramas, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceitasTable extends Receitas with TableInfo<$ReceitasTable, Receita> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceitasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoriaReceita, String>
  categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<CategoriaReceita>($ReceitasTable.$convertercategoria);
  static const VerificationMeta _rendimentoPorcoesMeta = const VerificationMeta(
    'rendimentoPorcoes',
  );
  @override
  late final GeneratedColumn<int> rendimentoPorcoes = GeneratedColumn<int>(
    'rendimento_porcoes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _tempoPreparoMinMeta = const VerificationMeta(
    'tempoPreparoMin',
  );
  @override
  late final GeneratedColumn<int> tempoPreparoMin = GeneratedColumn<int>(
    'tempo_preparo_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _modoPreparoMeta = const VerificationMeta(
    'modoPreparo',
  );
  @override
  late final GeneratedColumn<String> modoPreparo = GeneratedColumn<String>(
    'modo_preparo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fotoPathMeta = const VerificationMeta(
    'fotoPath',
  );
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
    'foto_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _origemMeta = const VerificationMeta('origem');
  @override
  late final GeneratedColumn<String> origem = GeneratedColumn<String>(
    'origem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('seed'),
  );
  static const VerificationMeta _ativaMeta = const VerificationMeta('ativa');
  @override
  late final GeneratedColumn<bool> ativa = GeneratedColumn<bool>(
    'ativa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativa" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    categoria,
    rendimentoPorcoes,
    tempoPreparoMin,
    modoPreparo,
    fotoPath,
    origem,
    ativa,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receitas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Receita> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('rendimento_porcoes')) {
      context.handle(
        _rendimentoPorcoesMeta,
        rendimentoPorcoes.isAcceptableOrUnknown(
          data['rendimento_porcoes']!,
          _rendimentoPorcoesMeta,
        ),
      );
    }
    if (data.containsKey('tempo_preparo_min')) {
      context.handle(
        _tempoPreparoMinMeta,
        tempoPreparoMin.isAcceptableOrUnknown(
          data['tempo_preparo_min']!,
          _tempoPreparoMinMeta,
        ),
      );
    }
    if (data.containsKey('modo_preparo')) {
      context.handle(
        _modoPreparoMeta,
        modoPreparo.isAcceptableOrUnknown(
          data['modo_preparo']!,
          _modoPreparoMeta,
        ),
      );
    }
    if (data.containsKey('foto_path')) {
      context.handle(
        _fotoPathMeta,
        fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta),
      );
    }
    if (data.containsKey('origem')) {
      context.handle(
        _origemMeta,
        origem.isAcceptableOrUnknown(data['origem']!, _origemMeta),
      );
    }
    if (data.containsKey('ativa')) {
      context.handle(
        _ativaMeta,
        ativa.isAcceptableOrUnknown(data['ativa']!, _ativaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receita map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receita(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      categoria: $ReceitasTable.$convertercategoria.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}categoria'],
        )!,
      ),
      rendimentoPorcoes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rendimento_porcoes'],
      )!,
      tempoPreparoMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tempo_preparo_min'],
      )!,
      modoPreparo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modo_preparo'],
      )!,
      fotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_path'],
      ),
      origem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origem'],
      )!,
      ativa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativa'],
      )!,
    );
  }

  @override
  $ReceitasTable createAlias(String alias) {
    return $ReceitasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoriaReceita, String, String>
  $convertercategoria = const EnumNameConverter<CategoriaReceita>(
    CategoriaReceita.values,
  );
}

class Receita extends DataClass implements Insertable<Receita> {
  final int id;
  final String nome;
  final CategoriaReceita categoria;
  final int rendimentoPorcoes;
  final int tempoPreparoMin;
  final String modoPreparo;
  final String? fotoPath;
  final String origem;
  final bool ativa;
  const Receita({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.rendimentoPorcoes,
    required this.tempoPreparoMin,
    required this.modoPreparo,
    this.fotoPath,
    required this.origem,
    required this.ativa,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    {
      map['categoria'] = Variable<String>(
        $ReceitasTable.$convertercategoria.toSql(categoria),
      );
    }
    map['rendimento_porcoes'] = Variable<int>(rendimentoPorcoes);
    map['tempo_preparo_min'] = Variable<int>(tempoPreparoMin);
    map['modo_preparo'] = Variable<String>(modoPreparo);
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    map['origem'] = Variable<String>(origem);
    map['ativa'] = Variable<bool>(ativa);
    return map;
  }

  ReceitasCompanion toCompanion(bool nullToAbsent) {
    return ReceitasCompanion(
      id: Value(id),
      nome: Value(nome),
      categoria: Value(categoria),
      rendimentoPorcoes: Value(rendimentoPorcoes),
      tempoPreparoMin: Value(tempoPreparoMin),
      modoPreparo: Value(modoPreparo),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      origem: Value(origem),
      ativa: Value(ativa),
    );
  }

  factory Receita.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receita(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      categoria: $ReceitasTable.$convertercategoria.fromJson(
        serializer.fromJson<String>(json['categoria']),
      ),
      rendimentoPorcoes: serializer.fromJson<int>(json['rendimentoPorcoes']),
      tempoPreparoMin: serializer.fromJson<int>(json['tempoPreparoMin']),
      modoPreparo: serializer.fromJson<String>(json['modoPreparo']),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      origem: serializer.fromJson<String>(json['origem']),
      ativa: serializer.fromJson<bool>(json['ativa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'categoria': serializer.toJson<String>(
        $ReceitasTable.$convertercategoria.toJson(categoria),
      ),
      'rendimentoPorcoes': serializer.toJson<int>(rendimentoPorcoes),
      'tempoPreparoMin': serializer.toJson<int>(tempoPreparoMin),
      'modoPreparo': serializer.toJson<String>(modoPreparo),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'origem': serializer.toJson<String>(origem),
      'ativa': serializer.toJson<bool>(ativa),
    };
  }

  Receita copyWith({
    int? id,
    String? nome,
    CategoriaReceita? categoria,
    int? rendimentoPorcoes,
    int? tempoPreparoMin,
    String? modoPreparo,
    Value<String?> fotoPath = const Value.absent(),
    String? origem,
    bool? ativa,
  }) => Receita(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    categoria: categoria ?? this.categoria,
    rendimentoPorcoes: rendimentoPorcoes ?? this.rendimentoPorcoes,
    tempoPreparoMin: tempoPreparoMin ?? this.tempoPreparoMin,
    modoPreparo: modoPreparo ?? this.modoPreparo,
    fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
    origem: origem ?? this.origem,
    ativa: ativa ?? this.ativa,
  );
  Receita copyWithCompanion(ReceitasCompanion data) {
    return Receita(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      rendimentoPorcoes: data.rendimentoPorcoes.present
          ? data.rendimentoPorcoes.value
          : this.rendimentoPorcoes,
      tempoPreparoMin: data.tempoPreparoMin.present
          ? data.tempoPreparoMin.value
          : this.tempoPreparoMin,
      modoPreparo: data.modoPreparo.present
          ? data.modoPreparo.value
          : this.modoPreparo,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      origem: data.origem.present ? data.origem.value : this.origem,
      ativa: data.ativa.present ? data.ativa.value : this.ativa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receita(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('rendimentoPorcoes: $rendimentoPorcoes, ')
          ..write('tempoPreparoMin: $tempoPreparoMin, ')
          ..write('modoPreparo: $modoPreparo, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('origem: $origem, ')
          ..write('ativa: $ativa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    categoria,
    rendimentoPorcoes,
    tempoPreparoMin,
    modoPreparo,
    fotoPath,
    origem,
    ativa,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receita &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.categoria == this.categoria &&
          other.rendimentoPorcoes == this.rendimentoPorcoes &&
          other.tempoPreparoMin == this.tempoPreparoMin &&
          other.modoPreparo == this.modoPreparo &&
          other.fotoPath == this.fotoPath &&
          other.origem == this.origem &&
          other.ativa == this.ativa);
}

class ReceitasCompanion extends UpdateCompanion<Receita> {
  final Value<int> id;
  final Value<String> nome;
  final Value<CategoriaReceita> categoria;
  final Value<int> rendimentoPorcoes;
  final Value<int> tempoPreparoMin;
  final Value<String> modoPreparo;
  final Value<String?> fotoPath;
  final Value<String> origem;
  final Value<bool> ativa;
  const ReceitasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoria = const Value.absent(),
    this.rendimentoPorcoes = const Value.absent(),
    this.tempoPreparoMin = const Value.absent(),
    this.modoPreparo = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.origem = const Value.absent(),
    this.ativa = const Value.absent(),
  });
  ReceitasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required CategoriaReceita categoria,
    this.rendimentoPorcoes = const Value.absent(),
    this.tempoPreparoMin = const Value.absent(),
    this.modoPreparo = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.origem = const Value.absent(),
    this.ativa = const Value.absent(),
  }) : nome = Value(nome),
       categoria = Value(categoria);
  static Insertable<Receita> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? categoria,
    Expression<int>? rendimentoPorcoes,
    Expression<int>? tempoPreparoMin,
    Expression<String>? modoPreparo,
    Expression<String>? fotoPath,
    Expression<String>? origem,
    Expression<bool>? ativa,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (categoria != null) 'categoria': categoria,
      if (rendimentoPorcoes != null) 'rendimento_porcoes': rendimentoPorcoes,
      if (tempoPreparoMin != null) 'tempo_preparo_min': tempoPreparoMin,
      if (modoPreparo != null) 'modo_preparo': modoPreparo,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (origem != null) 'origem': origem,
      if (ativa != null) 'ativa': ativa,
    });
  }

  ReceitasCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<CategoriaReceita>? categoria,
    Value<int>? rendimentoPorcoes,
    Value<int>? tempoPreparoMin,
    Value<String>? modoPreparo,
    Value<String?>? fotoPath,
    Value<String>? origem,
    Value<bool>? ativa,
  }) {
    return ReceitasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      rendimentoPorcoes: rendimentoPorcoes ?? this.rendimentoPorcoes,
      tempoPreparoMin: tempoPreparoMin ?? this.tempoPreparoMin,
      modoPreparo: modoPreparo ?? this.modoPreparo,
      fotoPath: fotoPath ?? this.fotoPath,
      origem: origem ?? this.origem,
      ativa: ativa ?? this.ativa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(
        $ReceitasTable.$convertercategoria.toSql(categoria.value),
      );
    }
    if (rendimentoPorcoes.present) {
      map['rendimento_porcoes'] = Variable<int>(rendimentoPorcoes.value);
    }
    if (tempoPreparoMin.present) {
      map['tempo_preparo_min'] = Variable<int>(tempoPreparoMin.value);
    }
    if (modoPreparo.present) {
      map['modo_preparo'] = Variable<String>(modoPreparo.value);
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (origem.present) {
      map['origem'] = Variable<String>(origem.value);
    }
    if (ativa.present) {
      map['ativa'] = Variable<bool>(ativa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceitasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('rendimentoPorcoes: $rendimentoPorcoes, ')
          ..write('tempoPreparoMin: $tempoPreparoMin, ')
          ..write('modoPreparo: $modoPreparo, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('origem: $origem, ')
          ..write('ativa: $ativa')
          ..write(')'))
        .toString();
  }
}

class $ReceitaIngredientesTable extends ReceitaIngredientes
    with TableInfo<$ReceitaIngredientesTable, ReceitaIngrediente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceitaIngredientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _receitaIdMeta = const VerificationMeta(
    'receitaId',
  );
  @override
  late final GeneratedColumn<int> receitaId = GeneratedColumn<int>(
    'receita_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES receitas (id)',
    ),
  );
  static const VerificationMeta _alimentoIdMeta = const VerificationMeta(
    'alimentoId',
  );
  @override
  late final GeneratedColumn<int> alimentoId = GeneratedColumn<int>(
    'alimento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alimentos (id)',
    ),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantidadeMeta = const VerificationMeta(
    'quantidade',
  );
  @override
  late final GeneratedColumn<double> quantidade = GeneratedColumn<double>(
    'quantidade',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Unidade, String> unidade =
      GeneratedColumn<String>(
        'unidade',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Unidade>($ReceitaIngredientesTable.$converterunidade);
  static const VerificationMeta _observacaoMeta = const VerificationMeta(
    'observacao',
  );
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
    'observacao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receitaId,
    alimentoId,
    ordem,
    quantidade,
    unidade,
    observacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receita_ingredientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReceitaIngrediente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receita_id')) {
      context.handle(
        _receitaIdMeta,
        receitaId.isAcceptableOrUnknown(data['receita_id']!, _receitaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_receitaIdMeta);
    }
    if (data.containsKey('alimento_id')) {
      context.handle(
        _alimentoIdMeta,
        alimentoId.isAcceptableOrUnknown(data['alimento_id']!, _alimentoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alimentoIdMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    if (data.containsKey('quantidade')) {
      context.handle(
        _quantidadeMeta,
        quantidade.isAcceptableOrUnknown(data['quantidade']!, _quantidadeMeta),
      );
    } else if (isInserting) {
      context.missing(_quantidadeMeta);
    }
    if (data.containsKey('observacao')) {
      context.handle(
        _observacaoMeta,
        observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceitaIngrediente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceitaIngrediente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      receitaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receita_id'],
      )!,
      alimentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alimento_id'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
      quantidade: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantidade'],
      )!,
      unidade: $ReceitaIngredientesTable.$converterunidade.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unidade'],
        )!,
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
    );
  }

  @override
  $ReceitaIngredientesTable createAlias(String alias) {
    return $ReceitaIngredientesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Unidade, String, String> $converterunidade =
      const EnumNameConverter<Unidade>(Unidade.values);
}

class ReceitaIngrediente extends DataClass
    implements Insertable<ReceitaIngrediente> {
  final int id;
  final int receitaId;
  final int alimentoId;
  final int ordem;
  final double quantidade;
  final Unidade unidade;
  final String? observacao;
  const ReceitaIngrediente({
    required this.id,
    required this.receitaId,
    required this.alimentoId,
    required this.ordem,
    required this.quantidade,
    required this.unidade,
    this.observacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receita_id'] = Variable<int>(receitaId);
    map['alimento_id'] = Variable<int>(alimentoId);
    map['ordem'] = Variable<int>(ordem);
    map['quantidade'] = Variable<double>(quantidade);
    {
      map['unidade'] = Variable<String>(
        $ReceitaIngredientesTable.$converterunidade.toSql(unidade),
      );
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    return map;
  }

  ReceitaIngredientesCompanion toCompanion(bool nullToAbsent) {
    return ReceitaIngredientesCompanion(
      id: Value(id),
      receitaId: Value(receitaId),
      alimentoId: Value(alimentoId),
      ordem: Value(ordem),
      quantidade: Value(quantidade),
      unidade: Value(unidade),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
    );
  }

  factory ReceitaIngrediente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceitaIngrediente(
      id: serializer.fromJson<int>(json['id']),
      receitaId: serializer.fromJson<int>(json['receitaId']),
      alimentoId: serializer.fromJson<int>(json['alimentoId']),
      ordem: serializer.fromJson<int>(json['ordem']),
      quantidade: serializer.fromJson<double>(json['quantidade']),
      unidade: $ReceitaIngredientesTable.$converterunidade.fromJson(
        serializer.fromJson<String>(json['unidade']),
      ),
      observacao: serializer.fromJson<String?>(json['observacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receitaId': serializer.toJson<int>(receitaId),
      'alimentoId': serializer.toJson<int>(alimentoId),
      'ordem': serializer.toJson<int>(ordem),
      'quantidade': serializer.toJson<double>(quantidade),
      'unidade': serializer.toJson<String>(
        $ReceitaIngredientesTable.$converterunidade.toJson(unidade),
      ),
      'observacao': serializer.toJson<String?>(observacao),
    };
  }

  ReceitaIngrediente copyWith({
    int? id,
    int? receitaId,
    int? alimentoId,
    int? ordem,
    double? quantidade,
    Unidade? unidade,
    Value<String?> observacao = const Value.absent(),
  }) => ReceitaIngrediente(
    id: id ?? this.id,
    receitaId: receitaId ?? this.receitaId,
    alimentoId: alimentoId ?? this.alimentoId,
    ordem: ordem ?? this.ordem,
    quantidade: quantidade ?? this.quantidade,
    unidade: unidade ?? this.unidade,
    observacao: observacao.present ? observacao.value : this.observacao,
  );
  ReceitaIngrediente copyWithCompanion(ReceitaIngredientesCompanion data) {
    return ReceitaIngrediente(
      id: data.id.present ? data.id.value : this.id,
      receitaId: data.receitaId.present ? data.receitaId.value : this.receitaId,
      alimentoId: data.alimentoId.present
          ? data.alimentoId.value
          : this.alimentoId,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
      quantidade: data.quantidade.present
          ? data.quantidade.value
          : this.quantidade,
      unidade: data.unidade.present ? data.unidade.value : this.unidade,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceitaIngrediente(')
          ..write('id: $id, ')
          ..write('receitaId: $receitaId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('ordem: $ordem, ')
          ..write('quantidade: $quantidade, ')
          ..write('unidade: $unidade, ')
          ..write('observacao: $observacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receitaId,
    alimentoId,
    ordem,
    quantidade,
    unidade,
    observacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceitaIngrediente &&
          other.id == this.id &&
          other.receitaId == this.receitaId &&
          other.alimentoId == this.alimentoId &&
          other.ordem == this.ordem &&
          other.quantidade == this.quantidade &&
          other.unidade == this.unidade &&
          other.observacao == this.observacao);
}

class ReceitaIngredientesCompanion extends UpdateCompanion<ReceitaIngrediente> {
  final Value<int> id;
  final Value<int> receitaId;
  final Value<int> alimentoId;
  final Value<int> ordem;
  final Value<double> quantidade;
  final Value<Unidade> unidade;
  final Value<String?> observacao;
  const ReceitaIngredientesCompanion({
    this.id = const Value.absent(),
    this.receitaId = const Value.absent(),
    this.alimentoId = const Value.absent(),
    this.ordem = const Value.absent(),
    this.quantidade = const Value.absent(),
    this.unidade = const Value.absent(),
    this.observacao = const Value.absent(),
  });
  ReceitaIngredientesCompanion.insert({
    this.id = const Value.absent(),
    required int receitaId,
    required int alimentoId,
    required int ordem,
    required double quantidade,
    required Unidade unidade,
    this.observacao = const Value.absent(),
  }) : receitaId = Value(receitaId),
       alimentoId = Value(alimentoId),
       ordem = Value(ordem),
       quantidade = Value(quantidade),
       unidade = Value(unidade);
  static Insertable<ReceitaIngrediente> custom({
    Expression<int>? id,
    Expression<int>? receitaId,
    Expression<int>? alimentoId,
    Expression<int>? ordem,
    Expression<double>? quantidade,
    Expression<String>? unidade,
    Expression<String>? observacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receitaId != null) 'receita_id': receitaId,
      if (alimentoId != null) 'alimento_id': alimentoId,
      if (ordem != null) 'ordem': ordem,
      if (quantidade != null) 'quantidade': quantidade,
      if (unidade != null) 'unidade': unidade,
      if (observacao != null) 'observacao': observacao,
    });
  }

  ReceitaIngredientesCompanion copyWith({
    Value<int>? id,
    Value<int>? receitaId,
    Value<int>? alimentoId,
    Value<int>? ordem,
    Value<double>? quantidade,
    Value<Unidade>? unidade,
    Value<String?>? observacao,
  }) {
    return ReceitaIngredientesCompanion(
      id: id ?? this.id,
      receitaId: receitaId ?? this.receitaId,
      alimentoId: alimentoId ?? this.alimentoId,
      ordem: ordem ?? this.ordem,
      quantidade: quantidade ?? this.quantidade,
      unidade: unidade ?? this.unidade,
      observacao: observacao ?? this.observacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receitaId.present) {
      map['receita_id'] = Variable<int>(receitaId.value);
    }
    if (alimentoId.present) {
      map['alimento_id'] = Variable<int>(alimentoId.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (quantidade.present) {
      map['quantidade'] = Variable<double>(quantidade.value);
    }
    if (unidade.present) {
      map['unidade'] = Variable<String>(
        $ReceitaIngredientesTable.$converterunidade.toSql(unidade.value),
      );
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceitaIngredientesCompanion(')
          ..write('id: $id, ')
          ..write('receitaId: $receitaId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('ordem: $ordem, ')
          ..write('quantidade: $quantidade, ')
          ..write('unidade: $unidade, ')
          ..write('observacao: $observacao')
          ..write(')'))
        .toString();
  }
}

class $CombosTable extends Combos with TableInfo<$CombosTable, Combo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CombosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoCombo, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoCombo>($CombosTable.$convertertipo);
  static const VerificationMeta _fotoPathMeta = const VerificationMeta(
    'fotoPath',
  );
  @override
  late final GeneratedColumn<String> fotoPath = GeneratedColumn<String>(
    'foto_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _origemMeta = const VerificationMeta('origem');
  @override
  late final GeneratedColumn<String> origem = GeneratedColumn<String>(
    'origem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('seed'),
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    tipo,
    fotoPath,
    origem,
    ativo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'combos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Combo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('foto_path')) {
      context.handle(
        _fotoPathMeta,
        fotoPath.isAcceptableOrUnknown(data['foto_path']!, _fotoPathMeta),
      );
    }
    if (data.containsKey('origem')) {
      context.handle(
        _origemMeta,
        origem.isAcceptableOrUnknown(data['origem']!, _origemMeta),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Combo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Combo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      tipo: $CombosTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      fotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_path'],
      ),
      origem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origem'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
    );
  }

  @override
  $CombosTable createAlias(String alias) {
    return $CombosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoCombo, String, String> $convertertipo =
      const EnumNameConverter<TipoCombo>(TipoCombo.values);
}

class Combo extends DataClass implements Insertable<Combo> {
  final int id;
  final String nome;
  final TipoCombo tipo;

  /// Asset com a foto do prato montado. A foto e do combo inteiro (o prato
  /// como ela ve na mesa), nao de uma receita solta: uma receita como "Arroz
  /// branco" nao tem foto propria e nunca tera. Nulo quando nao ha foto —
  /// combo que ela criar, por exemplo.
  final String? fotoPath;
  final String origem;
  final bool ativo;
  const Combo({
    required this.id,
    required this.nome,
    required this.tipo,
    this.fotoPath,
    required this.origem,
    required this.ativo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    {
      map['tipo'] = Variable<String>($CombosTable.$convertertipo.toSql(tipo));
    }
    if (!nullToAbsent || fotoPath != null) {
      map['foto_path'] = Variable<String>(fotoPath);
    }
    map['origem'] = Variable<String>(origem);
    map['ativo'] = Variable<bool>(ativo);
    return map;
  }

  CombosCompanion toCompanion(bool nullToAbsent) {
    return CombosCompanion(
      id: Value(id),
      nome: Value(nome),
      tipo: Value(tipo),
      fotoPath: fotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPath),
      origem: Value(origem),
      ativo: Value(ativo),
    );
  }

  factory Combo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Combo(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      tipo: $CombosTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      fotoPath: serializer.fromJson<String?>(json['fotoPath']),
      origem: serializer.fromJson<String>(json['origem']),
      ativo: serializer.fromJson<bool>(json['ativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'tipo': serializer.toJson<String>(
        $CombosTable.$convertertipo.toJson(tipo),
      ),
      'fotoPath': serializer.toJson<String?>(fotoPath),
      'origem': serializer.toJson<String>(origem),
      'ativo': serializer.toJson<bool>(ativo),
    };
  }

  Combo copyWith({
    int? id,
    String? nome,
    TipoCombo? tipo,
    Value<String?> fotoPath = const Value.absent(),
    String? origem,
    bool? ativo,
  }) => Combo(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    tipo: tipo ?? this.tipo,
    fotoPath: fotoPath.present ? fotoPath.value : this.fotoPath,
    origem: origem ?? this.origem,
    ativo: ativo ?? this.ativo,
  );
  Combo copyWithCompanion(CombosCompanion data) {
    return Combo(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      fotoPath: data.fotoPath.present ? data.fotoPath.value : this.fotoPath,
      origem: data.origem.present ? data.origem.value : this.origem,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Combo(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('tipo: $tipo, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('origem: $origem, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, tipo, fotoPath, origem, ativo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Combo &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.tipo == this.tipo &&
          other.fotoPath == this.fotoPath &&
          other.origem == this.origem &&
          other.ativo == this.ativo);
}

class CombosCompanion extends UpdateCompanion<Combo> {
  final Value<int> id;
  final Value<String> nome;
  final Value<TipoCombo> tipo;
  final Value<String?> fotoPath;
  final Value<String> origem;
  final Value<bool> ativo;
  const CombosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.tipo = const Value.absent(),
    this.fotoPath = const Value.absent(),
    this.origem = const Value.absent(),
    this.ativo = const Value.absent(),
  });
  CombosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required TipoCombo tipo,
    this.fotoPath = const Value.absent(),
    this.origem = const Value.absent(),
    this.ativo = const Value.absent(),
  }) : nome = Value(nome),
       tipo = Value(tipo);
  static Insertable<Combo> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? tipo,
    Expression<String>? fotoPath,
    Expression<String>? origem,
    Expression<bool>? ativo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (tipo != null) 'tipo': tipo,
      if (fotoPath != null) 'foto_path': fotoPath,
      if (origem != null) 'origem': origem,
      if (ativo != null) 'ativo': ativo,
    });
  }

  CombosCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<TipoCombo>? tipo,
    Value<String?>? fotoPath,
    Value<String>? origem,
    Value<bool>? ativo,
  }) {
    return CombosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      fotoPath: fotoPath ?? this.fotoPath,
      origem: origem ?? this.origem,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $CombosTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (fotoPath.present) {
      map['foto_path'] = Variable<String>(fotoPath.value);
    }
    if (origem.present) {
      map['origem'] = Variable<String>(origem.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CombosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('tipo: $tipo, ')
          ..write('fotoPath: $fotoPath, ')
          ..write('origem: $origem, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }
}

class $ComboReceitasTable extends ComboReceitas
    with TableInfo<$ComboReceitasTable, ComboReceita> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComboReceitasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _comboIdMeta = const VerificationMeta(
    'comboId',
  );
  @override
  late final GeneratedColumn<int> comboId = GeneratedColumn<int>(
    'combo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES combos (id)',
    ),
  );
  static const VerificationMeta _receitaIdMeta = const VerificationMeta(
    'receitaId',
  );
  @override
  late final GeneratedColumn<int> receitaId = GeneratedColumn<int>(
    'receita_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES receitas (id)',
    ),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [comboId, receitaId, ordem];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'combo_receitas';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComboReceita> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('combo_id')) {
      context.handle(
        _comboIdMeta,
        comboId.isAcceptableOrUnknown(data['combo_id']!, _comboIdMeta),
      );
    } else if (isInserting) {
      context.missing(_comboIdMeta);
    }
    if (data.containsKey('receita_id')) {
      context.handle(
        _receitaIdMeta,
        receitaId.isAcceptableOrUnknown(data['receita_id']!, _receitaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_receitaIdMeta);
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {comboId, receitaId};
  @override
  ComboReceita map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComboReceita(
      comboId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}combo_id'],
      )!,
      receitaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receita_id'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $ComboReceitasTable createAlias(String alias) {
    return $ComboReceitasTable(attachedDatabase, alias);
  }
}

class ComboReceita extends DataClass implements Insertable<ComboReceita> {
  final int comboId;
  final int receitaId;
  final int ordem;
  const ComboReceita({
    required this.comboId,
    required this.receitaId,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['combo_id'] = Variable<int>(comboId);
    map['receita_id'] = Variable<int>(receitaId);
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  ComboReceitasCompanion toCompanion(bool nullToAbsent) {
    return ComboReceitasCompanion(
      comboId: Value(comboId),
      receitaId: Value(receitaId),
      ordem: Value(ordem),
    );
  }

  factory ComboReceita.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComboReceita(
      comboId: serializer.fromJson<int>(json['comboId']),
      receitaId: serializer.fromJson<int>(json['receitaId']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'comboId': serializer.toJson<int>(comboId),
      'receitaId': serializer.toJson<int>(receitaId),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  ComboReceita copyWith({int? comboId, int? receitaId, int? ordem}) =>
      ComboReceita(
        comboId: comboId ?? this.comboId,
        receitaId: receitaId ?? this.receitaId,
        ordem: ordem ?? this.ordem,
      );
  ComboReceita copyWithCompanion(ComboReceitasCompanion data) {
    return ComboReceita(
      comboId: data.comboId.present ? data.comboId.value : this.comboId,
      receitaId: data.receitaId.present ? data.receitaId.value : this.receitaId,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComboReceita(')
          ..write('comboId: $comboId, ')
          ..write('receitaId: $receitaId, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(comboId, receitaId, ordem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComboReceita &&
          other.comboId == this.comboId &&
          other.receitaId == this.receitaId &&
          other.ordem == this.ordem);
}

class ComboReceitasCompanion extends UpdateCompanion<ComboReceita> {
  final Value<int> comboId;
  final Value<int> receitaId;
  final Value<int> ordem;
  final Value<int> rowid;
  const ComboReceitasCompanion({
    this.comboId = const Value.absent(),
    this.receitaId = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComboReceitasCompanion.insert({
    required int comboId,
    required int receitaId,
    required int ordem,
    this.rowid = const Value.absent(),
  }) : comboId = Value(comboId),
       receitaId = Value(receitaId),
       ordem = Value(ordem);
  static Insertable<ComboReceita> custom({
    Expression<int>? comboId,
    Expression<int>? receitaId,
    Expression<int>? ordem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (comboId != null) 'combo_id': comboId,
      if (receitaId != null) 'receita_id': receitaId,
      if (ordem != null) 'ordem': ordem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComboReceitasCompanion copyWith({
    Value<int>? comboId,
    Value<int>? receitaId,
    Value<int>? ordem,
    Value<int>? rowid,
  }) {
    return ComboReceitasCompanion(
      comboId: comboId ?? this.comboId,
      receitaId: receitaId ?? this.receitaId,
      ordem: ordem ?? this.ordem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (comboId.present) {
      map['combo_id'] = Variable<int>(comboId.value);
    }
    if (receitaId.present) {
      map['receita_id'] = Variable<int>(receitaId.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComboReceitasCompanion(')
          ..write('comboId: $comboId, ')
          ..write('receitaId: $receitaId, ')
          ..write('ordem: $ordem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CicloItensTable extends CicloItens
    with TableInfo<$CicloItensTable, CicloItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CicloItensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _posicaoMeta = const VerificationMeta(
    'posicao',
  );
  @override
  late final GeneratedColumn<int> posicao = GeneratedColumn<int>(
    'posicao',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoCombo, String> tipoSlot =
      GeneratedColumn<String>(
        'tipo_slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoCombo>($CicloItensTable.$convertertipoSlot);
  static const VerificationMeta _comboIdMeta = const VerificationMeta(
    'comboId',
  );
  @override
  late final GeneratedColumn<int> comboId = GeneratedColumn<int>(
    'combo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES combos (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [posicao, tipoSlot, comboId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ciclo_itens';
  @override
  VerificationContext validateIntegrity(
    Insertable<CicloItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('posicao')) {
      context.handle(
        _posicaoMeta,
        posicao.isAcceptableOrUnknown(data['posicao']!, _posicaoMeta),
      );
    } else if (isInserting) {
      context.missing(_posicaoMeta);
    }
    if (data.containsKey('combo_id')) {
      context.handle(
        _comboIdMeta,
        comboId.isAcceptableOrUnknown(data['combo_id']!, _comboIdMeta),
      );
    } else if (isInserting) {
      context.missing(_comboIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {posicao, tipoSlot};
  @override
  CicloItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CicloItem(
      posicao: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posicao'],
      )!,
      tipoSlot: $CicloItensTable.$convertertipoSlot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo_slot'],
        )!,
      ),
      comboId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}combo_id'],
      )!,
    );
  }

  @override
  $CicloItensTable createAlias(String alias) {
    return $CicloItensTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoCombo, String, String> $convertertipoSlot =
      const EnumNameConverter<TipoCombo>(TipoCombo.values);
}

class CicloItem extends DataClass implements Insertable<CicloItem> {
  final int posicao;
  final TipoCombo tipoSlot;
  final int comboId;
  const CicloItem({
    required this.posicao,
    required this.tipoSlot,
    required this.comboId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['posicao'] = Variable<int>(posicao);
    {
      map['tipo_slot'] = Variable<String>(
        $CicloItensTable.$convertertipoSlot.toSql(tipoSlot),
      );
    }
    map['combo_id'] = Variable<int>(comboId);
    return map;
  }

  CicloItensCompanion toCompanion(bool nullToAbsent) {
    return CicloItensCompanion(
      posicao: Value(posicao),
      tipoSlot: Value(tipoSlot),
      comboId: Value(comboId),
    );
  }

  factory CicloItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CicloItem(
      posicao: serializer.fromJson<int>(json['posicao']),
      tipoSlot: $CicloItensTable.$convertertipoSlot.fromJson(
        serializer.fromJson<String>(json['tipoSlot']),
      ),
      comboId: serializer.fromJson<int>(json['comboId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'posicao': serializer.toJson<int>(posicao),
      'tipoSlot': serializer.toJson<String>(
        $CicloItensTable.$convertertipoSlot.toJson(tipoSlot),
      ),
      'comboId': serializer.toJson<int>(comboId),
    };
  }

  CicloItem copyWith({int? posicao, TipoCombo? tipoSlot, int? comboId}) =>
      CicloItem(
        posicao: posicao ?? this.posicao,
        tipoSlot: tipoSlot ?? this.tipoSlot,
        comboId: comboId ?? this.comboId,
      );
  CicloItem copyWithCompanion(CicloItensCompanion data) {
    return CicloItem(
      posicao: data.posicao.present ? data.posicao.value : this.posicao,
      tipoSlot: data.tipoSlot.present ? data.tipoSlot.value : this.tipoSlot,
      comboId: data.comboId.present ? data.comboId.value : this.comboId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CicloItem(')
          ..write('posicao: $posicao, ')
          ..write('tipoSlot: $tipoSlot, ')
          ..write('comboId: $comboId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(posicao, tipoSlot, comboId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CicloItem &&
          other.posicao == this.posicao &&
          other.tipoSlot == this.tipoSlot &&
          other.comboId == this.comboId);
}

class CicloItensCompanion extends UpdateCompanion<CicloItem> {
  final Value<int> posicao;
  final Value<TipoCombo> tipoSlot;
  final Value<int> comboId;
  final Value<int> rowid;
  const CicloItensCompanion({
    this.posicao = const Value.absent(),
    this.tipoSlot = const Value.absent(),
    this.comboId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CicloItensCompanion.insert({
    required int posicao,
    required TipoCombo tipoSlot,
    required int comboId,
    this.rowid = const Value.absent(),
  }) : posicao = Value(posicao),
       tipoSlot = Value(tipoSlot),
       comboId = Value(comboId);
  static Insertable<CicloItem> custom({
    Expression<int>? posicao,
    Expression<String>? tipoSlot,
    Expression<int>? comboId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (posicao != null) 'posicao': posicao,
      if (tipoSlot != null) 'tipo_slot': tipoSlot,
      if (comboId != null) 'combo_id': comboId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CicloItensCompanion copyWith({
    Value<int>? posicao,
    Value<TipoCombo>? tipoSlot,
    Value<int>? comboId,
    Value<int>? rowid,
  }) {
    return CicloItensCompanion(
      posicao: posicao ?? this.posicao,
      tipoSlot: tipoSlot ?? this.tipoSlot,
      comboId: comboId ?? this.comboId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (posicao.present) {
      map['posicao'] = Variable<int>(posicao.value);
    }
    if (tipoSlot.present) {
      map['tipo_slot'] = Variable<String>(
        $CicloItensTable.$convertertipoSlot.toSql(tipoSlot.value),
      );
    }
    if (comboId.present) {
      map['combo_id'] = Variable<int>(comboId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CicloItensCompanion(')
          ..write('posicao: $posicao, ')
          ..write('tipoSlot: $tipoSlot, ')
          ..write('comboId: $comboId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConfigTable extends Config with TableInfo<$ConfigTable, ConfigLinha> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chaveMeta = const VerificationMeta('chave');
  @override
  late final GeneratedColumn<String> chave = GeneratedColumn<String>(
    'chave',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [chave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'config';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfigLinha> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chave')) {
      context.handle(
        _chaveMeta,
        chave.isAcceptableOrUnknown(data['chave']!, _chaveMeta),
      );
    } else if (isInserting) {
      context.missing(_chaveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chave};
  @override
  ConfigLinha map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigLinha(
      chave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
    );
  }

  @override
  $ConfigTable createAlias(String alias) {
    return $ConfigTable(attachedDatabase, alias);
  }
}

class ConfigLinha extends DataClass implements Insertable<ConfigLinha> {
  final String chave;
  final String valor;
  const ConfigLinha({required this.chave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chave'] = Variable<String>(chave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  ConfigCompanion toCompanion(bool nullToAbsent) {
    return ConfigCompanion(chave: Value(chave), valor: Value(valor));
  }

  factory ConfigLinha.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigLinha(
      chave: serializer.fromJson<String>(json['chave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chave': serializer.toJson<String>(chave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  ConfigLinha copyWith({String? chave, String? valor}) =>
      ConfigLinha(chave: chave ?? this.chave, valor: valor ?? this.valor);
  ConfigLinha copyWithCompanion(ConfigCompanion data) {
    return ConfigLinha(
      chave: data.chave.present ? data.chave.value : this.chave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfigLinha(')
          ..write('chave: $chave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigLinha &&
          other.chave == this.chave &&
          other.valor == this.valor);
}

class ConfigCompanion extends UpdateCompanion<ConfigLinha> {
  final Value<String> chave;
  final Value<String> valor;
  final Value<int> rowid;
  const ConfigCompanion({
    this.chave = const Value.absent(),
    this.valor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConfigCompanion.insert({
    required String chave,
    required String valor,
    this.rowid = const Value.absent(),
  }) : chave = Value(chave),
       valor = Value(valor);
  static Insertable<ConfigLinha> custom({
    Expression<String>? chave,
    Expression<String>? valor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chave != null) 'chave': chave,
      if (valor != null) 'valor': valor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConfigCompanion copyWith({
    Value<String>? chave,
    Value<String>? valor,
    Value<int>? rowid,
  }) {
    return ConfigCompanion(
      chave: chave ?? this.chave,
      valor: valor ?? this.valor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chave.present) {
      map['chave'] = Variable<String>(chave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigCompanion(')
          ..write('chave: $chave, ')
          ..write('valor: $valor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegrasPorcaoTable extends RegrasPorcao
    with TableInfo<$RegrasPorcaoTable, RegraPorcao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegrasPorcaoTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<SlotRefeicao, String> slot =
      GeneratedColumn<String>(
        'slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SlotRefeicao>($RegrasPorcaoTable.$converterslot);
  static const VerificationMeta _diaUtilMeta = const VerificationMeta(
    'diaUtil',
  );
  @override
  late final GeneratedColumn<bool> diaUtil = GeneratedColumn<bool>(
    'dia_util',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dia_util" IN (0, 1))',
    ),
  );
  static const VerificationMeta _porcoesMeta = const VerificationMeta(
    'porcoes',
  );
  @override
  late final GeneratedColumn<int> porcoes = GeneratedColumn<int>(
    'porcoes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [slot, diaUtil, porcoes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'regras_porcao';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegraPorcao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dia_util')) {
      context.handle(
        _diaUtilMeta,
        diaUtil.isAcceptableOrUnknown(data['dia_util']!, _diaUtilMeta),
      );
    } else if (isInserting) {
      context.missing(_diaUtilMeta);
    }
    if (data.containsKey('porcoes')) {
      context.handle(
        _porcoesMeta,
        porcoes.isAcceptableOrUnknown(data['porcoes']!, _porcoesMeta),
      );
    } else if (isInserting) {
      context.missing(_porcoesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slot, diaUtil};
  @override
  RegraPorcao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegraPorcao(
      slot: $RegrasPorcaoTable.$converterslot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}slot'],
        )!,
      ),
      diaUtil: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dia_util'],
      )!,
      porcoes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}porcoes'],
      )!,
    );
  }

  @override
  $RegrasPorcaoTable createAlias(String alias) {
    return $RegrasPorcaoTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SlotRefeicao, String, String> $converterslot =
      const EnumNameConverter<SlotRefeicao>(SlotRefeicao.values);
}

class RegraPorcao extends DataClass implements Insertable<RegraPorcao> {
  final SlotRefeicao slot;
  final bool diaUtil;
  final int porcoes;
  const RegraPorcao({
    required this.slot,
    required this.diaUtil,
    required this.porcoes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['slot'] = Variable<String>(
        $RegrasPorcaoTable.$converterslot.toSql(slot),
      );
    }
    map['dia_util'] = Variable<bool>(diaUtil);
    map['porcoes'] = Variable<int>(porcoes);
    return map;
  }

  RegrasPorcaoCompanion toCompanion(bool nullToAbsent) {
    return RegrasPorcaoCompanion(
      slot: Value(slot),
      diaUtil: Value(diaUtil),
      porcoes: Value(porcoes),
    );
  }

  factory RegraPorcao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegraPorcao(
      slot: $RegrasPorcaoTable.$converterslot.fromJson(
        serializer.fromJson<String>(json['slot']),
      ),
      diaUtil: serializer.fromJson<bool>(json['diaUtil']),
      porcoes: serializer.fromJson<int>(json['porcoes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<String>(
        $RegrasPorcaoTable.$converterslot.toJson(slot),
      ),
      'diaUtil': serializer.toJson<bool>(diaUtil),
      'porcoes': serializer.toJson<int>(porcoes),
    };
  }

  RegraPorcao copyWith({SlotRefeicao? slot, bool? diaUtil, int? porcoes}) =>
      RegraPorcao(
        slot: slot ?? this.slot,
        diaUtil: diaUtil ?? this.diaUtil,
        porcoes: porcoes ?? this.porcoes,
      );
  RegraPorcao copyWithCompanion(RegrasPorcaoCompanion data) {
    return RegraPorcao(
      slot: data.slot.present ? data.slot.value : this.slot,
      diaUtil: data.diaUtil.present ? data.diaUtil.value : this.diaUtil,
      porcoes: data.porcoes.present ? data.porcoes.value : this.porcoes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegraPorcao(')
          ..write('slot: $slot, ')
          ..write('diaUtil: $diaUtil, ')
          ..write('porcoes: $porcoes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, diaUtil, porcoes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegraPorcao &&
          other.slot == this.slot &&
          other.diaUtil == this.diaUtil &&
          other.porcoes == this.porcoes);
}

class RegrasPorcaoCompanion extends UpdateCompanion<RegraPorcao> {
  final Value<SlotRefeicao> slot;
  final Value<bool> diaUtil;
  final Value<int> porcoes;
  final Value<int> rowid;
  const RegrasPorcaoCompanion({
    this.slot = const Value.absent(),
    this.diaUtil = const Value.absent(),
    this.porcoes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegrasPorcaoCompanion.insert({
    required SlotRefeicao slot,
    required bool diaUtil,
    required int porcoes,
    this.rowid = const Value.absent(),
  }) : slot = Value(slot),
       diaUtil = Value(diaUtil),
       porcoes = Value(porcoes);
  static Insertable<RegraPorcao> custom({
    Expression<String>? slot,
    Expression<bool>? diaUtil,
    Expression<int>? porcoes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (diaUtil != null) 'dia_util': diaUtil,
      if (porcoes != null) 'porcoes': porcoes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegrasPorcaoCompanion copyWith({
    Value<SlotRefeicao>? slot,
    Value<bool>? diaUtil,
    Value<int>? porcoes,
    Value<int>? rowid,
  }) {
    return RegrasPorcaoCompanion(
      slot: slot ?? this.slot,
      diaUtil: diaUtil ?? this.diaUtil,
      porcoes: porcoes ?? this.porcoes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slot.present) {
      map['slot'] = Variable<String>(
        $RegrasPorcaoTable.$converterslot.toSql(slot.value),
      );
    }
    if (diaUtil.present) {
      map['dia_util'] = Variable<bool>(diaUtil.value);
    }
    if (porcoes.present) {
      map['porcoes'] = Variable<int>(porcoes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegrasPorcaoCompanion(')
          ..write('slot: $slot, ')
          ..write('diaUtil: $diaUtil, ')
          ..write('porcoes: $porcoes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OverridesComboTable extends OverridesCombo
    with TableInfo<$OverridesComboTable, OverrideCombo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OverridesComboTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<DataPura, String> data =
      GeneratedColumn<String>(
        'data',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DataPura>($OverridesComboTable.$converterdata);
  @override
  late final GeneratedColumnWithTypeConverter<SlotRefeicao, String> slot =
      GeneratedColumn<String>(
        'slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SlotRefeicao>($OverridesComboTable.$converterslot);
  static const VerificationMeta _comboIdMeta = const VerificationMeta(
    'comboId',
  );
  @override
  late final GeneratedColumn<int> comboId = GeneratedColumn<int>(
    'combo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES combos (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [data, slot, comboId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overrides_combo';
  @override
  VerificationContext validateIntegrity(
    Insertable<OverrideCombo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('combo_id')) {
      context.handle(
        _comboIdMeta,
        comboId.isAcceptableOrUnknown(data['combo_id']!, _comboIdMeta),
      );
    } else if (isInserting) {
      context.missing(_comboIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {data, slot};
  @override
  OverrideCombo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OverrideCombo(
      data: $OverridesComboTable.$converterdata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data'],
        )!,
      ),
      slot: $OverridesComboTable.$converterslot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}slot'],
        )!,
      ),
      comboId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}combo_id'],
      )!,
    );
  }

  @override
  $OverridesComboTable createAlias(String alias) {
    return $OverridesComboTable(attachedDatabase, alias);
  }

  static TypeConverter<DataPura, String> $converterdata =
      const DataPuraConverter();
  static JsonTypeConverter2<SlotRefeicao, String, String> $converterslot =
      const EnumNameConverter<SlotRefeicao>(SlotRefeicao.values);
}

class OverrideCombo extends DataClass implements Insertable<OverrideCombo> {
  final DataPura data;
  final SlotRefeicao slot;
  final int comboId;
  const OverrideCombo({
    required this.data,
    required this.slot,
    required this.comboId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['data'] = Variable<String>(
        $OverridesComboTable.$converterdata.toSql(data),
      );
    }
    {
      map['slot'] = Variable<String>(
        $OverridesComboTable.$converterslot.toSql(slot),
      );
    }
    map['combo_id'] = Variable<int>(comboId);
    return map;
  }

  OverridesComboCompanion toCompanion(bool nullToAbsent) {
    return OverridesComboCompanion(
      data: Value(data),
      slot: Value(slot),
      comboId: Value(comboId),
    );
  }

  factory OverrideCombo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OverrideCombo(
      data: serializer.fromJson<DataPura>(json['data']),
      slot: $OverridesComboTable.$converterslot.fromJson(
        serializer.fromJson<String>(json['slot']),
      ),
      comboId: serializer.fromJson<int>(json['comboId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'data': serializer.toJson<DataPura>(data),
      'slot': serializer.toJson<String>(
        $OverridesComboTable.$converterslot.toJson(slot),
      ),
      'comboId': serializer.toJson<int>(comboId),
    };
  }

  OverrideCombo copyWith({DataPura? data, SlotRefeicao? slot, int? comboId}) =>
      OverrideCombo(
        data: data ?? this.data,
        slot: slot ?? this.slot,
        comboId: comboId ?? this.comboId,
      );
  OverrideCombo copyWithCompanion(OverridesComboCompanion data) {
    return OverrideCombo(
      data: data.data.present ? data.data.value : this.data,
      slot: data.slot.present ? data.slot.value : this.slot,
      comboId: data.comboId.present ? data.comboId.value : this.comboId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OverrideCombo(')
          ..write('data: $data, ')
          ..write('slot: $slot, ')
          ..write('comboId: $comboId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(data, slot, comboId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OverrideCombo &&
          other.data == this.data &&
          other.slot == this.slot &&
          other.comboId == this.comboId);
}

class OverridesComboCompanion extends UpdateCompanion<OverrideCombo> {
  final Value<DataPura> data;
  final Value<SlotRefeicao> slot;
  final Value<int> comboId;
  final Value<int> rowid;
  const OverridesComboCompanion({
    this.data = const Value.absent(),
    this.slot = const Value.absent(),
    this.comboId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OverridesComboCompanion.insert({
    required DataPura data,
    required SlotRefeicao slot,
    required int comboId,
    this.rowid = const Value.absent(),
  }) : data = Value(data),
       slot = Value(slot),
       comboId = Value(comboId);
  static Insertable<OverrideCombo> custom({
    Expression<String>? data,
    Expression<String>? slot,
    Expression<int>? comboId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (data != null) 'data': data,
      if (slot != null) 'slot': slot,
      if (comboId != null) 'combo_id': comboId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OverridesComboCompanion copyWith({
    Value<DataPura>? data,
    Value<SlotRefeicao>? slot,
    Value<int>? comboId,
    Value<int>? rowid,
  }) {
    return OverridesComboCompanion(
      data: data ?? this.data,
      slot: slot ?? this.slot,
      comboId: comboId ?? this.comboId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (data.present) {
      map['data'] = Variable<String>(
        $OverridesComboTable.$converterdata.toSql(data.value),
      );
    }
    if (slot.present) {
      map['slot'] = Variable<String>(
        $OverridesComboTable.$converterslot.toSql(slot.value),
      );
    }
    if (comboId.present) {
      map['combo_id'] = Variable<int>(comboId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OverridesComboCompanion(')
          ..write('data: $data, ')
          ..write('slot: $slot, ')
          ..write('comboId: $comboId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OverridesComponenteTable extends OverridesComponente
    with TableInfo<$OverridesComponenteTable, OverrideComponente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OverridesComponenteTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumnWithTypeConverter<DataPura, String> data =
      GeneratedColumn<String>(
        'data',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DataPura>($OverridesComponenteTable.$converterdata);
  @override
  late final GeneratedColumnWithTypeConverter<SlotRefeicao, String> slot =
      GeneratedColumn<String>(
        'slot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SlotRefeicao>($OverridesComponenteTable.$converterslot);
  static const VerificationMeta _receitaOriginalIdMeta = const VerificationMeta(
    'receitaOriginalId',
  );
  @override
  late final GeneratedColumn<int> receitaOriginalId = GeneratedColumn<int>(
    'receita_original_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES receitas (id)',
    ),
  );
  static const VerificationMeta _receitaNovaIdMeta = const VerificationMeta(
    'receitaNovaId',
  );
  @override
  late final GeneratedColumn<int> receitaNovaId = GeneratedColumn<int>(
    'receita_nova_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES receitas (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    data,
    slot,
    receitaOriginalId,
    receitaNovaId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overrides_componente';
  @override
  VerificationContext validateIntegrity(
    Insertable<OverrideComponente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('receita_original_id')) {
      context.handle(
        _receitaOriginalIdMeta,
        receitaOriginalId.isAcceptableOrUnknown(
          data['receita_original_id']!,
          _receitaOriginalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receitaOriginalIdMeta);
    }
    if (data.containsKey('receita_nova_id')) {
      context.handle(
        _receitaNovaIdMeta,
        receitaNovaId.isAcceptableOrUnknown(
          data['receita_nova_id']!,
          _receitaNovaIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {data, slot, receitaOriginalId};
  @override
  OverrideComponente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OverrideComponente(
      data: $OverridesComponenteTable.$converterdata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data'],
        )!,
      ),
      slot: $OverridesComponenteTable.$converterslot.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}slot'],
        )!,
      ),
      receitaOriginalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receita_original_id'],
      )!,
      receitaNovaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receita_nova_id'],
      ),
    );
  }

  @override
  $OverridesComponenteTable createAlias(String alias) {
    return $OverridesComponenteTable(attachedDatabase, alias);
  }

  static TypeConverter<DataPura, String> $converterdata =
      const DataPuraConverter();
  static JsonTypeConverter2<SlotRefeicao, String, String> $converterslot =
      const EnumNameConverter<SlotRefeicao>(SlotRefeicao.values);
}

class OverrideComponente extends DataClass
    implements Insertable<OverrideComponente> {
  final DataPura data;
  final SlotRefeicao slot;
  final int receitaOriginalId;

  /// Nulo significa componente removido do prato, não ausência de regra.
  final int? receitaNovaId;
  const OverrideComponente({
    required this.data,
    required this.slot,
    required this.receitaOriginalId,
    this.receitaNovaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      map['data'] = Variable<String>(
        $OverridesComponenteTable.$converterdata.toSql(data),
      );
    }
    {
      map['slot'] = Variable<String>(
        $OverridesComponenteTable.$converterslot.toSql(slot),
      );
    }
    map['receita_original_id'] = Variable<int>(receitaOriginalId);
    if (!nullToAbsent || receitaNovaId != null) {
      map['receita_nova_id'] = Variable<int>(receitaNovaId);
    }
    return map;
  }

  OverridesComponenteCompanion toCompanion(bool nullToAbsent) {
    return OverridesComponenteCompanion(
      data: Value(data),
      slot: Value(slot),
      receitaOriginalId: Value(receitaOriginalId),
      receitaNovaId: receitaNovaId == null && nullToAbsent
          ? const Value.absent()
          : Value(receitaNovaId),
    );
  }

  factory OverrideComponente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OverrideComponente(
      data: serializer.fromJson<DataPura>(json['data']),
      slot: $OverridesComponenteTable.$converterslot.fromJson(
        serializer.fromJson<String>(json['slot']),
      ),
      receitaOriginalId: serializer.fromJson<int>(json['receitaOriginalId']),
      receitaNovaId: serializer.fromJson<int?>(json['receitaNovaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'data': serializer.toJson<DataPura>(data),
      'slot': serializer.toJson<String>(
        $OverridesComponenteTable.$converterslot.toJson(slot),
      ),
      'receitaOriginalId': serializer.toJson<int>(receitaOriginalId),
      'receitaNovaId': serializer.toJson<int?>(receitaNovaId),
    };
  }

  OverrideComponente copyWith({
    DataPura? data,
    SlotRefeicao? slot,
    int? receitaOriginalId,
    Value<int?> receitaNovaId = const Value.absent(),
  }) => OverrideComponente(
    data: data ?? this.data,
    slot: slot ?? this.slot,
    receitaOriginalId: receitaOriginalId ?? this.receitaOriginalId,
    receitaNovaId: receitaNovaId.present
        ? receitaNovaId.value
        : this.receitaNovaId,
  );
  OverrideComponente copyWithCompanion(OverridesComponenteCompanion data) {
    return OverrideComponente(
      data: data.data.present ? data.data.value : this.data,
      slot: data.slot.present ? data.slot.value : this.slot,
      receitaOriginalId: data.receitaOriginalId.present
          ? data.receitaOriginalId.value
          : this.receitaOriginalId,
      receitaNovaId: data.receitaNovaId.present
          ? data.receitaNovaId.value
          : this.receitaNovaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OverrideComponente(')
          ..write('data: $data, ')
          ..write('slot: $slot, ')
          ..write('receitaOriginalId: $receitaOriginalId, ')
          ..write('receitaNovaId: $receitaNovaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(data, slot, receitaOriginalId, receitaNovaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OverrideComponente &&
          other.data == this.data &&
          other.slot == this.slot &&
          other.receitaOriginalId == this.receitaOriginalId &&
          other.receitaNovaId == this.receitaNovaId);
}

class OverridesComponenteCompanion extends UpdateCompanion<OverrideComponente> {
  final Value<DataPura> data;
  final Value<SlotRefeicao> slot;
  final Value<int> receitaOriginalId;
  final Value<int?> receitaNovaId;
  final Value<int> rowid;
  const OverridesComponenteCompanion({
    this.data = const Value.absent(),
    this.slot = const Value.absent(),
    this.receitaOriginalId = const Value.absent(),
    this.receitaNovaId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OverridesComponenteCompanion.insert({
    required DataPura data,
    required SlotRefeicao slot,
    required int receitaOriginalId,
    this.receitaNovaId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : data = Value(data),
       slot = Value(slot),
       receitaOriginalId = Value(receitaOriginalId);
  static Insertable<OverrideComponente> custom({
    Expression<String>? data,
    Expression<String>? slot,
    Expression<int>? receitaOriginalId,
    Expression<int>? receitaNovaId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (data != null) 'data': data,
      if (slot != null) 'slot': slot,
      if (receitaOriginalId != null) 'receita_original_id': receitaOriginalId,
      if (receitaNovaId != null) 'receita_nova_id': receitaNovaId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OverridesComponenteCompanion copyWith({
    Value<DataPura>? data,
    Value<SlotRefeicao>? slot,
    Value<int>? receitaOriginalId,
    Value<int?>? receitaNovaId,
    Value<int>? rowid,
  }) {
    return OverridesComponenteCompanion(
      data: data ?? this.data,
      slot: slot ?? this.slot,
      receitaOriginalId: receitaOriginalId ?? this.receitaOriginalId,
      receitaNovaId: receitaNovaId ?? this.receitaNovaId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (data.present) {
      map['data'] = Variable<String>(
        $OverridesComponenteTable.$converterdata.toSql(data.value),
      );
    }
    if (slot.present) {
      map['slot'] = Variable<String>(
        $OverridesComponenteTable.$converterslot.toSql(slot.value),
      );
    }
    if (receitaOriginalId.present) {
      map['receita_original_id'] = Variable<int>(receitaOriginalId.value);
    }
    if (receitaNovaId.present) {
      map['receita_nova_id'] = Variable<int>(receitaNovaId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OverridesComponenteCompanion(')
          ..write('data: $data, ')
          ..write('slot: $slot, ')
          ..write('receitaOriginalId: $receitaOriginalId, ')
          ..write('receitaNovaId: $receitaNovaId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListasCompraTable extends ListasCompra
    with TableInfo<$ListasCompraTable, ListaCompra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListasCompraTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DataPura, String> dataInicio =
      GeneratedColumn<String>(
        'data_inicio',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DataPura>($ListasCompraTable.$converterdataInicio);
  @override
  late final GeneratedColumnWithTypeConverter<DataPura, String> dataFim =
      GeneratedColumn<String>(
        'data_fim',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DataPura>($ListasCompraTable.$converterdataFim);
  static const VerificationMeta _criadaEmMeta = const VerificationMeta(
    'criadaEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadaEm = GeneratedColumn<DateTime>(
    'criada_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dataInicio, dataFim, criadaEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listas_compra';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListaCompra> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('criada_em')) {
      context.handle(
        _criadaEmMeta,
        criadaEm.isAcceptableOrUnknown(data['criada_em']!, _criadaEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadaEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListaCompra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListaCompra(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dataInicio: $ListasCompraTable.$converterdataInicio.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data_inicio'],
        )!,
      ),
      dataFim: $ListasCompraTable.$converterdataFim.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data_fim'],
        )!,
      ),
      criadaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criada_em'],
      )!,
    );
  }

  @override
  $ListasCompraTable createAlias(String alias) {
    return $ListasCompraTable(attachedDatabase, alias);
  }

  static TypeConverter<DataPura, String> $converterdataInicio =
      const DataPuraConverter();
  static TypeConverter<DataPura, String> $converterdataFim =
      const DataPuraConverter();
}

class ListaCompra extends DataClass implements Insertable<ListaCompra> {
  final int id;
  final DataPura dataInicio;
  final DataPura dataFim;
  final DateTime criadaEm;
  const ListaCompra({
    required this.id,
    required this.dataInicio,
    required this.dataFim,
    required this.criadaEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['data_inicio'] = Variable<String>(
        $ListasCompraTable.$converterdataInicio.toSql(dataInicio),
      );
    }
    {
      map['data_fim'] = Variable<String>(
        $ListasCompraTable.$converterdataFim.toSql(dataFim),
      );
    }
    map['criada_em'] = Variable<DateTime>(criadaEm);
    return map;
  }

  ListasCompraCompanion toCompanion(bool nullToAbsent) {
    return ListasCompraCompanion(
      id: Value(id),
      dataInicio: Value(dataInicio),
      dataFim: Value(dataFim),
      criadaEm: Value(criadaEm),
    );
  }

  factory ListaCompra.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListaCompra(
      id: serializer.fromJson<int>(json['id']),
      dataInicio: serializer.fromJson<DataPura>(json['dataInicio']),
      dataFim: serializer.fromJson<DataPura>(json['dataFim']),
      criadaEm: serializer.fromJson<DateTime>(json['criadaEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dataInicio': serializer.toJson<DataPura>(dataInicio),
      'dataFim': serializer.toJson<DataPura>(dataFim),
      'criadaEm': serializer.toJson<DateTime>(criadaEm),
    };
  }

  ListaCompra copyWith({
    int? id,
    DataPura? dataInicio,
    DataPura? dataFim,
    DateTime? criadaEm,
  }) => ListaCompra(
    id: id ?? this.id,
    dataInicio: dataInicio ?? this.dataInicio,
    dataFim: dataFim ?? this.dataFim,
    criadaEm: criadaEm ?? this.criadaEm,
  );
  ListaCompra copyWithCompanion(ListasCompraCompanion data) {
    return ListaCompra(
      id: data.id.present ? data.id.value : this.id,
      dataInicio: data.dataInicio.present
          ? data.dataInicio.value
          : this.dataInicio,
      dataFim: data.dataFim.present ? data.dataFim.value : this.dataFim,
      criadaEm: data.criadaEm.present ? data.criadaEm.value : this.criadaEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListaCompra(')
          ..write('id: $id, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('criadaEm: $criadaEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dataInicio, dataFim, criadaEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListaCompra &&
          other.id == this.id &&
          other.dataInicio == this.dataInicio &&
          other.dataFim == this.dataFim &&
          other.criadaEm == this.criadaEm);
}

class ListasCompraCompanion extends UpdateCompanion<ListaCompra> {
  final Value<int> id;
  final Value<DataPura> dataInicio;
  final Value<DataPura> dataFim;
  final Value<DateTime> criadaEm;
  const ListasCompraCompanion({
    this.id = const Value.absent(),
    this.dataInicio = const Value.absent(),
    this.dataFim = const Value.absent(),
    this.criadaEm = const Value.absent(),
  });
  ListasCompraCompanion.insert({
    this.id = const Value.absent(),
    required DataPura dataInicio,
    required DataPura dataFim,
    required DateTime criadaEm,
  }) : dataInicio = Value(dataInicio),
       dataFim = Value(dataFim),
       criadaEm = Value(criadaEm);
  static Insertable<ListaCompra> custom({
    Expression<int>? id,
    Expression<String>? dataInicio,
    Expression<String>? dataFim,
    Expression<DateTime>? criadaEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
      if (criadaEm != null) 'criada_em': criadaEm,
    });
  }

  ListasCompraCompanion copyWith({
    Value<int>? id,
    Value<DataPura>? dataInicio,
    Value<DataPura>? dataFim,
    Value<DateTime>? criadaEm,
  }) {
    return ListasCompraCompanion(
      id: id ?? this.id,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      criadaEm: criadaEm ?? this.criadaEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataInicio.present) {
      map['data_inicio'] = Variable<String>(
        $ListasCompraTable.$converterdataInicio.toSql(dataInicio.value),
      );
    }
    if (dataFim.present) {
      map['data_fim'] = Variable<String>(
        $ListasCompraTable.$converterdataFim.toSql(dataFim.value),
      );
    }
    if (criadaEm.present) {
      map['criada_em'] = Variable<DateTime>(criadaEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListasCompraCompanion(')
          ..write('id: $id, ')
          ..write('dataInicio: $dataInicio, ')
          ..write('dataFim: $dataFim, ')
          ..write('criadaEm: $criadaEm')
          ..write(')'))
        .toString();
  }
}

class $ListaCompraItensTable extends ListaCompraItens
    with TableInfo<$ListaCompraItensTable, ListaCompraItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListaCompraItensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _listaIdMeta = const VerificationMeta(
    'listaId',
  );
  @override
  late final GeneratedColumn<int> listaId = GeneratedColumn<int>(
    'lista_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES listas_compra (id)',
    ),
  );
  static const VerificationMeta _alimentoIdMeta = const VerificationMeta(
    'alimentoId',
  );
  @override
  late final GeneratedColumn<int> alimentoId = GeneratedColumn<int>(
    'alimento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alimentos (id)',
    ),
  );
  static const VerificationMeta _quantidadeGMeta = const VerificationMeta(
    'quantidadeG',
  );
  @override
  late final GeneratedColumn<double> quantidadeG = GeneratedColumn<double>(
    'quantidade_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcadoMeta = const VerificationMeta(
    'marcado',
  );
  @override
  late final GeneratedColumn<bool> marcado = GeneratedColumn<bool>(
    'marcado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("marcado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    listaId,
    alimentoId,
    quantidadeG,
    marcado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lista_compra_itens';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListaCompraItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lista_id')) {
      context.handle(
        _listaIdMeta,
        listaId.isAcceptableOrUnknown(data['lista_id']!, _listaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listaIdMeta);
    }
    if (data.containsKey('alimento_id')) {
      context.handle(
        _alimentoIdMeta,
        alimentoId.isAcceptableOrUnknown(data['alimento_id']!, _alimentoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alimentoIdMeta);
    }
    if (data.containsKey('quantidade_g')) {
      context.handle(
        _quantidadeGMeta,
        quantidadeG.isAcceptableOrUnknown(
          data['quantidade_g']!,
          _quantidadeGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantidadeGMeta);
    }
    if (data.containsKey('marcado')) {
      context.handle(
        _marcadoMeta,
        marcado.isAcceptableOrUnknown(data['marcado']!, _marcadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {listaId, alimentoId};
  @override
  ListaCompraItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListaCompraItem(
      listaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lista_id'],
      )!,
      alimentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alimento_id'],
      )!,
      quantidadeG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantidade_g'],
      )!,
      marcado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}marcado'],
      )!,
    );
  }

  @override
  $ListaCompraItensTable createAlias(String alias) {
    return $ListaCompraItensTable(attachedDatabase, alias);
  }
}

class ListaCompraItem extends DataClass implements Insertable<ListaCompraItem> {
  final int listaId;
  final int alimentoId;
  final double quantidadeG;
  final bool marcado;
  const ListaCompraItem({
    required this.listaId,
    required this.alimentoId,
    required this.quantidadeG,
    required this.marcado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lista_id'] = Variable<int>(listaId);
    map['alimento_id'] = Variable<int>(alimentoId);
    map['quantidade_g'] = Variable<double>(quantidadeG);
    map['marcado'] = Variable<bool>(marcado);
    return map;
  }

  ListaCompraItensCompanion toCompanion(bool nullToAbsent) {
    return ListaCompraItensCompanion(
      listaId: Value(listaId),
      alimentoId: Value(alimentoId),
      quantidadeG: Value(quantidadeG),
      marcado: Value(marcado),
    );
  }

  factory ListaCompraItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListaCompraItem(
      listaId: serializer.fromJson<int>(json['listaId']),
      alimentoId: serializer.fromJson<int>(json['alimentoId']),
      quantidadeG: serializer.fromJson<double>(json['quantidadeG']),
      marcado: serializer.fromJson<bool>(json['marcado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'listaId': serializer.toJson<int>(listaId),
      'alimentoId': serializer.toJson<int>(alimentoId),
      'quantidadeG': serializer.toJson<double>(quantidadeG),
      'marcado': serializer.toJson<bool>(marcado),
    };
  }

  ListaCompraItem copyWith({
    int? listaId,
    int? alimentoId,
    double? quantidadeG,
    bool? marcado,
  }) => ListaCompraItem(
    listaId: listaId ?? this.listaId,
    alimentoId: alimentoId ?? this.alimentoId,
    quantidadeG: quantidadeG ?? this.quantidadeG,
    marcado: marcado ?? this.marcado,
  );
  ListaCompraItem copyWithCompanion(ListaCompraItensCompanion data) {
    return ListaCompraItem(
      listaId: data.listaId.present ? data.listaId.value : this.listaId,
      alimentoId: data.alimentoId.present
          ? data.alimentoId.value
          : this.alimentoId,
      quantidadeG: data.quantidadeG.present
          ? data.quantidadeG.value
          : this.quantidadeG,
      marcado: data.marcado.present ? data.marcado.value : this.marcado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListaCompraItem(')
          ..write('listaId: $listaId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('quantidadeG: $quantidadeG, ')
          ..write('marcado: $marcado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(listaId, alimentoId, quantidadeG, marcado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListaCompraItem &&
          other.listaId == this.listaId &&
          other.alimentoId == this.alimentoId &&
          other.quantidadeG == this.quantidadeG &&
          other.marcado == this.marcado);
}

class ListaCompraItensCompanion extends UpdateCompanion<ListaCompraItem> {
  final Value<int> listaId;
  final Value<int> alimentoId;
  final Value<double> quantidadeG;
  final Value<bool> marcado;
  final Value<int> rowid;
  const ListaCompraItensCompanion({
    this.listaId = const Value.absent(),
    this.alimentoId = const Value.absent(),
    this.quantidadeG = const Value.absent(),
    this.marcado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListaCompraItensCompanion.insert({
    required int listaId,
    required int alimentoId,
    required double quantidadeG,
    this.marcado = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : listaId = Value(listaId),
       alimentoId = Value(alimentoId),
       quantidadeG = Value(quantidadeG);
  static Insertable<ListaCompraItem> custom({
    Expression<int>? listaId,
    Expression<int>? alimentoId,
    Expression<double>? quantidadeG,
    Expression<bool>? marcado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (listaId != null) 'lista_id': listaId,
      if (alimentoId != null) 'alimento_id': alimentoId,
      if (quantidadeG != null) 'quantidade_g': quantidadeG,
      if (marcado != null) 'marcado': marcado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListaCompraItensCompanion copyWith({
    Value<int>? listaId,
    Value<int>? alimentoId,
    Value<double>? quantidadeG,
    Value<bool>? marcado,
    Value<int>? rowid,
  }) {
    return ListaCompraItensCompanion(
      listaId: listaId ?? this.listaId,
      alimentoId: alimentoId ?? this.alimentoId,
      quantidadeG: quantidadeG ?? this.quantidadeG,
      marcado: marcado ?? this.marcado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (listaId.present) {
      map['lista_id'] = Variable<int>(listaId.value);
    }
    if (alimentoId.present) {
      map['alimento_id'] = Variable<int>(alimentoId.value);
    }
    if (quantidadeG.present) {
      map['quantidade_g'] = Variable<double>(quantidadeG.value);
    }
    if (marcado.present) {
      map['marcado'] = Variable<bool>(marcado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListaCompraItensCompanion(')
          ..write('listaId: $listaId, ')
          ..write('alimentoId: $alimentoId, ')
          ..write('quantidadeG: $quantidadeG, ')
          ..write('marcado: $marcado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AlimentosTable alimentos = $AlimentosTable(this);
  late final $ConversoesTable conversoes = $ConversoesTable(this);
  late final $ReceitasTable receitas = $ReceitasTable(this);
  late final $ReceitaIngredientesTable receitaIngredientes =
      $ReceitaIngredientesTable(this);
  late final $CombosTable combos = $CombosTable(this);
  late final $ComboReceitasTable comboReceitas = $ComboReceitasTable(this);
  late final $CicloItensTable cicloItens = $CicloItensTable(this);
  late final $ConfigTable config = $ConfigTable(this);
  late final $RegrasPorcaoTable regrasPorcao = $RegrasPorcaoTable(this);
  late final $OverridesComboTable overridesCombo = $OverridesComboTable(this);
  late final $OverridesComponenteTable overridesComponente =
      $OverridesComponenteTable(this);
  late final $ListasCompraTable listasCompra = $ListasCompraTable(this);
  late final $ListaCompraItensTable listaCompraItens = $ListaCompraItensTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    alimentos,
    conversoes,
    receitas,
    receitaIngredientes,
    combos,
    comboReceitas,
    cicloItens,
    config,
    regrasPorcao,
    overridesCombo,
    overridesComponente,
    listasCompra,
    listaCompraItens,
  ];
}

typedef $$AlimentosTableCreateCompanionBuilder =
    AlimentosCompanion Function({
      Value<int> id,
      required String nome,
      Value<String?> tacoCodigo,
      required double kcal100g,
      required double carboidratoG,
      required double proteinaG,
      required double gorduraG,
      required double fibraG,
      required double sodioMg,
      required SecaoMercado secaoMercado,
      required UnidadeCompra unidadeCompra,
    });
typedef $$AlimentosTableUpdateCompanionBuilder =
    AlimentosCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String?> tacoCodigo,
      Value<double> kcal100g,
      Value<double> carboidratoG,
      Value<double> proteinaG,
      Value<double> gorduraG,
      Value<double> fibraG,
      Value<double> sodioMg,
      Value<SecaoMercado> secaoMercado,
      Value<UnidadeCompra> unidadeCompra,
    });

final class $$AlimentosTableReferences
    extends BaseReferences<_$AppDatabase, $AlimentosTable, Alimento> {
  $$AlimentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ConversoesTable, List<Conversao>>
  _conversoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.conversoes,
    aliasName: 'alimentos__id__conversoes__alimento_id',
  );

  $$ConversoesTableProcessedTableManager get conversoesRefs {
    final manager = $$ConversoesTableTableManager(
      $_db,
      $_db.conversoes,
    ).filter((f) => f.alimentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_conversoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReceitaIngredientesTable,
    List<ReceitaIngrediente>
  >
  _receitaIngredientesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.receitaIngredientes,
        aliasName: 'alimentos__id__receita_ingredientes__alimento_id',
      );

  $$ReceitaIngredientesTableProcessedTableManager get receitaIngredientesRefs {
    final manager = $$ReceitaIngredientesTableTableManager(
      $_db,
      $_db.receitaIngredientes,
    ).filter((f) => f.alimentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _receitaIngredientesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ListaCompraItensTable, List<ListaCompraItem>>
  _listaCompraItensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.listaCompraItens,
    aliasName: 'alimentos__id__lista_compra_itens__alimento_id',
  );

  $$ListaCompraItensTableProcessedTableManager get listaCompraItensRefs {
    final manager = $$ListaCompraItensTableTableManager(
      $_db,
      $_db.listaCompraItens,
    ).filter((f) => f.alimentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _listaCompraItensRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlimentosTableFilterComposer
    extends Composer<_$AppDatabase, $AlimentosTable> {
  $$AlimentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tacoCodigo => $composableBuilder(
    column: $table.tacoCodigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal100g => $composableBuilder(
    column: $table.kcal100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carboidratoG => $composableBuilder(
    column: $table.carboidratoG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinaG => $composableBuilder(
    column: $table.proteinaG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gorduraG => $composableBuilder(
    column: $table.gorduraG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fibraG => $composableBuilder(
    column: $table.fibraG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sodioMg => $composableBuilder(
    column: $table.sodioMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SecaoMercado, SecaoMercado, String>
  get secaoMercado => $composableBuilder(
    column: $table.secaoMercado,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<UnidadeCompra, UnidadeCompra, String>
  get unidadeCompra => $composableBuilder(
    column: $table.unidadeCompra,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> conversoesRefs(
    Expression<bool> Function($$ConversoesTableFilterComposer f) f,
  ) {
    final $$ConversoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conversoes,
      getReferencedColumn: (t) => t.alimentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversoesTableFilterComposer(
            $db: $db,
            $table: $db.conversoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> receitaIngredientesRefs(
    Expression<bool> Function($$ReceitaIngredientesTableFilterComposer f) f,
  ) {
    final $$ReceitaIngredientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.receitaIngredientes,
      getReferencedColumn: (t) => t.alimentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitaIngredientesTableFilterComposer(
            $db: $db,
            $table: $db.receitaIngredientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> listaCompraItensRefs(
    Expression<bool> Function($$ListaCompraItensTableFilterComposer f) f,
  ) {
    final $$ListaCompraItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listaCompraItens,
      getReferencedColumn: (t) => t.alimentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListaCompraItensTableFilterComposer(
            $db: $db,
            $table: $db.listaCompraItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlimentosTableOrderingComposer
    extends Composer<_$AppDatabase, $AlimentosTable> {
  $$AlimentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tacoCodigo => $composableBuilder(
    column: $table.tacoCodigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal100g => $composableBuilder(
    column: $table.kcal100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carboidratoG => $composableBuilder(
    column: $table.carboidratoG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinaG => $composableBuilder(
    column: $table.proteinaG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gorduraG => $composableBuilder(
    column: $table.gorduraG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fibraG => $composableBuilder(
    column: $table.fibraG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sodioMg => $composableBuilder(
    column: $table.sodioMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secaoMercado => $composableBuilder(
    column: $table.secaoMercado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidadeCompra => $composableBuilder(
    column: $table.unidadeCompra,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlimentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlimentosTable> {
  $$AlimentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get tacoCodigo => $composableBuilder(
    column: $table.tacoCodigo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get kcal100g =>
      $composableBuilder(column: $table.kcal100g, builder: (column) => column);

  GeneratedColumn<double> get carboidratoG => $composableBuilder(
    column: $table.carboidratoG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinaG =>
      $composableBuilder(column: $table.proteinaG, builder: (column) => column);

  GeneratedColumn<double> get gorduraG =>
      $composableBuilder(column: $table.gorduraG, builder: (column) => column);

  GeneratedColumn<double> get fibraG =>
      $composableBuilder(column: $table.fibraG, builder: (column) => column);

  GeneratedColumn<double> get sodioMg =>
      $composableBuilder(column: $table.sodioMg, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SecaoMercado, String> get secaoMercado =>
      $composableBuilder(
        column: $table.secaoMercado,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<UnidadeCompra, String> get unidadeCompra =>
      $composableBuilder(
        column: $table.unidadeCompra,
        builder: (column) => column,
      );

  Expression<T> conversoesRefs<T extends Object>(
    Expression<T> Function($$ConversoesTableAnnotationComposer a) f,
  ) {
    final $$ConversoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conversoes,
      getReferencedColumn: (t) => t.alimentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversoesTableAnnotationComposer(
            $db: $db,
            $table: $db.conversoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> receitaIngredientesRefs<T extends Object>(
    Expression<T> Function($$ReceitaIngredientesTableAnnotationComposer a) f,
  ) {
    final $$ReceitaIngredientesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.receitaIngredientes,
          getReferencedColumn: (t) => t.alimentoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReceitaIngredientesTableAnnotationComposer(
                $db: $db,
                $table: $db.receitaIngredientes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> listaCompraItensRefs<T extends Object>(
    Expression<T> Function($$ListaCompraItensTableAnnotationComposer a) f,
  ) {
    final $$ListaCompraItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listaCompraItens,
      getReferencedColumn: (t) => t.alimentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListaCompraItensTableAnnotationComposer(
            $db: $db,
            $table: $db.listaCompraItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlimentosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlimentosTable,
          Alimento,
          $$AlimentosTableFilterComposer,
          $$AlimentosTableOrderingComposer,
          $$AlimentosTableAnnotationComposer,
          $$AlimentosTableCreateCompanionBuilder,
          $$AlimentosTableUpdateCompanionBuilder,
          (Alimento, $$AlimentosTableReferences),
          Alimento,
          PrefetchHooks Function({
            bool conversoesRefs,
            bool receitaIngredientesRefs,
            bool listaCompraItensRefs,
          })
        > {
  $$AlimentosTableTableManager(_$AppDatabase db, $AlimentosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlimentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlimentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlimentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> tacoCodigo = const Value.absent(),
                Value<double> kcal100g = const Value.absent(),
                Value<double> carboidratoG = const Value.absent(),
                Value<double> proteinaG = const Value.absent(),
                Value<double> gorduraG = const Value.absent(),
                Value<double> fibraG = const Value.absent(),
                Value<double> sodioMg = const Value.absent(),
                Value<SecaoMercado> secaoMercado = const Value.absent(),
                Value<UnidadeCompra> unidadeCompra = const Value.absent(),
              }) => AlimentosCompanion(
                id: id,
                nome: nome,
                tacoCodigo: tacoCodigo,
                kcal100g: kcal100g,
                carboidratoG: carboidratoG,
                proteinaG: proteinaG,
                gorduraG: gorduraG,
                fibraG: fibraG,
                sodioMg: sodioMg,
                secaoMercado: secaoMercado,
                unidadeCompra: unidadeCompra,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<String?> tacoCodigo = const Value.absent(),
                required double kcal100g,
                required double carboidratoG,
                required double proteinaG,
                required double gorduraG,
                required double fibraG,
                required double sodioMg,
                required SecaoMercado secaoMercado,
                required UnidadeCompra unidadeCompra,
              }) => AlimentosCompanion.insert(
                id: id,
                nome: nome,
                tacoCodigo: tacoCodigo,
                kcal100g: kcal100g,
                carboidratoG: carboidratoG,
                proteinaG: proteinaG,
                gorduraG: gorduraG,
                fibraG: fibraG,
                sodioMg: sodioMg,
                secaoMercado: secaoMercado,
                unidadeCompra: unidadeCompra,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AlimentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                conversoesRefs = false,
                receitaIngredientesRefs = false,
                listaCompraItensRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (conversoesRefs) db.conversoes,
                    if (receitaIngredientesRefs) db.receitaIngredientes,
                    if (listaCompraItensRefs) db.listaCompraItens,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (conversoesRefs)
                        await $_getPrefetchedData<
                          Alimento,
                          $AlimentosTable,
                          Conversao
                        >(
                          currentTable: table,
                          referencedTable: $$AlimentosTableReferences
                              ._conversoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AlimentosTableReferences(
                                db,
                                table,
                                p0,
                              ).conversoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.alimentoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (receitaIngredientesRefs)
                        await $_getPrefetchedData<
                          Alimento,
                          $AlimentosTable,
                          ReceitaIngrediente
                        >(
                          currentTable: table,
                          referencedTable: $$AlimentosTableReferences
                              ._receitaIngredientesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AlimentosTableReferences(
                                db,
                                table,
                                p0,
                              ).receitaIngredientesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.alimentoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (listaCompraItensRefs)
                        await $_getPrefetchedData<
                          Alimento,
                          $AlimentosTable,
                          ListaCompraItem
                        >(
                          currentTable: table,
                          referencedTable: $$AlimentosTableReferences
                              ._listaCompraItensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AlimentosTableReferences(
                                db,
                                table,
                                p0,
                              ).listaCompraItensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.alimentoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AlimentosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlimentosTable,
      Alimento,
      $$AlimentosTableFilterComposer,
      $$AlimentosTableOrderingComposer,
      $$AlimentosTableAnnotationComposer,
      $$AlimentosTableCreateCompanionBuilder,
      $$AlimentosTableUpdateCompanionBuilder,
      (Alimento, $$AlimentosTableReferences),
      Alimento,
      PrefetchHooks Function({
        bool conversoesRefs,
        bool receitaIngredientesRefs,
        bool listaCompraItensRefs,
      })
    >;
typedef $$ConversoesTableCreateCompanionBuilder =
    ConversoesCompanion Function({
      required int alimentoId,
      required Unidade unidade,
      required double gramas,
      Value<int> rowid,
    });
typedef $$ConversoesTableUpdateCompanionBuilder =
    ConversoesCompanion Function({
      Value<int> alimentoId,
      Value<Unidade> unidade,
      Value<double> gramas,
      Value<int> rowid,
    });

final class $$ConversoesTableReferences
    extends BaseReferences<_$AppDatabase, $ConversoesTable, Conversao> {
  $$ConversoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AlimentosTable _alimentoIdTable(_$AppDatabase db) =>
      db.alimentos.createAlias('conversoes__alimento_id__alimentos__id');

  $$AlimentosTableProcessedTableManager get alimentoId {
    final $_column = $_itemColumn<int>('alimento_id')!;

    final manager = $$AlimentosTableTableManager(
      $_db,
      $_db.alimentos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alimentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConversoesTableFilterComposer
    extends Composer<_$AppDatabase, $ConversoesTable> {
  $$ConversoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<Unidade, Unidade, String> get unidade =>
      $composableBuilder(
        column: $table.unidade,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get gramas => $composableBuilder(
    column: $table.gramas,
    builder: (column) => ColumnFilters(column),
  );

  $$AlimentosTableFilterComposer get alimentoId {
    final $$AlimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableFilterComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConversoesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversoesTable> {
  $$ConversoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gramas => $composableBuilder(
    column: $table.gramas,
    builder: (column) => ColumnOrderings(column),
  );

  $$AlimentosTableOrderingComposer get alimentoId {
    final $$AlimentosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableOrderingComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConversoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversoesTable> {
  $$ConversoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<Unidade, String> get unidade =>
      $composableBuilder(column: $table.unidade, builder: (column) => column);

  GeneratedColumn<double> get gramas =>
      $composableBuilder(column: $table.gramas, builder: (column) => column);

  $$AlimentosTableAnnotationComposer get alimentoId {
    final $$AlimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConversoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversoesTable,
          Conversao,
          $$ConversoesTableFilterComposer,
          $$ConversoesTableOrderingComposer,
          $$ConversoesTableAnnotationComposer,
          $$ConversoesTableCreateCompanionBuilder,
          $$ConversoesTableUpdateCompanionBuilder,
          (Conversao, $$ConversoesTableReferences),
          Conversao,
          PrefetchHooks Function({bool alimentoId})
        > {
  $$ConversoesTableTableManager(_$AppDatabase db, $ConversoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> alimentoId = const Value.absent(),
                Value<Unidade> unidade = const Value.absent(),
                Value<double> gramas = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversoesCompanion(
                alimentoId: alimentoId,
                unidade: unidade,
                gramas: gramas,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int alimentoId,
                required Unidade unidade,
                required double gramas,
                Value<int> rowid = const Value.absent(),
              }) => ConversoesCompanion.insert(
                alimentoId: alimentoId,
                unidade: unidade,
                gramas: gramas,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ConversoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({alimentoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (alimentoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.alimentoId,
                                referencedTable: $$ConversoesTableReferences
                                    ._alimentoIdTable(db),
                                referencedColumn: $$ConversoesTableReferences
                                    ._alimentoIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ConversoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversoesTable,
      Conversao,
      $$ConversoesTableFilterComposer,
      $$ConversoesTableOrderingComposer,
      $$ConversoesTableAnnotationComposer,
      $$ConversoesTableCreateCompanionBuilder,
      $$ConversoesTableUpdateCompanionBuilder,
      (Conversao, $$ConversoesTableReferences),
      Conversao,
      PrefetchHooks Function({bool alimentoId})
    >;
typedef $$ReceitasTableCreateCompanionBuilder =
    ReceitasCompanion Function({
      Value<int> id,
      required String nome,
      required CategoriaReceita categoria,
      Value<int> rendimentoPorcoes,
      Value<int> tempoPreparoMin,
      Value<String> modoPreparo,
      Value<String?> fotoPath,
      Value<String> origem,
      Value<bool> ativa,
    });
typedef $$ReceitasTableUpdateCompanionBuilder =
    ReceitasCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<CategoriaReceita> categoria,
      Value<int> rendimentoPorcoes,
      Value<int> tempoPreparoMin,
      Value<String> modoPreparo,
      Value<String?> fotoPath,
      Value<String> origem,
      Value<bool> ativa,
    });

final class $$ReceitasTableReferences
    extends BaseReferences<_$AppDatabase, $ReceitasTable, Receita> {
  $$ReceitasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $ReceitaIngredientesTable,
    List<ReceitaIngrediente>
  >
  _receitaIngredientesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.receitaIngredientes,
        aliasName: 'receitas__id__receita_ingredientes__receita_id',
      );

  $$ReceitaIngredientesTableProcessedTableManager get receitaIngredientesRefs {
    final manager = $$ReceitaIngredientesTableTableManager(
      $_db,
      $_db.receitaIngredientes,
    ).filter((f) => f.receitaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _receitaIngredientesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ComboReceitasTable, List<ComboReceita>>
  _comboReceitasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.comboReceitas,
    aliasName: 'receitas__id__combo_receitas__receita_id',
  );

  $$ComboReceitasTableProcessedTableManager get comboReceitasRefs {
    final manager = $$ComboReceitasTableTableManager(
      $_db,
      $_db.comboReceitas,
    ).filter((f) => f.receitaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_comboReceitasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReceitasTableFilterComposer
    extends Composer<_$AppDatabase, $ReceitasTable> {
  $$ReceitasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoriaReceita, CategoriaReceita, String>
  get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get rendimentoPorcoes => $composableBuilder(
    column: $table.rendimentoPorcoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempoPreparoMin => $composableBuilder(
    column: $table.tempoPreparoMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modoPreparo => $composableBuilder(
    column: $table.modoPreparo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativa => $composableBuilder(
    column: $table.ativa,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> receitaIngredientesRefs(
    Expression<bool> Function($$ReceitaIngredientesTableFilterComposer f) f,
  ) {
    final $$ReceitaIngredientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.receitaIngredientes,
      getReferencedColumn: (t) => t.receitaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitaIngredientesTableFilterComposer(
            $db: $db,
            $table: $db.receitaIngredientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> comboReceitasRefs(
    Expression<bool> Function($$ComboReceitasTableFilterComposer f) f,
  ) {
    final $$ComboReceitasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comboReceitas,
      getReferencedColumn: (t) => t.receitaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComboReceitasTableFilterComposer(
            $db: $db,
            $table: $db.comboReceitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReceitasTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceitasTable> {
  $$ReceitasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rendimentoPorcoes => $composableBuilder(
    column: $table.rendimentoPorcoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempoPreparoMin => $composableBuilder(
    column: $table.tempoPreparoMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modoPreparo => $composableBuilder(
    column: $table.modoPreparo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativa => $composableBuilder(
    column: $table.ativa,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReceitasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceitasTable> {
  $$ReceitasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoriaReceita, String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<int> get rendimentoPorcoes => $composableBuilder(
    column: $table.rendimentoPorcoes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tempoPreparoMin => $composableBuilder(
    column: $table.tempoPreparoMin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modoPreparo => $composableBuilder(
    column: $table.modoPreparo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<String> get origem =>
      $composableBuilder(column: $table.origem, builder: (column) => column);

  GeneratedColumn<bool> get ativa =>
      $composableBuilder(column: $table.ativa, builder: (column) => column);

  Expression<T> receitaIngredientesRefs<T extends Object>(
    Expression<T> Function($$ReceitaIngredientesTableAnnotationComposer a) f,
  ) {
    final $$ReceitaIngredientesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.receitaIngredientes,
          getReferencedColumn: (t) => t.receitaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReceitaIngredientesTableAnnotationComposer(
                $db: $db,
                $table: $db.receitaIngredientes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> comboReceitasRefs<T extends Object>(
    Expression<T> Function($$ComboReceitasTableAnnotationComposer a) f,
  ) {
    final $$ComboReceitasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comboReceitas,
      getReferencedColumn: (t) => t.receitaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComboReceitasTableAnnotationComposer(
            $db: $db,
            $table: $db.comboReceitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReceitasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceitasTable,
          Receita,
          $$ReceitasTableFilterComposer,
          $$ReceitasTableOrderingComposer,
          $$ReceitasTableAnnotationComposer,
          $$ReceitasTableCreateCompanionBuilder,
          $$ReceitasTableUpdateCompanionBuilder,
          (Receita, $$ReceitasTableReferences),
          Receita,
          PrefetchHooks Function({
            bool receitaIngredientesRefs,
            bool comboReceitasRefs,
          })
        > {
  $$ReceitasTableTableManager(_$AppDatabase db, $ReceitasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceitasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceitasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceitasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<CategoriaReceita> categoria = const Value.absent(),
                Value<int> rendimentoPorcoes = const Value.absent(),
                Value<int> tempoPreparoMin = const Value.absent(),
                Value<String> modoPreparo = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
                Value<String> origem = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
              }) => ReceitasCompanion(
                id: id,
                nome: nome,
                categoria: categoria,
                rendimentoPorcoes: rendimentoPorcoes,
                tempoPreparoMin: tempoPreparoMin,
                modoPreparo: modoPreparo,
                fotoPath: fotoPath,
                origem: origem,
                ativa: ativa,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required CategoriaReceita categoria,
                Value<int> rendimentoPorcoes = const Value.absent(),
                Value<int> tempoPreparoMin = const Value.absent(),
                Value<String> modoPreparo = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
                Value<String> origem = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
              }) => ReceitasCompanion.insert(
                id: id,
                nome: nome,
                categoria: categoria,
                rendimentoPorcoes: rendimentoPorcoes,
                tempoPreparoMin: tempoPreparoMin,
                modoPreparo: modoPreparo,
                fotoPath: fotoPath,
                origem: origem,
                ativa: ativa,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReceitasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({receitaIngredientesRefs = false, comboReceitasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (receitaIngredientesRefs) db.receitaIngredientes,
                    if (comboReceitasRefs) db.comboReceitas,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (receitaIngredientesRefs)
                        await $_getPrefetchedData<
                          Receita,
                          $ReceitasTable,
                          ReceitaIngrediente
                        >(
                          currentTable: table,
                          referencedTable: $$ReceitasTableReferences
                              ._receitaIngredientesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReceitasTableReferences(
                                db,
                                table,
                                p0,
                              ).receitaIngredientesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.receitaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (comboReceitasRefs)
                        await $_getPrefetchedData<
                          Receita,
                          $ReceitasTable,
                          ComboReceita
                        >(
                          currentTable: table,
                          referencedTable: $$ReceitasTableReferences
                              ._comboReceitasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReceitasTableReferences(
                                db,
                                table,
                                p0,
                              ).comboReceitasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.receitaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReceitasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceitasTable,
      Receita,
      $$ReceitasTableFilterComposer,
      $$ReceitasTableOrderingComposer,
      $$ReceitasTableAnnotationComposer,
      $$ReceitasTableCreateCompanionBuilder,
      $$ReceitasTableUpdateCompanionBuilder,
      (Receita, $$ReceitasTableReferences),
      Receita,
      PrefetchHooks Function({
        bool receitaIngredientesRefs,
        bool comboReceitasRefs,
      })
    >;
typedef $$ReceitaIngredientesTableCreateCompanionBuilder =
    ReceitaIngredientesCompanion Function({
      Value<int> id,
      required int receitaId,
      required int alimentoId,
      required int ordem,
      required double quantidade,
      required Unidade unidade,
      Value<String?> observacao,
    });
typedef $$ReceitaIngredientesTableUpdateCompanionBuilder =
    ReceitaIngredientesCompanion Function({
      Value<int> id,
      Value<int> receitaId,
      Value<int> alimentoId,
      Value<int> ordem,
      Value<double> quantidade,
      Value<Unidade> unidade,
      Value<String?> observacao,
    });

final class $$ReceitaIngredientesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReceitaIngredientesTable,
          ReceitaIngrediente
        > {
  $$ReceitaIngredientesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ReceitasTable _receitaIdTable(_$AppDatabase db) =>
      db.receitas.createAlias('receita_ingredientes__receita_id__receitas__id');

  $$ReceitasTableProcessedTableManager get receitaId {
    final $_column = $_itemColumn<int>('receita_id')!;

    final manager = $$ReceitasTableTableManager(
      $_db,
      $_db.receitas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receitaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AlimentosTable _alimentoIdTable(_$AppDatabase db) => db.alimentos
      .createAlias('receita_ingredientes__alimento_id__alimentos__id');

  $$AlimentosTableProcessedTableManager get alimentoId {
    final $_column = $_itemColumn<int>('alimento_id')!;

    final manager = $$AlimentosTableTableManager(
      $_db,
      $_db.alimentos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alimentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReceitaIngredientesTableFilterComposer
    extends Composer<_$AppDatabase, $ReceitaIngredientesTable> {
  $$ReceitaIngredientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Unidade, Unidade, String> get unidade =>
      $composableBuilder(
        column: $table.unidade,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnFilters(column),
  );

  $$ReceitasTableFilterComposer get receitaId {
    final $$ReceitasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableFilterComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableFilterComposer get alimentoId {
    final $$AlimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableFilterComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceitaIngredientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceitaIngredientesTable> {
  $$ReceitaIngredientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReceitasTableOrderingComposer get receitaId {
    final $$ReceitasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableOrderingComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableOrderingComposer get alimentoId {
    final $$AlimentosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableOrderingComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceitaIngredientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceitaIngredientesTable> {
  $$ReceitaIngredientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  GeneratedColumn<double> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Unidade, String> get unidade =>
      $composableBuilder(column: $table.unidade, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  $$ReceitasTableAnnotationComposer get receitaId {
    final $$ReceitasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableAnnotationComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableAnnotationComposer get alimentoId {
    final $$AlimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceitaIngredientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceitaIngredientesTable,
          ReceitaIngrediente,
          $$ReceitaIngredientesTableFilterComposer,
          $$ReceitaIngredientesTableOrderingComposer,
          $$ReceitaIngredientesTableAnnotationComposer,
          $$ReceitaIngredientesTableCreateCompanionBuilder,
          $$ReceitaIngredientesTableUpdateCompanionBuilder,
          (ReceitaIngrediente, $$ReceitaIngredientesTableReferences),
          ReceitaIngrediente,
          PrefetchHooks Function({bool receitaId, bool alimentoId})
        > {
  $$ReceitaIngredientesTableTableManager(
    _$AppDatabase db,
    $ReceitaIngredientesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceitaIngredientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceitaIngredientesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReceitaIngredientesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> receitaId = const Value.absent(),
                Value<int> alimentoId = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<double> quantidade = const Value.absent(),
                Value<Unidade> unidade = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
              }) => ReceitaIngredientesCompanion(
                id: id,
                receitaId: receitaId,
                alimentoId: alimentoId,
                ordem: ordem,
                quantidade: quantidade,
                unidade: unidade,
                observacao: observacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int receitaId,
                required int alimentoId,
                required int ordem,
                required double quantidade,
                required Unidade unidade,
                Value<String?> observacao = const Value.absent(),
              }) => ReceitaIngredientesCompanion.insert(
                id: id,
                receitaId: receitaId,
                alimentoId: alimentoId,
                ordem: ordem,
                quantidade: quantidade,
                unidade: unidade,
                observacao: observacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReceitaIngredientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({receitaId = false, alimentoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (receitaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.receitaId,
                                referencedTable:
                                    $$ReceitaIngredientesTableReferences
                                        ._receitaIdTable(db),
                                referencedColumn:
                                    $$ReceitaIngredientesTableReferences
                                        ._receitaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (alimentoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.alimentoId,
                                referencedTable:
                                    $$ReceitaIngredientesTableReferences
                                        ._alimentoIdTable(db),
                                referencedColumn:
                                    $$ReceitaIngredientesTableReferences
                                        ._alimentoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReceitaIngredientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceitaIngredientesTable,
      ReceitaIngrediente,
      $$ReceitaIngredientesTableFilterComposer,
      $$ReceitaIngredientesTableOrderingComposer,
      $$ReceitaIngredientesTableAnnotationComposer,
      $$ReceitaIngredientesTableCreateCompanionBuilder,
      $$ReceitaIngredientesTableUpdateCompanionBuilder,
      (ReceitaIngrediente, $$ReceitaIngredientesTableReferences),
      ReceitaIngrediente,
      PrefetchHooks Function({bool receitaId, bool alimentoId})
    >;
typedef $$CombosTableCreateCompanionBuilder =
    CombosCompanion Function({
      Value<int> id,
      required String nome,
      required TipoCombo tipo,
      Value<String?> fotoPath,
      Value<String> origem,
      Value<bool> ativo,
    });
typedef $$CombosTableUpdateCompanionBuilder =
    CombosCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<TipoCombo> tipo,
      Value<String?> fotoPath,
      Value<String> origem,
      Value<bool> ativo,
    });

final class $$CombosTableReferences
    extends BaseReferences<_$AppDatabase, $CombosTable, Combo> {
  $$CombosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComboReceitasTable, List<ComboReceita>>
  _comboReceitasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.comboReceitas,
    aliasName: 'combos__id__combo_receitas__combo_id',
  );

  $$ComboReceitasTableProcessedTableManager get comboReceitasRefs {
    final manager = $$ComboReceitasTableTableManager(
      $_db,
      $_db.comboReceitas,
    ).filter((f) => f.comboId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_comboReceitasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CicloItensTable, List<CicloItem>>
  _cicloItensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cicloItens,
    aliasName: 'combos__id__ciclo_itens__combo_id',
  );

  $$CicloItensTableProcessedTableManager get cicloItensRefs {
    final manager = $$CicloItensTableTableManager(
      $_db,
      $_db.cicloItens,
    ).filter((f) => f.comboId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cicloItensRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OverridesComboTable, List<OverrideCombo>>
  _overridesComboRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.overridesCombo,
    aliasName: 'combos__id__overrides_combo__combo_id',
  );

  $$OverridesComboTableProcessedTableManager get overridesComboRefs {
    final manager = $$OverridesComboTableTableManager(
      $_db,
      $_db.overridesCombo,
    ).filter((f) => f.comboId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_overridesComboRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CombosTableFilterComposer
    extends Composer<_$AppDatabase, $CombosTable> {
  $$CombosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoCombo, TipoCombo, String> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> comboReceitasRefs(
    Expression<bool> Function($$ComboReceitasTableFilterComposer f) f,
  ) {
    final $$ComboReceitasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comboReceitas,
      getReferencedColumn: (t) => t.comboId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComboReceitasTableFilterComposer(
            $db: $db,
            $table: $db.comboReceitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cicloItensRefs(
    Expression<bool> Function($$CicloItensTableFilterComposer f) f,
  ) {
    final $$CicloItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cicloItens,
      getReferencedColumn: (t) => t.comboId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CicloItensTableFilterComposer(
            $db: $db,
            $table: $db.cicloItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> overridesComboRefs(
    Expression<bool> Function($$OverridesComboTableFilterComposer f) f,
  ) {
    final $$OverridesComboTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCombo,
      getReferencedColumn: (t) => t.comboId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesComboTableFilterComposer(
            $db: $db,
            $table: $db.overridesCombo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CombosTableOrderingComposer
    extends Composer<_$AppDatabase, $CombosTable> {
  $$CombosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoPath => $composableBuilder(
    column: $table.fotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CombosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CombosTable> {
  $$CombosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoCombo, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get fotoPath =>
      $composableBuilder(column: $table.fotoPath, builder: (column) => column);

  GeneratedColumn<String> get origem =>
      $composableBuilder(column: $table.origem, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  Expression<T> comboReceitasRefs<T extends Object>(
    Expression<T> Function($$ComboReceitasTableAnnotationComposer a) f,
  ) {
    final $$ComboReceitasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comboReceitas,
      getReferencedColumn: (t) => t.comboId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComboReceitasTableAnnotationComposer(
            $db: $db,
            $table: $db.comboReceitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cicloItensRefs<T extends Object>(
    Expression<T> Function($$CicloItensTableAnnotationComposer a) f,
  ) {
    final $$CicloItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cicloItens,
      getReferencedColumn: (t) => t.comboId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CicloItensTableAnnotationComposer(
            $db: $db,
            $table: $db.cicloItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> overridesComboRefs<T extends Object>(
    Expression<T> Function($$OverridesComboTableAnnotationComposer a) f,
  ) {
    final $$OverridesComboTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overridesCombo,
      getReferencedColumn: (t) => t.comboId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OverridesComboTableAnnotationComposer(
            $db: $db,
            $table: $db.overridesCombo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CombosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CombosTable,
          Combo,
          $$CombosTableFilterComposer,
          $$CombosTableOrderingComposer,
          $$CombosTableAnnotationComposer,
          $$CombosTableCreateCompanionBuilder,
          $$CombosTableUpdateCompanionBuilder,
          (Combo, $$CombosTableReferences),
          Combo,
          PrefetchHooks Function({
            bool comboReceitasRefs,
            bool cicloItensRefs,
            bool overridesComboRefs,
          })
        > {
  $$CombosTableTableManager(_$AppDatabase db, $CombosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CombosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CombosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CombosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<TipoCombo> tipo = const Value.absent(),
                Value<String?> fotoPath = const Value.absent(),
                Value<String> origem = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
              }) => CombosCompanion(
                id: id,
                nome: nome,
                tipo: tipo,
                fotoPath: fotoPath,
                origem: origem,
                ativo: ativo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required TipoCombo tipo,
                Value<String?> fotoPath = const Value.absent(),
                Value<String> origem = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
              }) => CombosCompanion.insert(
                id: id,
                nome: nome,
                tipo: tipo,
                fotoPath: fotoPath,
                origem: origem,
                ativo: ativo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CombosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                comboReceitasRefs = false,
                cicloItensRefs = false,
                overridesComboRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (comboReceitasRefs) db.comboReceitas,
                    if (cicloItensRefs) db.cicloItens,
                    if (overridesComboRefs) db.overridesCombo,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (comboReceitasRefs)
                        await $_getPrefetchedData<
                          Combo,
                          $CombosTable,
                          ComboReceita
                        >(
                          currentTable: table,
                          referencedTable: $$CombosTableReferences
                              ._comboReceitasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CombosTableReferences(
                                db,
                                table,
                                p0,
                              ).comboReceitasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.comboId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cicloItensRefs)
                        await $_getPrefetchedData<
                          Combo,
                          $CombosTable,
                          CicloItem
                        >(
                          currentTable: table,
                          referencedTable: $$CombosTableReferences
                              ._cicloItensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CombosTableReferences(
                                db,
                                table,
                                p0,
                              ).cicloItensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.comboId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (overridesComboRefs)
                        await $_getPrefetchedData<
                          Combo,
                          $CombosTable,
                          OverrideCombo
                        >(
                          currentTable: table,
                          referencedTable: $$CombosTableReferences
                              ._overridesComboRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CombosTableReferences(
                                db,
                                table,
                                p0,
                              ).overridesComboRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.comboId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CombosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CombosTable,
      Combo,
      $$CombosTableFilterComposer,
      $$CombosTableOrderingComposer,
      $$CombosTableAnnotationComposer,
      $$CombosTableCreateCompanionBuilder,
      $$CombosTableUpdateCompanionBuilder,
      (Combo, $$CombosTableReferences),
      Combo,
      PrefetchHooks Function({
        bool comboReceitasRefs,
        bool cicloItensRefs,
        bool overridesComboRefs,
      })
    >;
typedef $$ComboReceitasTableCreateCompanionBuilder =
    ComboReceitasCompanion Function({
      required int comboId,
      required int receitaId,
      required int ordem,
      Value<int> rowid,
    });
typedef $$ComboReceitasTableUpdateCompanionBuilder =
    ComboReceitasCompanion Function({
      Value<int> comboId,
      Value<int> receitaId,
      Value<int> ordem,
      Value<int> rowid,
    });

final class $$ComboReceitasTableReferences
    extends BaseReferences<_$AppDatabase, $ComboReceitasTable, ComboReceita> {
  $$ComboReceitasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CombosTable _comboIdTable(_$AppDatabase db) =>
      db.combos.createAlias('combo_receitas__combo_id__combos__id');

  $$CombosTableProcessedTableManager get comboId {
    final $_column = $_itemColumn<int>('combo_id')!;

    final manager = $$CombosTableTableManager(
      $_db,
      $_db.combos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_comboIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReceitasTable _receitaIdTable(_$AppDatabase db) =>
      db.receitas.createAlias('combo_receitas__receita_id__receitas__id');

  $$ReceitasTableProcessedTableManager get receitaId {
    final $_column = $_itemColumn<int>('receita_id')!;

    final manager = $$ReceitasTableTableManager(
      $_db,
      $_db.receitas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receitaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ComboReceitasTableFilterComposer
    extends Composer<_$AppDatabase, $ComboReceitasTable> {
  $$ComboReceitasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  $$CombosTableFilterComposer get comboId {
    final $$CombosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableFilterComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceitasTableFilterComposer get receitaId {
    final $$ReceitasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableFilterComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComboReceitasTableOrderingComposer
    extends Composer<_$AppDatabase, $ComboReceitasTable> {
  $$ComboReceitasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );

  $$CombosTableOrderingComposer get comboId {
    final $$CombosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableOrderingComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceitasTableOrderingComposer get receitaId {
    final $$ReceitasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableOrderingComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComboReceitasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComboReceitasTable> {
  $$ComboReceitasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  $$CombosTableAnnotationComposer get comboId {
    final $$CombosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableAnnotationComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceitasTableAnnotationComposer get receitaId {
    final $$ReceitasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableAnnotationComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComboReceitasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComboReceitasTable,
          ComboReceita,
          $$ComboReceitasTableFilterComposer,
          $$ComboReceitasTableOrderingComposer,
          $$ComboReceitasTableAnnotationComposer,
          $$ComboReceitasTableCreateCompanionBuilder,
          $$ComboReceitasTableUpdateCompanionBuilder,
          (ComboReceita, $$ComboReceitasTableReferences),
          ComboReceita,
          PrefetchHooks Function({bool comboId, bool receitaId})
        > {
  $$ComboReceitasTableTableManager(_$AppDatabase db, $ComboReceitasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComboReceitasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComboReceitasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComboReceitasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> comboId = const Value.absent(),
                Value<int> receitaId = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComboReceitasCompanion(
                comboId: comboId,
                receitaId: receitaId,
                ordem: ordem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int comboId,
                required int receitaId,
                required int ordem,
                Value<int> rowid = const Value.absent(),
              }) => ComboReceitasCompanion.insert(
                comboId: comboId,
                receitaId: receitaId,
                ordem: ordem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ComboReceitasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comboId = false, receitaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (comboId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.comboId,
                                referencedTable: $$ComboReceitasTableReferences
                                    ._comboIdTable(db),
                                referencedColumn: $$ComboReceitasTableReferences
                                    ._comboIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (receitaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.receitaId,
                                referencedTable: $$ComboReceitasTableReferences
                                    ._receitaIdTable(db),
                                referencedColumn: $$ComboReceitasTableReferences
                                    ._receitaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ComboReceitasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComboReceitasTable,
      ComboReceita,
      $$ComboReceitasTableFilterComposer,
      $$ComboReceitasTableOrderingComposer,
      $$ComboReceitasTableAnnotationComposer,
      $$ComboReceitasTableCreateCompanionBuilder,
      $$ComboReceitasTableUpdateCompanionBuilder,
      (ComboReceita, $$ComboReceitasTableReferences),
      ComboReceita,
      PrefetchHooks Function({bool comboId, bool receitaId})
    >;
typedef $$CicloItensTableCreateCompanionBuilder =
    CicloItensCompanion Function({
      required int posicao,
      required TipoCombo tipoSlot,
      required int comboId,
      Value<int> rowid,
    });
typedef $$CicloItensTableUpdateCompanionBuilder =
    CicloItensCompanion Function({
      Value<int> posicao,
      Value<TipoCombo> tipoSlot,
      Value<int> comboId,
      Value<int> rowid,
    });

final class $$CicloItensTableReferences
    extends BaseReferences<_$AppDatabase, $CicloItensTable, CicloItem> {
  $$CicloItensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CombosTable _comboIdTable(_$AppDatabase db) =>
      db.combos.createAlias('ciclo_itens__combo_id__combos__id');

  $$CombosTableProcessedTableManager get comboId {
    final $_column = $_itemColumn<int>('combo_id')!;

    final manager = $$CombosTableTableManager(
      $_db,
      $_db.combos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_comboIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CicloItensTableFilterComposer
    extends Composer<_$AppDatabase, $CicloItensTable> {
  $$CicloItensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get posicao => $composableBuilder(
    column: $table.posicao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoCombo, TipoCombo, String> get tipoSlot =>
      $composableBuilder(
        column: $table.tipoSlot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$CombosTableFilterComposer get comboId {
    final $$CombosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableFilterComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CicloItensTableOrderingComposer
    extends Composer<_$AppDatabase, $CicloItensTable> {
  $$CicloItensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get posicao => $composableBuilder(
    column: $table.posicao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoSlot => $composableBuilder(
    column: $table.tipoSlot,
    builder: (column) => ColumnOrderings(column),
  );

  $$CombosTableOrderingComposer get comboId {
    final $$CombosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableOrderingComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CicloItensTableAnnotationComposer
    extends Composer<_$AppDatabase, $CicloItensTable> {
  $$CicloItensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get posicao =>
      $composableBuilder(column: $table.posicao, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoCombo, String> get tipoSlot =>
      $composableBuilder(column: $table.tipoSlot, builder: (column) => column);

  $$CombosTableAnnotationComposer get comboId {
    final $$CombosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableAnnotationComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CicloItensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CicloItensTable,
          CicloItem,
          $$CicloItensTableFilterComposer,
          $$CicloItensTableOrderingComposer,
          $$CicloItensTableAnnotationComposer,
          $$CicloItensTableCreateCompanionBuilder,
          $$CicloItensTableUpdateCompanionBuilder,
          (CicloItem, $$CicloItensTableReferences),
          CicloItem,
          PrefetchHooks Function({bool comboId})
        > {
  $$CicloItensTableTableManager(_$AppDatabase db, $CicloItensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CicloItensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CicloItensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CicloItensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> posicao = const Value.absent(),
                Value<TipoCombo> tipoSlot = const Value.absent(),
                Value<int> comboId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CicloItensCompanion(
                posicao: posicao,
                tipoSlot: tipoSlot,
                comboId: comboId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int posicao,
                required TipoCombo tipoSlot,
                required int comboId,
                Value<int> rowid = const Value.absent(),
              }) => CicloItensCompanion.insert(
                posicao: posicao,
                tipoSlot: tipoSlot,
                comboId: comboId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CicloItensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comboId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (comboId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.comboId,
                                referencedTable: $$CicloItensTableReferences
                                    ._comboIdTable(db),
                                referencedColumn: $$CicloItensTableReferences
                                    ._comboIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CicloItensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CicloItensTable,
      CicloItem,
      $$CicloItensTableFilterComposer,
      $$CicloItensTableOrderingComposer,
      $$CicloItensTableAnnotationComposer,
      $$CicloItensTableCreateCompanionBuilder,
      $$CicloItensTableUpdateCompanionBuilder,
      (CicloItem, $$CicloItensTableReferences),
      CicloItem,
      PrefetchHooks Function({bool comboId})
    >;
typedef $$ConfigTableCreateCompanionBuilder =
    ConfigCompanion Function({
      required String chave,
      required String valor,
      Value<int> rowid,
    });
typedef $$ConfigTableUpdateCompanionBuilder =
    ConfigCompanion Function({
      Value<String> chave,
      Value<String> valor,
      Value<int> rowid,
    });

class $$ConfigTableFilterComposer
    extends Composer<_$AppDatabase, $ConfigTable> {
  $$ConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfigTable> {
  $$ConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfigTable> {
  $$ConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chave =>
      $composableBuilder(column: $table.chave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$ConfigTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfigTable,
          ConfigLinha,
          $$ConfigTableFilterComposer,
          $$ConfigTableOrderingComposer,
          $$ConfigTableAnnotationComposer,
          $$ConfigTableCreateCompanionBuilder,
          $$ConfigTableUpdateCompanionBuilder,
          (
            ConfigLinha,
            BaseReferences<_$AppDatabase, $ConfigTable, ConfigLinha>,
          ),
          ConfigLinha,
          PrefetchHooks Function()
        > {
  $$ConfigTableTableManager(_$AppDatabase db, $ConfigTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> chave = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConfigCompanion(chave: chave, valor: valor, rowid: rowid),
          createCompanionCallback:
              ({
                required String chave,
                required String valor,
                Value<int> rowid = const Value.absent(),
              }) => ConfigCompanion.insert(
                chave: chave,
                valor: valor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfigTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfigTable,
      ConfigLinha,
      $$ConfigTableFilterComposer,
      $$ConfigTableOrderingComposer,
      $$ConfigTableAnnotationComposer,
      $$ConfigTableCreateCompanionBuilder,
      $$ConfigTableUpdateCompanionBuilder,
      (ConfigLinha, BaseReferences<_$AppDatabase, $ConfigTable, ConfigLinha>),
      ConfigLinha,
      PrefetchHooks Function()
    >;
typedef $$RegrasPorcaoTableCreateCompanionBuilder =
    RegrasPorcaoCompanion Function({
      required SlotRefeicao slot,
      required bool diaUtil,
      required int porcoes,
      Value<int> rowid,
    });
typedef $$RegrasPorcaoTableUpdateCompanionBuilder =
    RegrasPorcaoCompanion Function({
      Value<SlotRefeicao> slot,
      Value<bool> diaUtil,
      Value<int> porcoes,
      Value<int> rowid,
    });

class $$RegrasPorcaoTableFilterComposer
    extends Composer<_$AppDatabase, $RegrasPorcaoTable> {
  $$RegrasPorcaoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<SlotRefeicao, SlotRefeicao, String> get slot =>
      $composableBuilder(
        column: $table.slot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get diaUtil => $composableBuilder(
    column: $table.diaUtil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get porcoes => $composableBuilder(
    column: $table.porcoes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegrasPorcaoTableOrderingComposer
    extends Composer<_$AppDatabase, $RegrasPorcaoTable> {
  $$RegrasPorcaoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get diaUtil => $composableBuilder(
    column: $table.diaUtil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get porcoes => $composableBuilder(
    column: $table.porcoes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegrasPorcaoTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegrasPorcaoTable> {
  $$RegrasPorcaoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<SlotRefeicao, String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<bool> get diaUtil =>
      $composableBuilder(column: $table.diaUtil, builder: (column) => column);

  GeneratedColumn<int> get porcoes =>
      $composableBuilder(column: $table.porcoes, builder: (column) => column);
}

class $$RegrasPorcaoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegrasPorcaoTable,
          RegraPorcao,
          $$RegrasPorcaoTableFilterComposer,
          $$RegrasPorcaoTableOrderingComposer,
          $$RegrasPorcaoTableAnnotationComposer,
          $$RegrasPorcaoTableCreateCompanionBuilder,
          $$RegrasPorcaoTableUpdateCompanionBuilder,
          (
            RegraPorcao,
            BaseReferences<_$AppDatabase, $RegrasPorcaoTable, RegraPorcao>,
          ),
          RegraPorcao,
          PrefetchHooks Function()
        > {
  $$RegrasPorcaoTableTableManager(_$AppDatabase db, $RegrasPorcaoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegrasPorcaoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegrasPorcaoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegrasPorcaoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<SlotRefeicao> slot = const Value.absent(),
                Value<bool> diaUtil = const Value.absent(),
                Value<int> porcoes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegrasPorcaoCompanion(
                slot: slot,
                diaUtil: diaUtil,
                porcoes: porcoes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required SlotRefeicao slot,
                required bool diaUtil,
                required int porcoes,
                Value<int> rowid = const Value.absent(),
              }) => RegrasPorcaoCompanion.insert(
                slot: slot,
                diaUtil: diaUtil,
                porcoes: porcoes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegrasPorcaoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegrasPorcaoTable,
      RegraPorcao,
      $$RegrasPorcaoTableFilterComposer,
      $$RegrasPorcaoTableOrderingComposer,
      $$RegrasPorcaoTableAnnotationComposer,
      $$RegrasPorcaoTableCreateCompanionBuilder,
      $$RegrasPorcaoTableUpdateCompanionBuilder,
      (
        RegraPorcao,
        BaseReferences<_$AppDatabase, $RegrasPorcaoTable, RegraPorcao>,
      ),
      RegraPorcao,
      PrefetchHooks Function()
    >;
typedef $$OverridesComboTableCreateCompanionBuilder =
    OverridesComboCompanion Function({
      required DataPura data,
      required SlotRefeicao slot,
      required int comboId,
      Value<int> rowid,
    });
typedef $$OverridesComboTableUpdateCompanionBuilder =
    OverridesComboCompanion Function({
      Value<DataPura> data,
      Value<SlotRefeicao> slot,
      Value<int> comboId,
      Value<int> rowid,
    });

final class $$OverridesComboTableReferences
    extends BaseReferences<_$AppDatabase, $OverridesComboTable, OverrideCombo> {
  $$OverridesComboTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CombosTable _comboIdTable(_$AppDatabase db) =>
      db.combos.createAlias('overrides_combo__combo_id__combos__id');

  $$CombosTableProcessedTableManager get comboId {
    final $_column = $_itemColumn<int>('combo_id')!;

    final manager = $$CombosTableTableManager(
      $_db,
      $_db.combos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_comboIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OverridesComboTableFilterComposer
    extends Composer<_$AppDatabase, $OverridesComboTable> {
  $$OverridesComboTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DataPura, DataPura, String> get data =>
      $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SlotRefeicao, SlotRefeicao, String> get slot =>
      $composableBuilder(
        column: $table.slot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$CombosTableFilterComposer get comboId {
    final $$CombosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableFilterComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesComboTableOrderingComposer
    extends Composer<_$AppDatabase, $OverridesComboTable> {
  $$OverridesComboTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  $$CombosTableOrderingComposer get comboId {
    final $$CombosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableOrderingComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesComboTableAnnotationComposer
    extends Composer<_$AppDatabase, $OverridesComboTable> {
  $$OverridesComboTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DataPura, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SlotRefeicao, String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  $$CombosTableAnnotationComposer get comboId {
    final $$CombosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comboId,
      referencedTable: $db.combos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombosTableAnnotationComposer(
            $db: $db,
            $table: $db.combos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesComboTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OverridesComboTable,
          OverrideCombo,
          $$OverridesComboTableFilterComposer,
          $$OverridesComboTableOrderingComposer,
          $$OverridesComboTableAnnotationComposer,
          $$OverridesComboTableCreateCompanionBuilder,
          $$OverridesComboTableUpdateCompanionBuilder,
          (OverrideCombo, $$OverridesComboTableReferences),
          OverrideCombo,
          PrefetchHooks Function({bool comboId})
        > {
  $$OverridesComboTableTableManager(
    _$AppDatabase db,
    $OverridesComboTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OverridesComboTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OverridesComboTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OverridesComboTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DataPura> data = const Value.absent(),
                Value<SlotRefeicao> slot = const Value.absent(),
                Value<int> comboId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OverridesComboCompanion(
                data: data,
                slot: slot,
                comboId: comboId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DataPura data,
                required SlotRefeicao slot,
                required int comboId,
                Value<int> rowid = const Value.absent(),
              }) => OverridesComboCompanion.insert(
                data: data,
                slot: slot,
                comboId: comboId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OverridesComboTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comboId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (comboId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.comboId,
                                referencedTable: $$OverridesComboTableReferences
                                    ._comboIdTable(db),
                                referencedColumn:
                                    $$OverridesComboTableReferences
                                        ._comboIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OverridesComboTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OverridesComboTable,
      OverrideCombo,
      $$OverridesComboTableFilterComposer,
      $$OverridesComboTableOrderingComposer,
      $$OverridesComboTableAnnotationComposer,
      $$OverridesComboTableCreateCompanionBuilder,
      $$OverridesComboTableUpdateCompanionBuilder,
      (OverrideCombo, $$OverridesComboTableReferences),
      OverrideCombo,
      PrefetchHooks Function({bool comboId})
    >;
typedef $$OverridesComponenteTableCreateCompanionBuilder =
    OverridesComponenteCompanion Function({
      required DataPura data,
      required SlotRefeicao slot,
      required int receitaOriginalId,
      Value<int?> receitaNovaId,
      Value<int> rowid,
    });
typedef $$OverridesComponenteTableUpdateCompanionBuilder =
    OverridesComponenteCompanion Function({
      Value<DataPura> data,
      Value<SlotRefeicao> slot,
      Value<int> receitaOriginalId,
      Value<int?> receitaNovaId,
      Value<int> rowid,
    });

final class $$OverridesComponenteTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OverridesComponenteTable,
          OverrideComponente
        > {
  $$OverridesComponenteTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ReceitasTable _receitaOriginalIdTable(_$AppDatabase db) => db.receitas
      .createAlias('overrides_componente__receita_original_id__receitas__id');

  $$ReceitasTableProcessedTableManager get receitaOriginalId {
    final $_column = $_itemColumn<int>('receita_original_id')!;

    final manager = $$ReceitasTableTableManager(
      $_db,
      $_db.receitas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receitaOriginalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReceitasTable _receitaNovaIdTable(_$AppDatabase db) => db.receitas
      .createAlias('overrides_componente__receita_nova_id__receitas__id');

  $$ReceitasTableProcessedTableManager? get receitaNovaId {
    final $_column = $_itemColumn<int>('receita_nova_id');
    if ($_column == null) return null;
    final manager = $$ReceitasTableTableManager(
      $_db,
      $_db.receitas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receitaNovaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OverridesComponenteTableFilterComposer
    extends Composer<_$AppDatabase, $OverridesComponenteTable> {
  $$OverridesComponenteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DataPura, DataPura, String> get data =>
      $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SlotRefeicao, SlotRefeicao, String> get slot =>
      $composableBuilder(
        column: $table.slot,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$ReceitasTableFilterComposer get receitaOriginalId {
    final $$ReceitasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaOriginalId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableFilterComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceitasTableFilterComposer get receitaNovaId {
    final $$ReceitasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaNovaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableFilterComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesComponenteTableOrderingComposer
    extends Composer<_$AppDatabase, $OverridesComponenteTable> {
  $$OverridesComponenteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReceitasTableOrderingComposer get receitaOriginalId {
    final $$ReceitasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaOriginalId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableOrderingComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceitasTableOrderingComposer get receitaNovaId {
    final $$ReceitasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaNovaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableOrderingComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesComponenteTableAnnotationComposer
    extends Composer<_$AppDatabase, $OverridesComponenteTable> {
  $$OverridesComponenteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DataPura, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SlotRefeicao, String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  $$ReceitasTableAnnotationComposer get receitaOriginalId {
    final $$ReceitasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaOriginalId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableAnnotationComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceitasTableAnnotationComposer get receitaNovaId {
    final $$ReceitasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receitaNovaId,
      referencedTable: $db.receitas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceitasTableAnnotationComposer(
            $db: $db,
            $table: $db.receitas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OverridesComponenteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OverridesComponenteTable,
          OverrideComponente,
          $$OverridesComponenteTableFilterComposer,
          $$OverridesComponenteTableOrderingComposer,
          $$OverridesComponenteTableAnnotationComposer,
          $$OverridesComponenteTableCreateCompanionBuilder,
          $$OverridesComponenteTableUpdateCompanionBuilder,
          (OverrideComponente, $$OverridesComponenteTableReferences),
          OverrideComponente,
          PrefetchHooks Function({bool receitaOriginalId, bool receitaNovaId})
        > {
  $$OverridesComponenteTableTableManager(
    _$AppDatabase db,
    $OverridesComponenteTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OverridesComponenteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OverridesComponenteTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OverridesComponenteTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DataPura> data = const Value.absent(),
                Value<SlotRefeicao> slot = const Value.absent(),
                Value<int> receitaOriginalId = const Value.absent(),
                Value<int?> receitaNovaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OverridesComponenteCompanion(
                data: data,
                slot: slot,
                receitaOriginalId: receitaOriginalId,
                receitaNovaId: receitaNovaId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DataPura data,
                required SlotRefeicao slot,
                required int receitaOriginalId,
                Value<int?> receitaNovaId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OverridesComponenteCompanion.insert(
                data: data,
                slot: slot,
                receitaOriginalId: receitaOriginalId,
                receitaNovaId: receitaNovaId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OverridesComponenteTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({receitaOriginalId = false, receitaNovaId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (receitaOriginalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.receitaOriginalId,
                                    referencedTable:
                                        $$OverridesComponenteTableReferences
                                            ._receitaOriginalIdTable(db),
                                    referencedColumn:
                                        $$OverridesComponenteTableReferences
                                            ._receitaOriginalIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (receitaNovaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.receitaNovaId,
                                    referencedTable:
                                        $$OverridesComponenteTableReferences
                                            ._receitaNovaIdTable(db),
                                    referencedColumn:
                                        $$OverridesComponenteTableReferences
                                            ._receitaNovaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$OverridesComponenteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OverridesComponenteTable,
      OverrideComponente,
      $$OverridesComponenteTableFilterComposer,
      $$OverridesComponenteTableOrderingComposer,
      $$OverridesComponenteTableAnnotationComposer,
      $$OverridesComponenteTableCreateCompanionBuilder,
      $$OverridesComponenteTableUpdateCompanionBuilder,
      (OverrideComponente, $$OverridesComponenteTableReferences),
      OverrideComponente,
      PrefetchHooks Function({bool receitaOriginalId, bool receitaNovaId})
    >;
typedef $$ListasCompraTableCreateCompanionBuilder =
    ListasCompraCompanion Function({
      Value<int> id,
      required DataPura dataInicio,
      required DataPura dataFim,
      required DateTime criadaEm,
    });
typedef $$ListasCompraTableUpdateCompanionBuilder =
    ListasCompraCompanion Function({
      Value<int> id,
      Value<DataPura> dataInicio,
      Value<DataPura> dataFim,
      Value<DateTime> criadaEm,
    });

final class $$ListasCompraTableReferences
    extends BaseReferences<_$AppDatabase, $ListasCompraTable, ListaCompra> {
  $$ListasCompraTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ListaCompraItensTable, List<ListaCompraItem>>
  _listaCompraItensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.listaCompraItens,
    aliasName: 'listas_compra__id__lista_compra_itens__lista_id',
  );

  $$ListaCompraItensTableProcessedTableManager get listaCompraItensRefs {
    final manager = $$ListaCompraItensTableTableManager(
      $_db,
      $_db.listaCompraItens,
    ).filter((f) => f.listaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _listaCompraItensRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ListasCompraTableFilterComposer
    extends Composer<_$AppDatabase, $ListasCompraTable> {
  $$ListasCompraTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DataPura, DataPura, String> get dataInicio =>
      $composableBuilder(
        column: $table.dataInicio,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DataPura, DataPura, String> get dataFim =>
      $composableBuilder(
        column: $table.dataFim,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get criadaEm => $composableBuilder(
    column: $table.criadaEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> listaCompraItensRefs(
    Expression<bool> Function($$ListaCompraItensTableFilterComposer f) f,
  ) {
    final $$ListaCompraItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listaCompraItens,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListaCompraItensTableFilterComposer(
            $db: $db,
            $table: $db.listaCompraItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListasCompraTableOrderingComposer
    extends Composer<_$AppDatabase, $ListasCompraTable> {
  $$ListasCompraTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataInicio => $composableBuilder(
    column: $table.dataInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataFim => $composableBuilder(
    column: $table.dataFim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadaEm => $composableBuilder(
    column: $table.criadaEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListasCompraTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListasCompraTable> {
  $$ListasCompraTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DataPura, String> get dataInicio =>
      $composableBuilder(
        column: $table.dataInicio,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DataPura, String> get dataFim =>
      $composableBuilder(column: $table.dataFim, builder: (column) => column);

  GeneratedColumn<DateTime> get criadaEm =>
      $composableBuilder(column: $table.criadaEm, builder: (column) => column);

  Expression<T> listaCompraItensRefs<T extends Object>(
    Expression<T> Function($$ListaCompraItensTableAnnotationComposer a) f,
  ) {
    final $$ListaCompraItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listaCompraItens,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListaCompraItensTableAnnotationComposer(
            $db: $db,
            $table: $db.listaCompraItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListasCompraTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListasCompraTable,
          ListaCompra,
          $$ListasCompraTableFilterComposer,
          $$ListasCompraTableOrderingComposer,
          $$ListasCompraTableAnnotationComposer,
          $$ListasCompraTableCreateCompanionBuilder,
          $$ListasCompraTableUpdateCompanionBuilder,
          (ListaCompra, $$ListasCompraTableReferences),
          ListaCompra,
          PrefetchHooks Function({bool listaCompraItensRefs})
        > {
  $$ListasCompraTableTableManager(_$AppDatabase db, $ListasCompraTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListasCompraTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListasCompraTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListasCompraTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DataPura> dataInicio = const Value.absent(),
                Value<DataPura> dataFim = const Value.absent(),
                Value<DateTime> criadaEm = const Value.absent(),
              }) => ListasCompraCompanion(
                id: id,
                dataInicio: dataInicio,
                dataFim: dataFim,
                criadaEm: criadaEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DataPura dataInicio,
                required DataPura dataFim,
                required DateTime criadaEm,
              }) => ListasCompraCompanion.insert(
                id: id,
                dataInicio: dataInicio,
                dataFim: dataFim,
                criadaEm: criadaEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ListasCompraTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listaCompraItensRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (listaCompraItensRefs) db.listaCompraItens,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listaCompraItensRefs)
                    await $_getPrefetchedData<
                      ListaCompra,
                      $ListasCompraTable,
                      ListaCompraItem
                    >(
                      currentTable: table,
                      referencedTable: $$ListasCompraTableReferences
                          ._listaCompraItensRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ListasCompraTableReferences(
                            db,
                            table,
                            p0,
                          ).listaCompraItensRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ListasCompraTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListasCompraTable,
      ListaCompra,
      $$ListasCompraTableFilterComposer,
      $$ListasCompraTableOrderingComposer,
      $$ListasCompraTableAnnotationComposer,
      $$ListasCompraTableCreateCompanionBuilder,
      $$ListasCompraTableUpdateCompanionBuilder,
      (ListaCompra, $$ListasCompraTableReferences),
      ListaCompra,
      PrefetchHooks Function({bool listaCompraItensRefs})
    >;
typedef $$ListaCompraItensTableCreateCompanionBuilder =
    ListaCompraItensCompanion Function({
      required int listaId,
      required int alimentoId,
      required double quantidadeG,
      Value<bool> marcado,
      Value<int> rowid,
    });
typedef $$ListaCompraItensTableUpdateCompanionBuilder =
    ListaCompraItensCompanion Function({
      Value<int> listaId,
      Value<int> alimentoId,
      Value<double> quantidadeG,
      Value<bool> marcado,
      Value<int> rowid,
    });

final class $$ListaCompraItensTableReferences
    extends
        BaseReferences<_$AppDatabase, $ListaCompraItensTable, ListaCompraItem> {
  $$ListaCompraItensTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ListasCompraTable _listaIdTable(_$AppDatabase db) => db.listasCompra
      .createAlias('lista_compra_itens__lista_id__listas_compra__id');

  $$ListasCompraTableProcessedTableManager get listaId {
    final $_column = $_itemColumn<int>('lista_id')!;

    final manager = $$ListasCompraTableTableManager(
      $_db,
      $_db.listasCompra,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AlimentosTable _alimentoIdTable(_$AppDatabase db) => db.alimentos
      .createAlias('lista_compra_itens__alimento_id__alimentos__id');

  $$AlimentosTableProcessedTableManager get alimentoId {
    final $_column = $_itemColumn<int>('alimento_id')!;

    final manager = $$AlimentosTableTableManager(
      $_db,
      $_db.alimentos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alimentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ListaCompraItensTableFilterComposer
    extends Composer<_$AppDatabase, $ListaCompraItensTable> {
  $$ListaCompraItensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get quantidadeG => $composableBuilder(
    column: $table.quantidadeG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get marcado => $composableBuilder(
    column: $table.marcado,
    builder: (column) => ColumnFilters(column),
  );

  $$ListasCompraTableFilterComposer get listaId {
    final $$ListasCompraTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listasCompra,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasCompraTableFilterComposer(
            $db: $db,
            $table: $db.listasCompra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableFilterComposer get alimentoId {
    final $$AlimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableFilterComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListaCompraItensTableOrderingComposer
    extends Composer<_$AppDatabase, $ListaCompraItensTable> {
  $$ListaCompraItensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get quantidadeG => $composableBuilder(
    column: $table.quantidadeG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get marcado => $composableBuilder(
    column: $table.marcado,
    builder: (column) => ColumnOrderings(column),
  );

  $$ListasCompraTableOrderingComposer get listaId {
    final $$ListasCompraTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listasCompra,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasCompraTableOrderingComposer(
            $db: $db,
            $table: $db.listasCompra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableOrderingComposer get alimentoId {
    final $$AlimentosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableOrderingComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListaCompraItensTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListaCompraItensTable> {
  $$ListaCompraItensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get quantidadeG => $composableBuilder(
    column: $table.quantidadeG,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get marcado =>
      $composableBuilder(column: $table.marcado, builder: (column) => column);

  $$ListasCompraTableAnnotationComposer get listaId {
    final $$ListasCompraTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listasCompra,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasCompraTableAnnotationComposer(
            $db: $db,
            $table: $db.listasCompra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AlimentosTableAnnotationComposer get alimentoId {
    final $$AlimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alimentoId,
      referencedTable: $db.alimentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.alimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListaCompraItensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListaCompraItensTable,
          ListaCompraItem,
          $$ListaCompraItensTableFilterComposer,
          $$ListaCompraItensTableOrderingComposer,
          $$ListaCompraItensTableAnnotationComposer,
          $$ListaCompraItensTableCreateCompanionBuilder,
          $$ListaCompraItensTableUpdateCompanionBuilder,
          (ListaCompraItem, $$ListaCompraItensTableReferences),
          ListaCompraItem,
          PrefetchHooks Function({bool listaId, bool alimentoId})
        > {
  $$ListaCompraItensTableTableManager(
    _$AppDatabase db,
    $ListaCompraItensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListaCompraItensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListaCompraItensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListaCompraItensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> listaId = const Value.absent(),
                Value<int> alimentoId = const Value.absent(),
                Value<double> quantidadeG = const Value.absent(),
                Value<bool> marcado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListaCompraItensCompanion(
                listaId: listaId,
                alimentoId: alimentoId,
                quantidadeG: quantidadeG,
                marcado: marcado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int listaId,
                required int alimentoId,
                required double quantidadeG,
                Value<bool> marcado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListaCompraItensCompanion.insert(
                listaId: listaId,
                alimentoId: alimentoId,
                quantidadeG: quantidadeG,
                marcado: marcado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ListaCompraItensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listaId = false, alimentoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listaId,
                                referencedTable:
                                    $$ListaCompraItensTableReferences
                                        ._listaIdTable(db),
                                referencedColumn:
                                    $$ListaCompraItensTableReferences
                                        ._listaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (alimentoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.alimentoId,
                                referencedTable:
                                    $$ListaCompraItensTableReferences
                                        ._alimentoIdTable(db),
                                referencedColumn:
                                    $$ListaCompraItensTableReferences
                                        ._alimentoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ListaCompraItensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListaCompraItensTable,
      ListaCompraItem,
      $$ListaCompraItensTableFilterComposer,
      $$ListaCompraItensTableOrderingComposer,
      $$ListaCompraItensTableAnnotationComposer,
      $$ListaCompraItensTableCreateCompanionBuilder,
      $$ListaCompraItensTableUpdateCompanionBuilder,
      (ListaCompraItem, $$ListaCompraItensTableReferences),
      ListaCompraItem,
      PrefetchHooks Function({bool listaId, bool alimentoId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AlimentosTableTableManager get alimentos =>
      $$AlimentosTableTableManager(_db, _db.alimentos);
  $$ConversoesTableTableManager get conversoes =>
      $$ConversoesTableTableManager(_db, _db.conversoes);
  $$ReceitasTableTableManager get receitas =>
      $$ReceitasTableTableManager(_db, _db.receitas);
  $$ReceitaIngredientesTableTableManager get receitaIngredientes =>
      $$ReceitaIngredientesTableTableManager(_db, _db.receitaIngredientes);
  $$CombosTableTableManager get combos =>
      $$CombosTableTableManager(_db, _db.combos);
  $$ComboReceitasTableTableManager get comboReceitas =>
      $$ComboReceitasTableTableManager(_db, _db.comboReceitas);
  $$CicloItensTableTableManager get cicloItens =>
      $$CicloItensTableTableManager(_db, _db.cicloItens);
  $$ConfigTableTableManager get config =>
      $$ConfigTableTableManager(_db, _db.config);
  $$RegrasPorcaoTableTableManager get regrasPorcao =>
      $$RegrasPorcaoTableTableManager(_db, _db.regrasPorcao);
  $$OverridesComboTableTableManager get overridesCombo =>
      $$OverridesComboTableTableManager(_db, _db.overridesCombo);
  $$OverridesComponenteTableTableManager get overridesComponente =>
      $$OverridesComponenteTableTableManager(_db, _db.overridesComponente);
  $$ListasCompraTableTableManager get listasCompra =>
      $$ListasCompraTableTableManager(_db, _db.listasCompra);
  $$ListaCompraItensTableTableManager get listaCompraItens =>
      $$ListaCompraItensTableTableManager(_db, _db.listaCompraItens);
}
