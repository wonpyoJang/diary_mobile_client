import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IDeviceInfoLocalProvider {
  Future<Either<LocalFailure, String>> getDeviceId();
}
