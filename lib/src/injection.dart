// Package imports:
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  debugPrint('의존성 주입 설정을 시작합니다...');

  final dir = await getApplicationDocumentsDirectory();
  final dbPath = '${dir.path}/$dbName';
  getIt.registerSingleton<String>(dbPath);
  debugPrint('데이터베이스 경로가 등록되었습니다: $dbPath');

  // Supabase가 완전히 초기화되었는지 확인
  try {
    // Supabase.instance.client에 접근하여 초기화 상태 확인
    final _ = Supabase.instance.client;
    debugPrint('Supabase가 성공적으로 초기화되었습니다.');
  } catch (e) {
    debugPrint('Supabase 초기화 확인 중 오류 발생: $e');
    throw StateError('Supabase가 아직 초기화되지 않았습니다. $e');
  }

  debugPrint('injectable을 통해 의존성을 등록합니다...');
  getIt.$initGetIt();
  debugPrint('의존성 주입 설정이 완료되었습니다.');
}
