import 'package:flutter/material.dart';

class WriteMomentButton extends StatelessWidget {
  final Function onTap;
  const WriteMomentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onTap(),
      tooltip: '일기쓰기',
      child: const Icon(Icons.create), // 크레파스 아이콘으로 변경
    );
  }
}
