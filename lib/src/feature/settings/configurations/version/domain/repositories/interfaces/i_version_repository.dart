import '../../version_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IVersionRepository {
  Future<Either<VersionFailure, String>> getVersion();
  Future<Either<VersionFailure, String>> getBuildNumber();
}
