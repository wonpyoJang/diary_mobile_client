import 'package:diary_mobile_client/src/core/failure/failure.dart';

class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.message,
    super.code,
    super.details,
  });
}
