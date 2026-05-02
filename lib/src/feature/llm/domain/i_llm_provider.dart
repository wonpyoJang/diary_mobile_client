import 'package:fpdart/fpdart.dart';
import 'failures/llm_failure.dart';
import 'llm_request.dart';

abstract class ILlmProvider {
  String get providerId;
  Future<bool> isAvailable();
  Future<Either<LlmFailure, String>> generateText(LlmRequest request);
}
