import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';

class EmotionStatsDto {
  final String emotion;
  final int count;
  final double avgIntensity;
  final double maxIntensity;
  final double minIntensity;
  final double totalIntensity;

  EmotionStatsDto({
    required this.emotion,
    required this.count,
    required this.avgIntensity,
    required this.maxIntensity,
    required this.minIntensity,
    required this.totalIntensity,
  });

  factory EmotionStatsDto.fromDomain(EmotionStats domain) {
    return EmotionStatsDto(
      emotion: domain.emotion.name,
      count: domain.count,
      avgIntensity: domain.avgIntensity,
      maxIntensity: domain.maxIntensity,
      minIntensity: domain.minIntensity,
      totalIntensity: domain.totalIntensity,
    );
  }

  factory EmotionStatsDto.fromJson(Map<String, dynamic> json) {
    return EmotionStatsDto(
      emotion: json['emotion'] as String,
      count: json['count'] as int,
      avgIntensity: json['avgIntensity'] as double,
      maxIntensity: json['maxIntensity'] as double,
      minIntensity: json['minIntensity'] as double,
      totalIntensity: json['totalIntensity'] as double,
    );
  }

  EmotionStats toDomain() {
    return EmotionStats(
      emotion: Emotion.findByName(emotion),
      count: count,
      avgIntensity: avgIntensity,
      maxIntensity: maxIntensity,
      minIntensity: minIntensity,
      totalIntensity: totalIntensity,
    );
  }
}
