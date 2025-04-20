import 'package:flutter/material.dart';

class MomentWritingPageTitle extends StatelessWidget {
  const MomentWritingPageTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 4),
        Text(
          "일기를 작성해 오늘의 감정을\n확인해보세요.",
          style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: 16,
            height: 1.0,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.32,
            color: Color(0xFF53545B),
          ),
        ),
      ],
    );
  }
}
