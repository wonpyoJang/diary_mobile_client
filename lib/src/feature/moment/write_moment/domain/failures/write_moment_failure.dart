import 'package:diary_mobile_client/src/core/failure/failure.dart';

class WriteMomentFailure extends Failure {
  const WriteMomentFailure({
    required super.message,
    super.code,
    super.details,
  });
}
