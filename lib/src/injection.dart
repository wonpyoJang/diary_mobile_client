// Package imports:
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = '${dir.path}/crepas.sqlite';
  getIt.registerSingleton<String>(dbPath);
  getIt.$initGetIt();
}
