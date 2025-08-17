import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';
import '../application/signin_bloc.dart';
import '../application/signin_event.dart';
import '../application/signin_state.dart';

class SignInPage extends StatelessWidget {
  static const routeName = '/signin';

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => getIt<SignInBloc>(),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 성공: ${state.email ?? state.userId}')),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final bloc = context.read<SignInBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.signin),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is AuthLoading) ...[
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 32),
                  ],
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/images/common/kakao_logo.png',
                      height: 24,
                    ),
                    label: Text(l10n.kakaoLogin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE500),
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: state is AuthLoading
                        ? null
                        : () => bloc.add(SignInWithKakao()),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon:
                        const Icon(Icons.apple, size: 24, color: Colors.black),
                    label: Text(l10n.appleLogin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    onPressed: state is AuthLoading
                        ? null
                        : () => bloc.add(SignInWithApple()),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
