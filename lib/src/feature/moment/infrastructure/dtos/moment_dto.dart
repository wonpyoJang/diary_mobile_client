import 'dart:io';

import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:image_picker/image_picker.dart';

class MomentDto {
  final String id;
  final String reflection;
  final String date;
  final String modifiedAt;
  final List<EmotionalIntensityDto> emotionalIntensities;
  final List<File> medias;

  MomentDto({
    required this.id,
    required this.reflection,
    required this.date,
    required this.modifiedAt,
    required this.emotionalIntensities,
    required this.medias,
  });

  Moment toDomain() {
    return Moment(
      id: id,
      reflection: reflection,
      date: DateTime.parse(date),
      modifiedAt: DateTime.parse(modifiedAt),
      emotionalIntensities:
          emotionalIntensities.map((e) => e.toDomain()).toList(),
      medias: medias,
    );
  }

  factory MomentDto.fromDomain(Moment domain) {
    return MomentDto(
      id: domain.id,
      reflection: domain.reflection,
      date: domain.date.toIso8601String(),
      modifiedAt: domain.modifiedAt.toIso8601String(),
      emotionalIntensities: domain.emotionalIntensities
          .map((e) => EmotionalIntensityDto.fromDomain(e))
          .toList(),
      medias: domain.medias,
    );
  }

  factory MomentDto.fromJson(Map<String, dynamic> json) {
    return MomentDto(
      id: json['id'] as String,
      reflection: json['reflection'] as String,
      date: json['date'] as String,
      modifiedAt: json['modifiedAt'] as String,
      emotionalIntensities: (json['emotionalIntensities'] as List<dynamic>)
          .map((e) => EmotionalIntensityDto.fromJson(e))
          .toList(),
      medias: (json['medias'] as List<dynamic>)
          .map((e) => File(e['path'] as String))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reflection': reflection,
      'date': date,
      'modifiedAt': modifiedAt,
      'emotionalIntensities':
          emotionalIntensities.map((e) => e.toJson()).toList(),
      'medias': medias.map((e) => e.path).toList(),
    };
  }
}
