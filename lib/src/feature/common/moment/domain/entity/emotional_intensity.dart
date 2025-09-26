import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:equatable/equatable.dart';

class EmotionalIntensity extends Equatable {
  final Emotion emotion;
  final double intensity;

  const EmotionalIntensity({required this.emotion, required this.intensity});

  @override
  List<Object?> get props => [emotion, intensity];
}
