import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_event.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/write_moment_page.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_bloc.dart';
import 'package:diary_mobile_client/src/feature/splash/splash_page.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'feature/moment/moment_list/presentation/moment_list_page.dart';
import 'feature/settings/settings_controller.dart';
import 'feature/settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

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
      ],
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: '크레파스 감정일기',
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko', ''), // Korean, no country code
              Locale('en', ''), // English, no country code
            ],

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(
                color: Colors.white, // 스크롤을 내렸을 때 앱바의 색상 설정
              ),
              cardTheme: const CardTheme(
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
                color: Colors.black, // 스크롤을 내렸을 때 앱바의 색상 설정
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
              cardTheme: const CardTheme(
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
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    case WriteMomentPage.routeName:
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
                      return const MomentListPage();
                    case SplashPage.routeName:
                      return const SplashPage();
                    default:
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
          );
        },
      ),
    );
  }
}
