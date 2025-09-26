import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/emotion_palette.dart';
import 'package:flutter/material.dart';

class EmotionList extends StatelessWidget {
  final List<EmotionalIntensity> emotionalIntensies;
  final MainAxisAlignment mainAxisAlignment;
  const EmotionList(
      {super.key,
      required this.emotionalIntensies,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 13,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...emotionalIntensies.take(4).map((e) => EmotionItem(
              size: EmotionItemSize.small,
              emotionalIntensity: e,
            ))
      ],
    );
  }
}
