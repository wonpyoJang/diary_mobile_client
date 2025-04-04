import 'package:diary_mobile_client/src/core/failure/failure.dart';

class LLMFailure extends Failure {
  const LLMFailure({
    required super.message,
    super.code,
    super.details,
  });
}
