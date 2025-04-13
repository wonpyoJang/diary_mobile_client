import 'package:diary_mobile_client/src/core/http_client/http_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class IWriteMomentInternalProvider {
  Future<Either<HttpFailure, Unit>> log(String log, {String? deviceId});
}
