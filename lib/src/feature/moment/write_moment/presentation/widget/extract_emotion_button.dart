import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return InkWell(
          onTap: () {
            AnalyticsManager.logEvent('write_extract_emotion',
                parameters: {'length': state.moment.reflection.length});
            if (state.moment.reflection.length < 20) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('일기를 20자 이상 작성해주세요'),
                ),
              );
              return;
            }

            context.read<WriteMomentBloc>().add(const Analyzed());
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
            height: 60,
            decoration: BoxDecoration(
              color: state.moment.reflection.length < 20 || state.isLoading
                  ? const Color(0xFFB0B0B0)
                  : const Color(0xFFADCBFF),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
                child: Text('감정 확인하기',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 20,
                        letterSpacing: -0.4,
                        color: const Color(0xFF4D4E58)))),
          ),
        );
      },
    );
  }
}
