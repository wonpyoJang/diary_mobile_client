import 'package:diary_mobile_client/src/feature/moment/domain/entity/emotional_intensity.dart';
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
    int crossAxisCount = 4;
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
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        title: Text(emotionalIntensity.emotion.koName,
                            style: Theme.of(context).textTheme.bodyMedium),
                        content: Text(emotionalIntensity.emotion.explanation,
                            style: Theme.of(context).textTheme.bodyMedium),
                        actions: <Widget>[
                          TextButton(
                            child: Text('닫기',
                                style: Theme.of(context).textTheme.bodyMedium),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                      child: Text(
                        emotionalIntensity.emotion.koName,
                        style: const TextStyle(
                          fontFamily: "SpoqaHanSansNeo",
                          fontSize: 16,
                          color: Color(0xFF808080),
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Image.asset(
                      'assets/images/feature/moment/write_moment/pattern1.png',
                      width: 50,
                      height: 50,
                      color: emotionalIntensity.emotion.color, // 감정색으로 변경
                      colorBlendMode: BlendMode.srcIn,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
