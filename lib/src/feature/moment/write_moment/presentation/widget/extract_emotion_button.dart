import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../application/write_moment_bloc.dart';
import '../../application/write_moment_event.dart';
import '../../application/write_moment_state.dart';

class ExtractEmotionButon extends StatelessWidget {
  const ExtractEmotionButon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WriteMomentBloc, WriteMomentState>(
      builder: (context, state) {
        final isFilled = state.moment.reflection.length >= 20 ||
            state.moment.medias.isNotEmpty;
        final isActive = isFilled && state.isLoading;
        return InkWell(
          onTap: () {
            AnalyticsManager.logEvent('write_extract_emotion',
                parameters: {'length': state.moment.reflection.length});
            if (state.moment.reflection.length < 20 &&
                state.moment.medias.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('일기를 20자 이상 작성해주세요'),
                ),
              );
              return;
            } else if (state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('조금만 기다려주세요. 분석중입니다.'),
                ),
              );
              return;
            }

            context.read<WriteMomentBloc>().add(const Analyzed());
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 30, right: 30),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
                  isActive ? const Color(0xFFD7D8D8) : const Color(0xFFFF965C),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Center(
                child: SvgPicture.asset(
              "assets/images/feature/moment/write_moment/next.svg",
              colorFilter: isActive
                  ? null
                  : const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            )),
          ),
        );
      },
    );
  }
}
