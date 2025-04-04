import 'package:diary_mobile_client/src/core/failure/failure.dart';

class LocalFailure extends Failure {
  const LocalFailure({
    required super.message,
    super.code,
    super.details,
  });
}
