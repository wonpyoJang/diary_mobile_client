import 'package:diary_mobile_client/src/core/failure/failure.dart';

class RemoteConfigFailure extends Failure {
  const RemoteConfigFailure(
      {required super.message, super.code, super.details});
}
