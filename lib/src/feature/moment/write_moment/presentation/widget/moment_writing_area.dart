import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/write_moment_bloc.dart';
import '../../application/write_moment_event.dart';

class MomentWritingArea extends StatelessWidget {
  const MomentWritingArea({
    super.key,
    required TextEditingController controller,
    required this.mode,
  }) : _controller = controller;

  final TextEditingController _controller;
  final WriteMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        scrollPadding: const EdgeInsets.all(0),
        maxLines: null,
        minLines: null,
        expands: true,
        controller: _controller,
        maxLength: 600,
        autofocus: mode == WriteMode.create,
        decoration: InputDecoration(
            hintText: ([
              '오늘 하루는 어떠셨나요?'
              // '오늘의 감정을 솔직하게 표현해보세요',
              // '오늘 하루의 소중한 순간을 기록해보세요',
              // '당신의 마음속 이야기를 적어보세요',
              // '오늘의 기분을 솔직하게 털어놓아보세요',
              // '하루의 끝, 당신의 생각을 나눠보세요',
              // '오늘의 일기를 통해 감정을 정리해보세요',
              // '소중한 기억을 남겨보세요',
              // '당신의 하루를 특별하게 만들어보세요',
              // '마음속 이야기를 글로 표현해보세요',
              // '오늘의 감정을 글로 남겨보세요',
            ]
                  ..toList()
                  ..shuffle())
                .first,
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            counterStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: "Pretendard",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                )),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: "Pretendard",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.32,
              height: 1.25,
              color: const Color(0xFF4D5E58),
            ),
        onChanged: (String text) {
          context.read<WriteMomentBloc>().add(TextChangedEvent(text));
        },
        onSubmitted: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTapOutside: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
