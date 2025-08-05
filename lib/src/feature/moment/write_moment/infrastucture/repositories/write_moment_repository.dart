import 'dart:io';

import 'package:diary_mobile_client/src/core/device/infrastructure/interfaces/i_device_info_local_provider.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/interfaces/i_media_info_local_provider.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/interface/i_write_moment_repository.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_internal_provider.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_external_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@LazySingleton(as: IWriteMomentRepository)
class WriteMomentRepository implements IWriteMomentRepository {
  final IWriteMomentExternalProvider writeMomentExternalProvider;
  final IWriteMomentInternalProvider writeMomentInternalProvider;
  final IDeviceInfoLocalProvider deviceInfoLocalProvider;
  final IMeidaInfoLocalProvider mediaInfoLocalProvider;
  WriteMomentRepository({
    required this.writeMomentExternalProvider,
    required this.writeMomentInternalProvider,
    required this.deviceInfoLocalProvider,
    required this.mediaInfoLocalProvider,
  });

  @override
  Future<Either<WriteMomentFailure, List<File>>> selectMedias() async {
    final result = await mediaInfoLocalProvider.selectMedias();

    return result.fold(
      (failure) => left(SelectMediasFailed(message: failure.message)),
      (medias) async {
        List<File> files = medias.map((e) => File(e.path)).toList();
        final saveResultOrFailure = await mediaInfoLocalProvider.saveMedias(
          files.map((e) => e.readAsBytesSync()).toList(),
          files.map((e) => e.path).toList(),
        );

        return saveResultOrFailure.fold(
          (failure) => left(SelectMediasFailed(message: failure.message)),
          (_) => right(files),
        );
      },
    );
  }

  @override
  Future<Either<WriteMomentFailure, Moment>> analyze(Moment moment) async {
    final result =
        await writeMomentExternalProvider.analyze(MomentDto.fromDomain(moment));

    return await result.fold(
      (failure) => left(MomentAnalyzeFailed(message: failure.message)),
      (emotionalIntensityDtos) async {
        final emotionalIntensities =
            emotionalIntensityDtos.map((e) => e.toDomain()).toList();

        final fidOrFailure = await writeMomentExternalProvider.getFirebaseId();

        final log =
            """[일기]\n\n일기 날짜: ${moment.getFormattedDay()}\n${moment.reflection}\n------------------------------------\n[메타 데이터]\n\n감정분석일시: ${DateFormat('yy년 MM월 dd일 EEEE a hh시 mm분 ss초', 'ko').format(DateTime.now())}\nAI가 분석한 감정: ${emotionalIntensities.map((e) => "${e.emotion.koName} (${e.intensity})").join(', ')}\n\n${fidOrFailure.fold((failure) => "유저 ID:Unknown User", (fid) => "유저 ID: $fid")}""";

        return (await writeMomentInternalProvider.log(log,
                deviceId: fidOrFailure.fold((failure) => null, (fid) => fid)))
            .fold(
          (failure) => right(
              moment.copyWith(emotionalIntensities: emotionalIntensities)),
          (response) => right(
              moment.copyWith(emotionalIntensities: emotionalIntensities)),
        );
      },
    );
  }

  @override
  Future<Either<WriteMomentFailure, String>> describeImage(
      Moment moment) async {
    final result = await writeMomentExternalProvider
        .describeImage(MomentDto.fromDomain(moment));

    return result.fold(
      (failure) => left(MomentDescribeImageFailed(message: failure.message)),
      (description) => right(description),
    );
  }
}
