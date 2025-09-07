import 'package:diary_mobile_client/src/feature/common/simple_dialog.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/write_moment_bloc.dart';
import '../../application/write_moment_state.dart';

class EmotionPalette extends StatelessWidget {
  final List<EmotionalIntensity> emotionalIntensities;
  const EmotionPalette({
    super.key,
    required this.emotionalIntensities,
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 3;
    if (kIsWeb) {
      final double screenWidth = MediaQuery.of(context).size.width;
      crossAxisCount = screenWidth > 600 ? 8 : 4;
    }

    return BlocBuilder<WriteMomentBloc, WriteMomentState>(
      builder: (context, state) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.moment.emotionalIntensities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
          ),
          itemBuilder: (context, index) {
            final emotionalIntensity = state.moment.emotionalIntensities[index];
            return Center(
              child: EmotionItem(
                  emotionalIntensity: emotionalIntensity,
                  size: EmotionItemSize.large),
            );
          },
        );
      },
    );
  }
}

enum EmotionItemSize {
  large(imageSize: 50, fontSize: 16, fontHeight: 20, letterSpacing: -0.32),
  small(imageSize: 30, fontSize: 9, fontHeight: 11, letterSpacing: -0.117);

  const EmotionItemSize(
      {required this.imageSize,
      required this.fontSize,
      required this.fontHeight,
      required this.letterSpacing});

  final double imageSize;
  final double fontSize;
  final double fontHeight;
  final double letterSpacing;
}

class EmotionItem extends StatelessWidget {
  final EmotionItemSize size;
  const EmotionItem(
      {super.key, required this.emotionalIntensity, required this.size});

  final EmotionalIntensity emotionalIntensity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSimpleDialog(context,
            title: emotionalIntensity.emotion.localizedName(context),
            message: emotionalIntensity.emotion.localizedExplanation(context),
            confirmText: "닫기",
            onConfirm: (value) {});
      },
      child: Column(
        children: [
          SizedBox(
            height: size.fontHeight,
            child: Text(
              emotionalIntensity.emotion.localizedName(context),
              style: TextStyle(
                fontFamily: "SpoqaHanSansNeo",
                fontSize: size.fontSize,
                color: const Color(0xFF808080),
                fontWeight: FontWeight.w400,
                letterSpacing: size.letterSpacing,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 2),
          Image.asset(
            'assets/images/feature/moment/write_moment/pattern1.png',
            width: size.imageSize,
            height: size.imageSize,
            color: emotionalIntensity.emotion.color, // 감정색으로 변경
            colorBlendMode: BlendMode.srcIn,
          )
        ],
      ),
    );
  }
}
