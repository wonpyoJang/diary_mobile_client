import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/version_failure.dart';
import '../providers/interfaces/i_version_local_provider.dart';
import '../../domain/repositories/interfaces/i_version_repository.dart';

@LazySingleton(as: IVersionRepository)
class VersionRepository implements IVersionRepository {
  final IVersionLocalProvider localProvider;

  VersionRepository(this.localProvider);

  @override
  Future<Either<VersionFailure, String>> getVersion() =>
      localProvider.getVersion();
  @override
  Future<Either<VersionFailure, String>> getBuildNumber() =>
      localProvider.getBuildNumber();
}
