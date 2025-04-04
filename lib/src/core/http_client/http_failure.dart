import 'package:diary_mobile_client/src/core/failure/failure.dart';

class HttpFailure extends Failure {
  const HttpFailure({
    required super.message,
    super.code,
    super.details,
  });
}