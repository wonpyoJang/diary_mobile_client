// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:diary_mobile_client/src/feature/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
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

  String getFormattedDateTime() {
    final DateFormat formatter =
        DateFormat('yyyy년 MM월 dd일 EEEE a hh시 mm분 ss초', 'ko_KR');
    return formatter.format(date);
  }

  String getFormattedDay() {
    final DateFormat formatter = DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR');
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
      medias: (json['medias'] as List<dynamic>)
          .map((e) => File(e['path'] as String))
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [id, reflection, date, modifiedAt, emotionalIntensities];

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
