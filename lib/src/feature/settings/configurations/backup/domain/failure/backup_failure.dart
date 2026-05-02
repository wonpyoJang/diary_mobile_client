import 'package:diary_mobile_client/src/core/failure/failure.dart';

class BackupFailure extends Failure {
  const BackupFailure({required super.message, super.code, super.details});
}
