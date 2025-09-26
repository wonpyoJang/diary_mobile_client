import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';

class EmotionStats {
  final Emotion emotion;
  final int count;
  final double avgIntensity;
  final double maxIntensity;
  final double minIntensity;
  final double totalIntensity;

  EmotionStats({
    required this.emotion,
    required this.count,
    required this.avgIntensity,
    required this.maxIntensity,
    required this.minIntensity,
    required this.totalIntensity,
  });
}
