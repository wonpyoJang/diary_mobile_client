import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';

class EmotionalIntensityDto {
  final String emotion;
  final double intensity;

  EmotionalIntensityDto({
    required this.emotion,
    required this.intensity,
  });

  EmotionalIntensity toDomain() {
    return EmotionalIntensity(
      emotion: Emotion.findByName(emotion),
      intensity: intensity,
    );
  }

  factory EmotionalIntensityDto.fromDomain(EmotionalIntensity domain) {
    return EmotionalIntensityDto(
      emotion: domain.emotion.name,
      intensity: domain.intensity,
    );
  }

  factory EmotionalIntensityDto.fromJson(Map<String, dynamic> json) {
    return EmotionalIntensityDto(
      emotion: json['emotion'] as String,
      intensity: (json['intensity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emotion': emotion,
      'intensity': intensity,
    };
  }
}
