// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MomentTableTable extends MomentTable
    with TableInfo<$MomentTableTable, MomentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MomentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reflectionMeta =
      const VerificationMeta('reflection');
  @override
  late final GeneratedColumn<String> reflection = GeneratedColumn<String>(
      'reflection', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, reflection, date, modifiedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moment_table';
  @override
  VerificationContext validateIntegrity(Insertable<MomentTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reflection')) {
      context.handle(
          _reflectionMeta,
          reflection.isAcceptableOrUnknown(
              data['reflection']!, _reflectionMeta));
    } else if (isInserting) {
      context.missing(_reflectionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MomentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MomentTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reflection: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reflection'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at'])!,
    );
  }

  @override
  $MomentTableTable createAlias(String alias) {
    return $MomentTableTable(attachedDatabase, alias);
  }
}

class MomentTableData extends DataClass implements Insertable<MomentTableData> {
  final String id;
  final String reflection;
  final DateTime date;
  final DateTime modifiedAt;
  const MomentTableData(
      {required this.id,
      required this.reflection,
      required this.date,
      required this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reflection'] = Variable<String>(reflection);
    map['date'] = Variable<DateTime>(date);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    return map;
  }

  MomentTableCompanion toCompanion(bool nullToAbsent) {
    return MomentTableCompanion(
      id: Value(id),
      reflection: Value(reflection),
      date: Value(date),
      modifiedAt: Value(modifiedAt),
    );
  }

  factory MomentTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MomentTableData(
      id: serializer.fromJson<String>(json['id']),
      reflection: serializer.fromJson<String>(json['reflection']),
      date: serializer.fromJson<DateTime>(json['date']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reflection': serializer.toJson<String>(reflection),
      'date': serializer.toJson<DateTime>(date),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
    };
  }

  MomentTableData copyWith(
          {String? id,
          String? reflection,
          DateTime? date,
          DateTime? modifiedAt}) =>
      MomentTableData(
        id: id ?? this.id,
        reflection: reflection ?? this.reflection,
        date: date ?? this.date,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );
  MomentTableData copyWithCompanion(MomentTableCompanion data) {
    return MomentTableData(
      id: data.id.present ? data.id.value : this.id,
      reflection:
          data.reflection.present ? data.reflection.value : this.reflection,
      date: data.date.present ? data.date.value : this.date,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MomentTableData(')
          ..write('id: $id, ')
          ..write('reflection: $reflection, ')
          ..write('date: $date, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, reflection, date, modifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MomentTableData &&
          other.id == this.id &&
          other.reflection == this.reflection &&
          other.date == this.date &&
          other.modifiedAt == this.modifiedAt);
}

class MomentTableCompanion extends UpdateCompanion<MomentTableData> {
  final Value<String> id;
  final Value<String> reflection;
  final Value<DateTime> date;
  final Value<DateTime> modifiedAt;
  final Value<int> rowid;
  const MomentTableCompanion({
    this.id = const Value.absent(),
    this.reflection = const Value.absent(),
    this.date = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MomentTableCompanion.insert({
    required String id,
    required String reflection,
    required DateTime date,
    required DateTime modifiedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reflection = Value(reflection),
        date = Value(date),
        modifiedAt = Value(modifiedAt);
  static Insertable<MomentTableData> custom({
    Expression<String>? id,
    Expression<String>? reflection,
    Expression<DateTime>? date,
    Expression<DateTime>? modifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reflection != null) 'reflection': reflection,
      if (date != null) 'date': date,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MomentTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? reflection,
      Value<DateTime>? date,
      Value<DateTime>? modifiedAt,
      Value<int>? rowid}) {
    return MomentTableCompanion(
      id: id ?? this.id,
      reflection: reflection ?? this.reflection,
      date: date ?? this.date,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reflection.present) {
      map['reflection'] = Variable<String>(reflection.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MomentTableCompanion(')
          ..write('id: $id, ')
          ..write('reflection: $reflection, ')
          ..write('date: $date, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmotionalIntensityTableTable extends EmotionalIntensityTable
    with TableInfo<$EmotionalIntensityTableTable, EmotionalIntensityTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmotionalIntensityTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Emotion, String> emotion =
      GeneratedColumn<String>('emotion', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Emotion>(
              $EmotionalIntensityTableTable.$converteremotion);
  static const VerificationMeta _intensityMeta =
      const VerificationMeta('intensity');
  @override
  late final GeneratedColumn<double> intensity = GeneratedColumn<double>(
      'intensity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _momentIdMeta =
      const VerificationMeta('momentId');
  @override
  late final GeneratedColumn<String> momentId = GeneratedColumn<String>(
      'moment_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES moment_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, emotion, intensity, momentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emotional_intensity_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EmotionalIntensityTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(_intensityMeta,
          intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta));
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('moment_id')) {
      context.handle(_momentIdMeta,
          momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta));
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmotionalIntensityTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmotionalIntensityTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      emotion: $EmotionalIntensityTableTable.$converteremotion.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}emotion'])!),
      intensity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}intensity'])!,
      momentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}moment_id'])!,
    );
  }

  @override
  $EmotionalIntensityTableTable createAlias(String alias) {
    return $EmotionalIntensityTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Emotion, String, String> $converteremotion =
      const EnumNameConverter<Emotion>(Emotion.values);
}

class EmotionalIntensityTableData extends DataClass
    implements Insertable<EmotionalIntensityTableData> {
  final String id;
  final Emotion emotion;
  final double intensity;
  final String momentId;
  const EmotionalIntensityTableData(
      {required this.id,
      required this.emotion,
      required this.intensity,
      required this.momentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['emotion'] = Variable<String>(
          $EmotionalIntensityTableTable.$converteremotion.toSql(emotion));
    }
    map['intensity'] = Variable<double>(intensity);
    map['moment_id'] = Variable<String>(momentId);
    return map;
  }

  EmotionalIntensityTableCompanion toCompanion(bool nullToAbsent) {
    return EmotionalIntensityTableCompanion(
      id: Value(id),
      emotion: Value(emotion),
      intensity: Value(intensity),
      momentId: Value(momentId),
    );
  }

  factory EmotionalIntensityTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmotionalIntensityTableData(
      id: serializer.fromJson<String>(json['id']),
      emotion: $EmotionalIntensityTableTable.$converteremotion
          .fromJson(serializer.fromJson<String>(json['emotion'])),
      intensity: serializer.fromJson<double>(json['intensity']),
      momentId: serializer.fromJson<String>(json['momentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'emotion': serializer.toJson<String>(
          $EmotionalIntensityTableTable.$converteremotion.toJson(emotion)),
      'intensity': serializer.toJson<double>(intensity),
      'momentId': serializer.toJson<String>(momentId),
    };
  }

  EmotionalIntensityTableData copyWith(
          {String? id,
          Emotion? emotion,
          double? intensity,
          String? momentId}) =>
      EmotionalIntensityTableData(
        id: id ?? this.id,
        emotion: emotion ?? this.emotion,
        intensity: intensity ?? this.intensity,
        momentId: momentId ?? this.momentId,
      );
  EmotionalIntensityTableData copyWithCompanion(
      EmotionalIntensityTableCompanion data) {
    return EmotionalIntensityTableData(
      id: data.id.present ? data.id.value : this.id,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmotionalIntensityTableData(')
          ..write('id: $id, ')
          ..write('emotion: $emotion, ')
          ..write('intensity: $intensity, ')
          ..write('momentId: $momentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, emotion, intensity, momentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmotionalIntensityTableData &&
          other.id == this.id &&
          other.emotion == this.emotion &&
          other.intensity == this.intensity &&
          other.momentId == this.momentId);
}

class EmotionalIntensityTableCompanion
    extends UpdateCompanion<EmotionalIntensityTableData> {
  final Value<String> id;
  final Value<Emotion> emotion;
  final Value<double> intensity;
  final Value<String> momentId;
  final Value<int> rowid;
  const EmotionalIntensityTableCompanion({
    this.id = const Value.absent(),
    this.emotion = const Value.absent(),
    this.intensity = const Value.absent(),
    this.momentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmotionalIntensityTableCompanion.insert({
    required String id,
    required Emotion emotion,
    required double intensity,
    required String momentId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        emotion = Value(emotion),
        intensity = Value(intensity),
        momentId = Value(momentId);
  static Insertable<EmotionalIntensityTableData> custom({
    Expression<String>? id,
    Expression<String>? emotion,
    Expression<double>? intensity,
    Expression<String>? momentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (emotion != null) 'emotion': emotion,
      if (intensity != null) 'intensity': intensity,
      if (momentId != null) 'moment_id': momentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmotionalIntensityTableCompanion copyWith(
      {Value<String>? id,
      Value<Emotion>? emotion,
      Value<double>? intensity,
      Value<String>? momentId,
      Value<int>? rowid}) {
    return EmotionalIntensityTableCompanion(
      id: id ?? this.id,
      emotion: emotion ?? this.emotion,
      intensity: intensity ?? this.intensity,
      momentId: momentId ?? this.momentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<String>(
          $EmotionalIntensityTableTable.$converteremotion.toSql(emotion.value));
    }
    if (intensity.present) {
      map['intensity'] = Variable<double>(intensity.value);
    }
    if (momentId.present) {
      map['moment_id'] = Variable<String>(momentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmotionalIntensityTableCompanion(')
          ..write('id: $id, ')
          ..write('emotion: $emotion, ')
          ..write('intensity: $intensity, ')
          ..write('momentId: $momentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaTableTable extends MediaTable
    with TableInfo<$MediaTableTable, MediaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _momentIdMeta =
      const VerificationMeta('momentId');
  @override
  late final GeneratedColumn<String> momentId = GeneratedColumn<String>(
      'moment_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES moment_table (id)'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<Uint8List> data = GeneratedColumn<Uint8List>(
      'data', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, momentId, data, mimeType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_table';
  @override
  VerificationContext validateIntegrity(Insertable<MediaTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('moment_id')) {
      context.handle(_momentIdMeta,
          momentId.isAcceptableOrUnknown(data['moment_id']!, _momentIdMeta));
    } else if (isInserting) {
      context.missing(_momentIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      momentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}moment_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}data'])!,
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MediaTableTable createAlias(String alias) {
    return $MediaTableTable(attachedDatabase, alias);
  }
}

class MediaTableData extends DataClass implements Insertable<MediaTableData> {
  final String id;
  final String momentId;
  final Uint8List data;
  final String mimeType;
  final DateTime createdAt;
  const MediaTableData(
      {required this.id,
      required this.momentId,
      required this.data,
      required this.mimeType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['moment_id'] = Variable<String>(momentId);
    map['data'] = Variable<Uint8List>(data);
    map['mime_type'] = Variable<String>(mimeType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MediaTableCompanion toCompanion(bool nullToAbsent) {
    return MediaTableCompanion(
      id: Value(id),
      momentId: Value(momentId),
      data: Value(data),
      mimeType: Value(mimeType),
      createdAt: Value(createdAt),
    );
  }

  factory MediaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaTableData(
      id: serializer.fromJson<String>(json['id']),
      momentId: serializer.fromJson<String>(json['momentId']),
      data: serializer.fromJson<Uint8List>(json['data']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'momentId': serializer.toJson<String>(momentId),
      'data': serializer.toJson<Uint8List>(data),
      'mimeType': serializer.toJson<String>(mimeType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MediaTableData copyWith(
          {String? id,
          String? momentId,
          Uint8List? data,
          String? mimeType,
          DateTime? createdAt}) =>
      MediaTableData(
        id: id ?? this.id,
        momentId: momentId ?? this.momentId,
        data: data ?? this.data,
        mimeType: mimeType ?? this.mimeType,
        createdAt: createdAt ?? this.createdAt,
      );
  MediaTableData copyWithCompanion(MediaTableCompanion data) {
    return MediaTableData(
      id: data.id.present ? data.id.value : this.id,
      momentId: data.momentId.present ? data.momentId.value : this.momentId,
      data: data.data.present ? data.data.value : this.data,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaTableData(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('data: $data, ')
          ..write('mimeType: $mimeType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, momentId, $driftBlobEquality.hash(data), mimeType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaTableData &&
          other.id == this.id &&
          other.momentId == this.momentId &&
          $driftBlobEquality.equals(other.data, this.data) &&
          other.mimeType == this.mimeType &&
          other.createdAt == this.createdAt);
}

class MediaTableCompanion extends UpdateCompanion<MediaTableData> {
  final Value<String> id;
  final Value<String> momentId;
  final Value<Uint8List> data;
  final Value<String> mimeType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MediaTableCompanion({
    this.id = const Value.absent(),
    this.momentId = const Value.absent(),
    this.data = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaTableCompanion.insert({
    required String id,
    required String momentId,
    required Uint8List data,
    required String mimeType,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        momentId = Value(momentId),
        data = Value(data),
        mimeType = Value(mimeType),
        createdAt = Value(createdAt);
  static Insertable<MediaTableData> custom({
    Expression<String>? id,
    Expression<String>? momentId,
    Expression<Uint8List>? data,
    Expression<String>? mimeType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (momentId != null) 'moment_id': momentId,
      if (data != null) 'data': data,
      if (mimeType != null) 'mime_type': mimeType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? momentId,
      Value<Uint8List>? data,
      Value<String>? mimeType,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MediaTableCompanion(
      id: id ?? this.id,
      momentId: momentId ?? this.momentId,
      data: data ?? this.data,
      mimeType: mimeType ?? this.mimeType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (momentId.present) {
      map['moment_id'] = Variable<String>(momentId.value);
    }
    if (data.present) {
      map['data'] = Variable<Uint8List>(data.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaTableCompanion(')
          ..write('id: $id, ')
          ..write('momentId: $momentId, ')
          ..write('data: $data, ')
          ..write('mimeType: $mimeType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileImageUrlMeta =
      const VerificationMeta('profileImageUrl');
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
      'profile_image_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, username, profileImageUrl, email];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
          _profileImageUrlMeta,
          profileImageUrl.isAcceptableOrUnknown(
              data['profile_image_url']!, _profileImageUrlMeta));
    } else if (isInserting) {
      context.missing(_profileImageUrlMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      profileImageUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}profile_image_url'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final String id;
  final String username;
  final String profileImageUrl;
  final String email;
  const UserTableData(
      {required this.id,
      required this.username,
      required this.profileImageUrl,
      required this.email});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['profile_image_url'] = Variable<String>(profileImageUrl);
    map['email'] = Variable<String>(email);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      username: Value(username),
      profileImageUrl: Value(profileImageUrl),
      email: Value(email),
    );
  }

  factory UserTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      profileImageUrl: serializer.fromJson<String>(json['profileImageUrl']),
      email: serializer.fromJson<String>(json['email']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'profileImageUrl': serializer.toJson<String>(profileImageUrl),
      'email': serializer.toJson<String>(email),
    };
  }

  UserTableData copyWith(
          {String? id,
          String? username,
          String? profileImageUrl,
          String? email}) =>
      UserTableData(
        id: id ?? this.id,
        username: username ?? this.username,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        email: email ?? this.email,
      );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      email: data.email.present ? data.email.value : this.email,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, profileImageUrl, email);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.username == this.username &&
          other.profileImageUrl == this.profileImageUrl &&
          other.email == this.email);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> profileImageUrl;
  final Value<String> email;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.email = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String id,
    required String username,
    required String profileImageUrl,
    required String email,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        profileImageUrl = Value(profileImageUrl),
        email = Value(email);
  static Insertable<UserTableData> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? profileImageUrl,
    Expression<String>? email,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (email != null) 'email': email,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? profileImageUrl,
      Value<String>? email,
      Value<int>? rowid}) {
    return UserTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      email: email ?? this.email,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('email: $email, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $MomentTableTable momentTable = $MomentTableTable(this);
  late final $EmotionalIntensityTableTable emotionalIntensityTable =
      $EmotionalIntensityTableTable(this);
  late final $MediaTableTable mediaTable = $MediaTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [momentTable, emotionalIntensityTable, mediaTable, userTable];
}

typedef $$MomentTableTableCreateCompanionBuilder = MomentTableCompanion
    Function({
  required String id,
  required String reflection,
  required DateTime date,
  required DateTime modifiedAt,
  Value<int> rowid,
});
typedef $$MomentTableTableUpdateCompanionBuilder = MomentTableCompanion
    Function({
  Value<String> id,
  Value<String> reflection,
  Value<DateTime> date,
  Value<DateTime> modifiedAt,
  Value<int> rowid,
});

final class $$MomentTableTableReferences
    extends BaseReferences<_$Database, $MomentTableTable, MomentTableData> {
  $$MomentTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmotionalIntensityTableTable,
      List<EmotionalIntensityTableData>> _emotionalIntensityTableRefsTable(
          _$Database db) =>
      MultiTypedResultKey.fromTable(db.emotionalIntensityTable,
          aliasName: $_aliasNameGenerator(
              db.momentTable.id, db.emotionalIntensityTable.momentId));

  $$EmotionalIntensityTableTableProcessedTableManager
      get emotionalIntensityTableRefs {
    final manager = $$EmotionalIntensityTableTableTableManager(
            $_db, $_db.emotionalIntensityTable)
        .filter((f) => f.momentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_emotionalIntensityTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MediaTableTable, List<MediaTableData>>
      _mediaTableRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
          db.mediaTable,
          aliasName:
              $_aliasNameGenerator(db.momentTable.id, db.mediaTable.momentId));

  $$MediaTableTableProcessedTableManager get mediaTableRefs {
    final manager = $$MediaTableTableTableManager($_db, $_db.mediaTable)
        .filter((f) => f.momentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mediaTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MomentTableTableFilterComposer
    extends Composer<_$Database, $MomentTableTable> {
  $$MomentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reflection => $composableBuilder(
      column: $table.reflection, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> emotionalIntensityTableRefs(
      Expression<bool> Function($$EmotionalIntensityTableTableFilterComposer f)
          f) {
    final $$EmotionalIntensityTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.emotionalIntensityTable,
            getReferencedColumn: (t) => t.momentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EmotionalIntensityTableTableFilterComposer(
                  $db: $db,
                  $table: $db.emotionalIntensityTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> mediaTableRefs(
      Expression<bool> Function($$MediaTableTableFilterComposer f) f) {
    final $$MediaTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mediaTable,
        getReferencedColumn: (t) => t.momentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MediaTableTableFilterComposer(
              $db: $db,
              $table: $db.mediaTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MomentTableTableOrderingComposer
    extends Composer<_$Database, $MomentTableTable> {
  $$MomentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reflection => $composableBuilder(
      column: $table.reflection, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));
}

class $$MomentTableTableAnnotationComposer
    extends Composer<_$Database, $MomentTableTable> {
  $$MomentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reflection => $composableBuilder(
      column: $table.reflection, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  Expression<T> emotionalIntensityTableRefs<T extends Object>(
      Expression<T> Function($$EmotionalIntensityTableTableAnnotationComposer a)
          f) {
    final $$EmotionalIntensityTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.emotionalIntensityTable,
            getReferencedColumn: (t) => t.momentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EmotionalIntensityTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.emotionalIntensityTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> mediaTableRefs<T extends Object>(
      Expression<T> Function($$MediaTableTableAnnotationComposer a) f) {
    final $$MediaTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mediaTable,
        getReferencedColumn: (t) => t.momentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MediaTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mediaTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MomentTableTableTableManager extends RootTableManager<
    _$Database,
    $MomentTableTable,
    MomentTableData,
    $$MomentTableTableFilterComposer,
    $$MomentTableTableOrderingComposer,
    $$MomentTableTableAnnotationComposer,
    $$MomentTableTableCreateCompanionBuilder,
    $$MomentTableTableUpdateCompanionBuilder,
    (MomentTableData, $$MomentTableTableReferences),
    MomentTableData,
    PrefetchHooks Function(
        {bool emotionalIntensityTableRefs, bool mediaTableRefs})> {
  $$MomentTableTableTableManager(_$Database db, $MomentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MomentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MomentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MomentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> reflection = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> modifiedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MomentTableCompanion(
            id: id,
            reflection: reflection,
            date: date,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String reflection,
            required DateTime date,
            required DateTime modifiedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MomentTableCompanion.insert(
            id: id,
            reflection: reflection,
            date: date,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MomentTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {emotionalIntensityTableRefs = false, mediaTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (emotionalIntensityTableRefs) db.emotionalIntensityTable,
                if (mediaTableRefs) db.mediaTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (emotionalIntensityTableRefs)
                    await $_getPrefetchedData<MomentTableData,
                            $MomentTableTable, EmotionalIntensityTableData>(
                        currentTable: table,
                        referencedTable: $$MomentTableTableReferences
                            ._emotionalIntensityTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MomentTableTableReferences(db, table, p0)
                                .emotionalIntensityTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.momentId == item.id),
                        typedResults: items),
                  if (mediaTableRefs)
                    await $_getPrefetchedData<MomentTableData,
                            $MomentTableTable, MediaTableData>(
                        currentTable: table,
                        referencedTable: $$MomentTableTableReferences
                            ._mediaTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MomentTableTableReferences(db, table, p0)
                                .mediaTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.momentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MomentTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $MomentTableTable,
    MomentTableData,
    $$MomentTableTableFilterComposer,
    $$MomentTableTableOrderingComposer,
    $$MomentTableTableAnnotationComposer,
    $$MomentTableTableCreateCompanionBuilder,
    $$MomentTableTableUpdateCompanionBuilder,
    (MomentTableData, $$MomentTableTableReferences),
    MomentTableData,
    PrefetchHooks Function(
        {bool emotionalIntensityTableRefs, bool mediaTableRefs})>;
typedef $$EmotionalIntensityTableTableCreateCompanionBuilder
    = EmotionalIntensityTableCompanion Function({
  required String id,
  required Emotion emotion,
  required double intensity,
  required String momentId,
  Value<int> rowid,
});
typedef $$EmotionalIntensityTableTableUpdateCompanionBuilder
    = EmotionalIntensityTableCompanion Function({
  Value<String> id,
  Value<Emotion> emotion,
  Value<double> intensity,
  Value<String> momentId,
  Value<int> rowid,
});

final class $$EmotionalIntensityTableTableReferences extends BaseReferences<
    _$Database, $EmotionalIntensityTableTable, EmotionalIntensityTableData> {
  $$EmotionalIntensityTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MomentTableTable _momentIdTable(_$Database db) =>
      db.momentTable.createAlias($_aliasNameGenerator(
          db.emotionalIntensityTable.momentId, db.momentTable.id));

  $$MomentTableTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<String>('moment_id')!;

    final manager = $$MomentTableTableTableManager($_db, $_db.momentTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EmotionalIntensityTableTableFilterComposer
    extends Composer<_$Database, $EmotionalIntensityTableTable> {
  $$EmotionalIntensityTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Emotion, Emotion, String> get emotion =>
      $composableBuilder(
          column: $table.emotion,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get intensity => $composableBuilder(
      column: $table.intensity, builder: (column) => ColumnFilters(column));

  $$MomentTableTableFilterComposer get momentId {
    final $$MomentTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.momentId,
        referencedTable: $db.momentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentTableTableFilterComposer(
              $db: $db,
              $table: $db.momentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmotionalIntensityTableTableOrderingComposer
    extends Composer<_$Database, $EmotionalIntensityTableTable> {
  $$EmotionalIntensityTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emotion => $composableBuilder(
      column: $table.emotion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get intensity => $composableBuilder(
      column: $table.intensity, builder: (column) => ColumnOrderings(column));

  $$MomentTableTableOrderingComposer get momentId {
    final $$MomentTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.momentId,
        referencedTable: $db.momentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentTableTableOrderingComposer(
              $db: $db,
              $table: $db.momentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmotionalIntensityTableTableAnnotationComposer
    extends Composer<_$Database, $EmotionalIntensityTableTable> {
  $$EmotionalIntensityTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Emotion, String> get emotion =>
      $composableBuilder(column: $table.emotion, builder: (column) => column);

  GeneratedColumn<double> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  $$MomentTableTableAnnotationComposer get momentId {
    final $$MomentTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.momentId,
        referencedTable: $db.momentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentTableTableAnnotationComposer(
              $db: $db,
              $table: $db.momentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmotionalIntensityTableTableTableManager extends RootTableManager<
    _$Database,
    $EmotionalIntensityTableTable,
    EmotionalIntensityTableData,
    $$EmotionalIntensityTableTableFilterComposer,
    $$EmotionalIntensityTableTableOrderingComposer,
    $$EmotionalIntensityTableTableAnnotationComposer,
    $$EmotionalIntensityTableTableCreateCompanionBuilder,
    $$EmotionalIntensityTableTableUpdateCompanionBuilder,
    (EmotionalIntensityTableData, $$EmotionalIntensityTableTableReferences),
    EmotionalIntensityTableData,
    PrefetchHooks Function({bool momentId})> {
  $$EmotionalIntensityTableTableTableManager(
      _$Database db, $EmotionalIntensityTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmotionalIntensityTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$EmotionalIntensityTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmotionalIntensityTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<Emotion> emotion = const Value.absent(),
            Value<double> intensity = const Value.absent(),
            Value<String> momentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmotionalIntensityTableCompanion(
            id: id,
            emotion: emotion,
            intensity: intensity,
            momentId: momentId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required Emotion emotion,
            required double intensity,
            required String momentId,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmotionalIntensityTableCompanion.insert(
            id: id,
            emotion: emotion,
            intensity: intensity,
            momentId: momentId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EmotionalIntensityTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({momentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (momentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.momentId,
                    referencedTable: $$EmotionalIntensityTableTableReferences
                        ._momentIdTable(db),
                    referencedColumn: $$EmotionalIntensityTableTableReferences
                        ._momentIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EmotionalIntensityTableTableProcessedTableManager
    = ProcessedTableManager<
        _$Database,
        $EmotionalIntensityTableTable,
        EmotionalIntensityTableData,
        $$EmotionalIntensityTableTableFilterComposer,
        $$EmotionalIntensityTableTableOrderingComposer,
        $$EmotionalIntensityTableTableAnnotationComposer,
        $$EmotionalIntensityTableTableCreateCompanionBuilder,
        $$EmotionalIntensityTableTableUpdateCompanionBuilder,
        (EmotionalIntensityTableData, $$EmotionalIntensityTableTableReferences),
        EmotionalIntensityTableData,
        PrefetchHooks Function({bool momentId})>;
typedef $$MediaTableTableCreateCompanionBuilder = MediaTableCompanion Function({
  required String id,
  required String momentId,
  required Uint8List data,
  required String mimeType,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$MediaTableTableUpdateCompanionBuilder = MediaTableCompanion Function({
  Value<String> id,
  Value<String> momentId,
  Value<Uint8List> data,
  Value<String> mimeType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$MediaTableTableReferences
    extends BaseReferences<_$Database, $MediaTableTable, MediaTableData> {
  $$MediaTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MomentTableTable _momentIdTable(_$Database db) =>
      db.momentTable.createAlias(
          $_aliasNameGenerator(db.mediaTable.momentId, db.momentTable.id));

  $$MomentTableTableProcessedTableManager get momentId {
    final $_column = $_itemColumn<String>('moment_id')!;

    final manager = $$MomentTableTableTableManager($_db, $_db.momentTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_momentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MediaTableTableFilterComposer
    extends Composer<_$Database, $MediaTableTable> {
  $$MediaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$MomentTableTableFilterComposer get momentId {
    final $$MomentTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.momentId,
        referencedTable: $db.momentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentTableTableFilterComposer(
              $db: $db,
              $table: $db.momentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaTableTableOrderingComposer
    extends Composer<_$Database, $MediaTableTable> {
  $$MediaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$MomentTableTableOrderingComposer get momentId {
    final $$MomentTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.momentId,
        referencedTable: $db.momentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentTableTableOrderingComposer(
              $db: $db,
              $table: $db.momentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaTableTableAnnotationComposer
    extends Composer<_$Database, $MediaTableTable> {
  $$MediaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MomentTableTableAnnotationComposer get momentId {
    final $$MomentTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.momentId,
        referencedTable: $db.momentTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentTableTableAnnotationComposer(
              $db: $db,
              $table: $db.momentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MediaTableTableTableManager extends RootTableManager<
    _$Database,
    $MediaTableTable,
    MediaTableData,
    $$MediaTableTableFilterComposer,
    $$MediaTableTableOrderingComposer,
    $$MediaTableTableAnnotationComposer,
    $$MediaTableTableCreateCompanionBuilder,
    $$MediaTableTableUpdateCompanionBuilder,
    (MediaTableData, $$MediaTableTableReferences),
    MediaTableData,
    PrefetchHooks Function({bool momentId})> {
  $$MediaTableTableTableManager(_$Database db, $MediaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> momentId = const Value.absent(),
            Value<Uint8List> data = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaTableCompanion(
            id: id,
            momentId: momentId,
            data: data,
            mimeType: mimeType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String momentId,
            required Uint8List data,
            required String mimeType,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaTableCompanion.insert(
            id: id,
            momentId: momentId,
            data: data,
            mimeType: mimeType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MediaTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({momentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (momentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.momentId,
                    referencedTable:
                        $$MediaTableTableReferences._momentIdTable(db),
                    referencedColumn:
                        $$MediaTableTableReferences._momentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MediaTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $MediaTableTable,
    MediaTableData,
    $$MediaTableTableFilterComposer,
    $$MediaTableTableOrderingComposer,
    $$MediaTableTableAnnotationComposer,
    $$MediaTableTableCreateCompanionBuilder,
    $$MediaTableTableUpdateCompanionBuilder,
    (MediaTableData, $$MediaTableTableReferences),
    MediaTableData,
    PrefetchHooks Function({bool momentId})>;
typedef $$UserTableTableCreateCompanionBuilder = UserTableCompanion Function({
  required String id,
  required String username,
  required String profileImageUrl,
  required String email,
  Value<int> rowid,
});
typedef $$UserTableTableUpdateCompanionBuilder = UserTableCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> profileImageUrl,
  Value<String> email,
  Value<int> rowid,
});

class $$UserTableTableFilterComposer
    extends Composer<_$Database, $UserTableTable> {
  $$UserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
      column: $table.profileImageUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));
}

class $$UserTableTableOrderingComposer
    extends Composer<_$Database, $UserTableTable> {
  $$UserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
      column: $table.profileImageUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$Database, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
      column: $table.profileImageUrl, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);
}

class $$UserTableTableTableManager extends RootTableManager<
    _$Database,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserTableData, BaseReferences<_$Database, $UserTableTable, UserTableData>),
    UserTableData,
    PrefetchHooks Function()> {
  $$UserTableTableTableManager(_$Database db, $UserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> profileImageUrl = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion(
            id: id,
            username: username,
            profileImageUrl: profileImageUrl,
            email: email,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String username,
            required String profileImageUrl,
            required String email,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion.insert(
            id: id,
            username: username,
            profileImageUrl: profileImageUrl,
            email: email,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserTableData, BaseReferences<_$Database, $UserTableTable, UserTableData>),
    UserTableData,
    PrefetchHooks Function()>;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$MomentTableTableTableManager get momentTable =>
      $$MomentTableTableTableManager(_db, _db.momentTable);
  $$EmotionalIntensityTableTableTableManager get emotionalIntensityTable =>
      $$EmotionalIntensityTableTableTableManager(
          _db, _db.emotionalIntensityTable);
  $$MediaTableTableTableManager get mediaTable =>
      $$MediaTableTableTableManager(_db, _db.mediaTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
}
