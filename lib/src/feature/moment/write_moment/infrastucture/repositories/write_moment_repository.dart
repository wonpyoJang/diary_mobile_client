import 'package:diary_mobile_client/src/core/device/infrastructure/interfaces/i_device_info_local_provider.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/interface/i_write_moment_repository.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_internal_provider.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_external_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IWriteMomentRepository)
class WriteMomentRepository implements IWriteMomentRepository {
  final IWriteMomentExternalProvider writeMomentExternalProvider;
  final IWriteMomentInternalProvider writeMomentInternalProvider;
  final IDeviceInfoLocalProvider deviceInfoLocalProvider;
  WriteMomentRepository({
    required this.writeMomentExternalProvider,
    required this.writeMomentInternalProvider,
    required this.deviceInfoLocalProvider,
  });

  @override
  Future<Either<WriteMomentFailure, Moment>> analyze(Moment moment) async {
    final result =
        await writeMomentExternalProvider.analyze(MomentDto.fromDomain(moment));

    return await result.fold(
      (failure) => left(MomentAnalyzeFailed(message: failure.message)),
      (emotionalIntensityDtos) async {
        final emotionalIntensities =
            emotionalIntensityDtos.map((e) => e.toDomain()).toList();

        final log = """
        일기: ${moment.reflection}
        감정: ${emotionalIntensities.map((e) => e.toString()).join(', ')}
        """;

        return (await writeMomentInternalProvider.log(log)).fold(
          (failure) => right(
              moment.copyWith(emotionalIntensities: emotionalIntensities)),
          (response) => right(
              moment.copyWith(emotionalIntensities: emotionalIntensities)),
        );
      },
    );
  }
}
