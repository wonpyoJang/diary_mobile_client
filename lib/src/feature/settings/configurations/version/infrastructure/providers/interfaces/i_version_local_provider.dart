import '../../../domain/version_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IVersionLocalProvider {
  Future<Either<VersionFailure, String>> getVersion();
  Future<Either<VersionFailure, String>> getBuildNumber();
}
