import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/add_photo_button.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/extract_emotion_button.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/voice_input_button.dart';
import 'package:flutter/material.dart';

class ImageButtons extends StatelessWidget {
  final TextEditingController controller;
  const ImageButtons({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          VoiceInputButton(controller: controller),
          const SizedBox(width: 8),
          const AddPhotoButton(),
          const SizedBox(width: 8),
          const ExtractEmotionButon(),
        ],
      ),
    );
  }
}
