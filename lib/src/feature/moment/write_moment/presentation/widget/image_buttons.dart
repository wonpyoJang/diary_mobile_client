import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/add_photo_button.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/widget/extract_emotion_button.dart';
import 'package:flutter/widgets.dart';

class ImageButtons extends StatelessWidget {
  const ImageButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          AddPhotoButton(),
          SizedBox(width: 8),
          ExtractEmotionButon(),
        ],
      ),
    );
  }
}
