import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/emotional_intensity_dto.dart';

class MomentDto {
  final String id;
  final String reflection;
  final String date;
  final String modifiedAt;
  final List<EmotionalIntensityDto> emotionalIntensities;

  MomentDto({
    required this.id,
    required this.reflection,
    required this.date,
    required this.modifiedAt,
    required this.emotionalIntensities,
  });

  Moment toDomain() {
    return Moment(
      id: id,
      reflection: reflection,
      date: DateTime.parse(date),
      modifiedAt: DateTime.parse(modifiedAt),
      emotionalIntensities:
          emotionalIntensities.map((e) => e.toDomain()).toList(),
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
    };
  }
}
