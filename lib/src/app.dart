import 'package:diary_mobile_client/l10n/app_localizations.dart';
import 'package:diary_mobile_client/src/feature/common/loading_indicator.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_bloc.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_state.dart';
import 'package:diary_mobile_client/src/feature/data_control/application/data_control_bloc.dart';
import 'package:diary_mobile_client/src/feature/global_loading/application/global_loading_bloc.dart';
import 'package:diary_mobile_client/src/feature/global_loading/application/global_loading_state.dart';
import 'package:diary_mobile_client/src/feature/lock/application/lock_cubit.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_event.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/write_moment_page.dart';
import 'package:diary_mobile_client/src/feature/profile/presentation/profile_page.dart';
import 'package:diary_mobile_client/src/feature/recommend/application/recommend_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_bloc.dart';
import 'package:diary_mobile_client/src/feature/splash/splash_page.dart';
import 'package:diary_mobile_client/src/feature/user/application/user_bloc.dart';
import 'package:diary_mobile_client/src/feature/user/application/user_event.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:diary_mobile_client/src/core/deep_link/deep_link_service.dart';
import 'package:diary_mobile_client/src/core/deep_link/deep_link_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'feature/moment/moment_list/presentation/moment_list_page.dart';
import 'feature/settings/settings_controller.dart';
import 'feature/settings/settings_view.dart';
import 'feature/signin/presentation/signin_page.dart';
import 'feature/auth/login_callback_page.dart';
import 'feature/auth/deep_link_test_page.dart';
import 'feature/llm/presentation/gemma_download_page.dart';
import 'feature/llm/presentation/llm_settings_page.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 딥링크 서비스 초기화
    DeepLinkService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SettingsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<MomentListBloc>()..add(LoadMoments()),
        ),
        BlocProvider(
          create: (context) => getIt<ToastBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<LockCubit>()..loadLockEnabled(),
        ),
        BlocProvider(
          create: (context) => getIt<UserBloc>()..add(LoadSavedUser()),
        ),
        BlocProvider(
          create: (context) => getIt<RecommendBloc>(),
        ),
        BlocProvider(create: (context) => getIt<DeepLinkCubit>()),
        BlocProvider(create: (context) => getIt<DataControlBloc>()),
        BlocProvider(create: (context) => getIt<GlobalLoadingBloc>()),
      ],
      child: Builder(builder: (context) {
        return ListenableBuilder(
          listenable: getIt<SettingsController>(),
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              title: "Crepas Diary",
              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'app',
              locale: getIt<SettingsController>().locale, // 사용자가 선택한 언어 적용

              // Provide the generated AppLocalizations to the MaterialApp. This
              // allows descendant Widgets to display the correct translations
              // depending on the user's locale.
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ko', ''), // Korean, no country code
                Locale('en', ''), // English, no country code
                Locale('zh', ''), // Chinese, no country code
                Locale('ja', ''), // Japanese, no country code
                Locale('zh_TW', ''), // Traditional Chinese, no country code
              ],

              // Define a light and dark color theme. Then, read the user's
              // preferred ThemeMode (light, dark, or system default) from the
              // SettingsController to display the correct theme.
              theme: ThemeData.light().copyWith(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white, // 스크롤을 내렸을 때 앱바의 색상 설정
                ),
                cardTheme: const CardThemeData(
                  color: Color(0xFFF5F5F5), // 카드 배경색 설정
                  shadowColor: Colors.black54, // 그림자 색상 추가
                  elevation: 4, // 그림자 높이 조정
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(12.0)), // 모서리 둥글게
                    side: BorderSide(
                      color: Color(0xFF5361f1), // 테두리 색상 설정
                      width: 1.5, // 테두리 두께 설정
                    ),
                  ),
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF5361f1),
                  primary: const Color(0xFF5361f1),
                  secondary: const Color(0xFFD9D9D9),
                  surface: Colors.white,
                  onPrimary: Colors.white,
                  onSecondary: Colors.black,
                  primaryContainer: const Color(0xFF5361f1), // CTA 버튼 컬러 추가
                  onSurface: Colors.grey[700], // MomentList 페이지의 텍스트 컬러와 일치
                  onPrimaryContainer: Colors.white, // CTA 버튼 텍스트 컬러 추가
                ),
                disabledColor: Colors.grey, // disabled Button color 추가
                textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    color: Colors.grey[700], // MomentList 페이지의 텍스트 컬러와 일치
                  ),
                ),
                // 카드 위 텍스트에 적합한 컬러 선택
                primaryTextTheme: const TextTheme(
                  bodyMedium: TextStyle(
                    color: Colors.black, // 카드 위 텍스트 컬러 설정
                  ),
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.black, // 스크롤을 내렸을 때 앱바의 색상 설정
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF5361f1),
                  primary: const Color(0xFF5361f1),
                  secondary: const Color(0xFF424242),
                  surface: const Color(0xFF303030),
                  onPrimary: Colors.white,
                  onSecondary: Colors.white,
                  primaryContainer: const Color(0xFF5361f1), // CTA 버튼 컬러 추가
                  onSurface: Colors.white70, // disabled된 CTA 버튼 컬러 추가
                  onPrimaryContainer: Colors.white, // CTA 버튼 텍스트 컬러 추가
                ),
                disabledColor: Colors.white70, // disabled Button color 추가
                textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    color: Colors.grey[300],
                  ),
                ),
                cardTheme: const CardThemeData(
                  color: Color(0xFF303030), // 카드 배경색 설정
                  shadowColor: Colors.black54, // 그림자 색상 추가
                  elevation: 4, // 그림자 높이 조정
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(12.0)), // 모서리 둥글게
                    side: BorderSide(
                      color: Color(0xFF5361f1), // 테두리 색상 설정
                      width: 1.5, // 테두리 두께 설정
                    ),
                  ),
                ),
                primaryTextTheme: const TextTheme(
                  bodyMedium: TextStyle(
                    color: Colors.white, // 카드 위 텍스트 컬러 설정
                  ),
                ),
              ),
              themeMode: ThemeMode.light,

              // Define a function to handle named routes in order to support
              // Flutter web url navigation and deep linking.
              onGenerateRoute: (RouteSettings routeSettings) {
                if (kDebugMode) {
                  debugPrint('=== 라우트 생성 시작 ===');
                  debugPrint('라우트 이름: ${routeSettings.name}');
                  debugPrint('라우트 인수: ${routeSettings.arguments}');
                }

                // 딥링크 처리 - 일반 라우트로 처리되지 않도록 먼저 체크
                if (routeSettings.name?.startsWith('cassette-diary://') ==
                    true) {
                  if (kDebugMode) {
                    debugPrint('딥링크 감지됨: ${routeSettings.name}');
                    debugPrint('딥링크를 일반 라우트로 처리하지 않음');
                  }

                  final deepLinkCubit = context.read<DeepLinkCubit>();
                  final route = deepLinkCubit
                      .generateRouteFromDeepLink(routeSettings.name!);

                  if (route != null) {
                    if (kDebugMode) {
                      debugPrint('딥링크 라우트 생성 성공: ${route.settings.name}');
                    }
                    return route;
                  } else {
                    if (kDebugMode) {
                      debugPrint('딥링크 라우트 생성 실패: ${routeSettings.name}');
                      debugPrint('기본 라우트로 폴백');
                    }
                  }
                }

                return MaterialPageRoute<void>(
                  settings: routeSettings,
                  builder: (BuildContext context) {
                    final uri = Uri.parse(routeSettings.name ?? '/');
                    final path = uri.path;

                    if (kDebugMode) {
                      debugPrint('일반 라우트 처리:');
                      debugPrint('  - 전체 URI: $uri');
                      debugPrint('  - 경로: $path');
                      debugPrint('  - 쿼리 파라미터: ${uri.queryParameters}');
                    }

                    switch (path) {
                      case SettingsView.routeName:
                        if (kDebugMode) {
                          debugPrint('설정 페이지로 라우팅');
                        }
                        return SettingsView(
                            controller: getIt<SettingsController>());
                      case WriteMomentPage.routeName:
                        if (kDebugMode) {
                          debugPrint('모멘트 작성 페이지로 라우팅');
                          debugPrint('인수: ${routeSettings.arguments}');
                        }

                        if (routeSettings.arguments != null) {
                          final WriteMomentPageArguments args = routeSettings
                              .arguments! as WriteMomentPageArguments;

                          return WriteMomentPage(arguments: args);
                        } else {
                          return WriteMomentPage(
                            arguments: WriteMomentPageArguments(
                                moment: null,
                                isBlendMode: true,
                                date: DateTime.now()),
                          );
                        }

                      case MomentListPage.routeName:
                        if (kDebugMode) {
                          debugPrint('모멘트 목록 페이지로 라우팅');
                        }
                        return const MomentListPage();
                      case SplashPage.routeName:
                        if (kDebugMode) {
                          debugPrint('스플래시 페이지로 라우팅');
                        }
                        return const SplashPage();
                      case ProfilePage.routeName:
                        if (kDebugMode) {
                          debugPrint('프로필 페이지로 라우팅');
                        }
                        return const ProfilePage();
                      case SignInPage.routeName:
                        if (kDebugMode) {
                          debugPrint('로그인 페이지로 라우팅');
                        }
                        return const SignInPage();
                      case LoginCallbackPage.routeName:
                        if (kDebugMode) {
                          debugPrint('로그인 콜백 페이지로 라우팅');
                        }
                        return const LoginCallbackPage();
                      case DeepLinkTestPage.routeName:
                        if (kDebugMode) {
                          debugPrint('딥링크 테스트 페이지로 라우팅');
                        }
                        return const DeepLinkTestPage();
                      case LlmSettingsPage.routeName:
                        if (kDebugMode) {
                          debugPrint('LLM 설정 페이지로 라우팅');
                        }
                        return const LlmSettingsPage();
                      case GemmaDownloadPage.routeName:
                        if (kDebugMode) {
                          debugPrint('Gemma 다운로드 페이지로 라우팅');
                        }
                        return const GemmaDownloadPage();
                      default:
                        if (kDebugMode) {
                          debugPrint('알 수 없는 경로: $path');
                          debugPrint('웹 환경: $kIsWeb');
                        }

                        return kIsWeb
                            ? MaterialApp(
                                home: WriteMomentPage(
                                    arguments: WriteMomentPageArguments(
                                        moment: null,
                                        isBlendMode: true,
                                        date: DateTime.now())),
                              )
                            : const SplashPage();
                    }
                  },
                );
              },
              builder: (context, child) {
                // MaterialApp이 빌드된 후 초기 딥링크 처리
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final deepLinkCubit = context.read<DeepLinkCubit>();
                  if (kDebugMode) {
                    debugPrint('=== MaterialApp 빌드 완료 - 초기 딥링크 처리 시작 ===');
                  }
                  deepLinkCubit.notifyNavigatorReady();
                  deepLinkCubit.processInitialDeepLink();
                });

                return GlobalAppWrapper(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<ToastBloc, ToastState>(
                        listenWhen: (previous, current) {
                          return previous.currentToast !=
                                  current.currentToast &&
                              current.currentToast != null;
                        },
                        listener: (context, state) {
                          final toast = state.currentToast;
                          if (toast == null) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(toast.message),
                              backgroundColor: toast.type == ToastType.success
                                  ? Colors.green
                                  : toast.type == ToastType.error
                                      ? Colors.red
                                      : toast.type == ToastType.warning
                                          ? Colors.orange
                                          : Colors.blue,
                              duration: toast.duration,
                            ),
                          );
                        },
                      ),
                    ],
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}

class GlobalAppWrapper extends StatelessWidget {
  final Widget child;
  const GlobalAppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder<GlobalLoadingBloc, GlobalLoadingState>(
          builder: (context, state) {
            return state.isLoading
                ? const Align(
                    alignment: Alignment.center,
                    child: CommonLoadingIndicator(),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
