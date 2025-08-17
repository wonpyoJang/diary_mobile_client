// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:diary_mobile_client/src/core/utils/id_generator.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Moment extends Equatable {
  const Moment(
      {required this.id,
      required this.reflection,
      required this.date,
      required this.modifiedAt,
      required this.emotionalIntensities,
      required this.medias});

  final String id;
  final String reflection;
  final DateTime date;
  final DateTime modifiedAt;
  final List<EmotionalIntensity> emotionalIntensities;
  final List<File> medias;

  @override
  List<Object?> get props =>
      [id, reflection, date, modifiedAt, emotionalIntensities, medias];

  /// 새로운 Moment를 생성합니다.
  factory Moment.create({
    required String reflection,
    required DateTime date,
    List<File> medias = const [],
  }) {
    final now = DateTime.now();
    return Moment(
      id: IdGenerator.generate(prefix: 'moment'),
      reflection: reflection,
      date: date,
      modifiedAt: now,
      emotionalIntensities: const [],
      medias: medias,
    );
  }

  String getFormattedDateTime({String locale = 'ko_KR'}) {
    final isKorean = locale.startsWith('ko');
    final formatStr = isKorean
        ? 'yyyy년 MM월 dd일 EEEE a hh시 mm분 ss초'
        : 'yyyy-MM-dd EEEE hh:mm:ss a';
    final DateFormat formatter = DateFormat(formatStr, locale);
    return formatter.format(date);
  }

  String getFormattedDay({String locale = 'ko_KR'}) {
    final isKorean = locale.startsWith('ko');
    final formatStr = isKorean ? 'yyyy년 MM월 dd일 EEEE' : 'yyyy-MM-dd EEEE';
    final DateFormat formatter = DateFormat(formatStr, locale);
    return formatter.format(date);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reflection': reflection,
      'date': date.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'emotionalIntensities': emotionalIntensities
          .map((e) => {
                'emotion': e.emotion.name,
                'intensity': e.intensity,
              })
          .toList(),
    };
  }

  factory Moment.fromJson(Map<String, dynamic> json) {
    return Moment(
      id: json['id'] as String,
      reflection: json['reflection'] as String,
      date: DateTime.parse(json['date'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      emotionalIntensities: (json['emotionalIntensities'] as List<dynamic>)
          .map((e) => EmotionalIntensity(
                emotion: Emotion.findByName(e['emotion'] as String),
                intensity: e['intensity'] as double,
              ))
          .toList(),
      medias: (json['medias'] as List<dynamic>?)
              ?.map((e) => File(e['path'] as String))
              .toList() ??
          [],
    );
  }

  Moment copyWith({
    String? id,
    String? reflection,
    DateTime? date,
    DateTime? modifiedAt,
    List<EmotionalIntensity>? emotionalIntensities,
    List<File>? medias,
  }) {
    return Moment(
      id: id ?? this.id,
      reflection: reflection ?? this.reflection,
      date: date ?? this.date,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      emotionalIntensities: emotionalIntensities ?? this.emotionalIntensities,
      medias: medias ?? this.medias,
    );
  }
}
