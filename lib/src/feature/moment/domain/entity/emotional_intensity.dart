import 'package:diary_mobile_client/src/feature/moment/domain/enums/emotion.dart';

class EmotionalIntensity {
  final Emotion emotion;
  final double intensity;

  const EmotionalIntensity({required this.emotion, required this.intensity});
}
