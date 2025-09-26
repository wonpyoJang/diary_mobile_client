import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/settings/settings_view.dart';
import 'package:diary_mobile_client/src/feature/signin/presentation/signin_page.dart';
import 'package:diary_mobile_client/src/feature/user/application/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/application/user_state.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.profile),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsView.routeName);
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state.user != null) ...[
                  const SizedBox(height: 8),
                  // const EmotionGrid(),
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: state.user?.profileImageUrl != null
                        ? NetworkImage(state.user!.profileImageUrl!)
                        : const AssetImage(
                            'assets/images/common/background/background.png'), // TODO: 실제 프로필 이미지로 교체
                  ),

                  const SizedBox(height: 8),
                  Text(
                    state.user?.username ?? '이름 정보 업음',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.user?.email ?? '이메일 없음',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],

                // 조건문 밖으로 빼서 항상 표시
                const SizedBox(height: 8),

                if (state.user == null) ...[
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 프로필 편집 페이지로 이동
                      Navigator.of(context).pushNamed(SignInPage.routeName);
                    },
                    child: Text(AppLocalizations.of(context)!.signin),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

class EmotionGrid extends StatelessWidget {
  final List<List<EmotionalIntensity>> data; // [date][5개 감정]

  const EmotionGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          data.length,
          (dateIdx) => Column(
            children: List.generate(
              5,
              (emotionIdx) => Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: data[dateIdx][emotionIdx].emotion.color, // 감정별 색상
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
