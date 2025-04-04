import 'package:flutter/material.dart';

class MomentWritingPageTitle extends StatelessWidget {
  const MomentWritingPageTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "일기를 작성해 오늘의 감정을\n진단받아보세요",
      style: TextStyle(
        fontFamily: "Pretendard",
        fontSize: 16,
        height: 1.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.32,
        color: Color(0xFF4D4E58),
      ),
    );
  }
}
