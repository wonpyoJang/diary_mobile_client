import 'package:flutter/material.dart';

/// 백업 페이지 안에서 섹션을 구분하기 위한 작은 제목 텍스트.
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF53545B),
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}
