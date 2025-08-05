import 'package:diary_mobile_client/src/core/firebase/firebase_failure.dart';
import 'package:diary_mobile_client/src/core/llm/llm_failure.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract class IWriteMomentExternalProvider {
  Future<Either<FirebaseFailure, String>> getFirebaseId();

  Future<Either<LLMFailure, List<EmotionalIntensityDto>>> analyze(
      MomentDto text);

  Future<Either<LLMFailure, String>> describeImage(MomentDto text);
}
