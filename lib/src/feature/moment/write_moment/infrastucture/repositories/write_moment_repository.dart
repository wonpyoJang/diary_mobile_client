import 'dart:io';

import 'package:diary_mobile_client/src/core/device/infrastructure/interfaces/i_device_info_local_provider.dart';
import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/interfaces/i_media_info_local_provider.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/common/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:diary_mobile_client/src/feature/data_control/application/data_control_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/interface/i_write_moment_repository.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_internal_provider.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_external_provider.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_local_provider.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:diary_mobile_client/src/core/drift/drift_client.dart';

@LazySingleton(as: IWriteMomentRepository)
class WriteMomentRepository implements IWriteMomentRepository {
  final IWriteMomentExternalProvider writeMomentExternalProvider;
  final IWriteMomentInternalProvider writeMomentInternalProvider;
  final IWriteMomentLocalProvider writeMomentLocalProvider;
  final IDeviceInfoLocalProvider deviceInfoLocalProvider;
  final IMeidaInfoLocalProvider mediaInfoLocalProvider;
  final DriftClient driftClient;

  WriteMomentRepository({
    required this.writeMomentExternalProvider,
    required this.writeMomentInternalProvider,
    required this.writeMomentLocalProvider,
    required this.deviceInfoLocalProvider,
    required this.mediaInfoLocalProvider,
    required this.driftClient,
  });

  @override
  Future<Either<WriteMomentFailure, List<File>>> selectMedias() async {
    final result = await mediaInfoLocalProvider.selectMedias();

    return result.fold(
      (failure) => left(SelectMediasFailed(message: failure.message)),
      (medias) async {
        final saveResultOrFailure = await mediaInfoLocalProvider.saveMedias(
          medias,
        );

        return saveResultOrFailure.fold(
          (failure) => left(SelectMediasFailed(message: failure.message)),
          (savedFiles) => right(savedFiles),
        );
      },
    );
  }

  @override
  Future<Either<WriteMomentFailure, Moment>> analyze(Moment moment) async {
    final momentDto = MomentDto.fromDomain(moment);

    return await TaskEither<WriteMomentFailure, List<EmotionalIntensityDto>>(
      () async {
        final res = await writeMomentExternalProvider.analyze(momentDto);
        return res.mapLeft((f) => MomentAnalyzeFailed(message: f.message));
      },
    )
        // save local and keep dtos
        .flatMap((dtos) =>
            TaskEither<WriteMomentFailure, List<EmotionalIntensityDto>>(
              () async {
                final res = await writeMomentLocalProvider
                    .saveEmotionalIntensities(moment.id, dtos);
                return res
                    .map((_) => dtos)
                    .mapLeft((f) => MomentAnalyzeFailed(message: f.message));
              },
            ))
        // decide log and carry (dtos, fid?)
        .flatMap((dtos) {
      final intensities = dtos.map((e) => e.toDomain()).toList();
      // [변경] DataControl 상태까지 함께 확인
      final allowed = getIt<DataControlBloc>().state.allowedSendDataToServer;
      final shouldLog = intensities.isNotEmpty && allowed;
      if (!shouldLog) {
        return TaskEither<WriteMomentFailure,
            (List<EmotionalIntensityDto>, String?)>(
          () async => right((dtos, null)),
        );
      }
      return TaskEither<WriteMomentFailure,
          (List<EmotionalIntensityDto>, String?)>(
        () async {
          final res = await writeMomentExternalProvider.getFirebaseId();
          return res
              .map((fid) => (dtos, fid))
              .mapLeft((f) => MomentAnalyzeFailed(message: f.message));
        },
      );
    })
        // log (if needed) and return final Moment; swallow log failure
        .flatMap((tuple) {
      final dtos = tuple.$1;
      final fid = tuple.$2;
      final intensities = dtos.map((e) => e.toDomain()).toList();
      if (fid == null) {
        return TaskEither<WriteMomentFailure, Moment>(
          () async => right(moment.copyWith(emotionalIntensities: intensities)),
        );
      }

      final log =
          """[일기]\n\n일기 날짜: ${moment.getFormattedDay()}\n${moment.reflection}\n------------------------------------\n[메타 데이터]\n\n감정분석일시: ${DateFormat('yy년 MM월 dd일 EEEE a hh시 mm분 ss초', 'ko').format(DateTime.now())}\nAI가 분석한 감정: ${intensities.map((e) => "${e.emotion.enName} (${e.intensity})").join(', ')}\n\n유저 ID: $fid""";

      return TaskEither<WriteMomentFailure, Moment>(
        () async {
          // 로깅 실패는 결과에 영향 주지 않음
          await writeMomentInternalProvider.log(log, deviceId: fid);
          return right(moment.copyWith(emotionalIntensities: intensities));
        },
      );
    }).run();
  }

  @override
  Future<Either<WriteMomentFailure, String>> describeImage(
      Moment moment) async {
    final result = await writeMomentExternalProvider
        .describeImage(MomentDto.fromDomain(moment));

    return result.fold(
      (failure) => left(MomentDescribeImageFailed(message: failure.message)),
      (description) {
        return writeMomentLocalProvider
            .updateMoment(
              MomentDto.fromDomain(moment.copyWith(
                  reflection: moment.reflection.isEmpty
                      ? description
                      : "${moment.reflection}\n\n$description")),
            )
            .then((result) => result.fold(
                  (failure) =>
                      left(MomentDescribeImageFailed(message: failure.message)),
                  (_) => right(moment.reflection.isEmpty
                      ? description
                      : "${moment.reflection}\n\n$description"),
                ));
      },
    );
  }

  @override
  Future<Either<WriteMomentFailure, Unit>> saveMoment(Moment moment) async {
    final momentDto = MomentDto.fromDomain(moment);
    return await driftClient.runQuery<Unit>((db) async {
      return await db.transaction(() async {
        // moment 저장
        final result = await writeMomentLocalProvider.saveMomentOnly(momentDto);
        if (result.isLeft()) {
          throw Exception(result.getLeft());
        }
        // intensity 저장
        final intensityResult =
            await writeMomentLocalProvider.saveEmotionalIntensities(
          momentDto.id,
          momentDto.emotionalIntensities,
        );

        if (intensityResult.isLeft()) {
          throw Exception(intensityResult.getLeft());
        }
        return unit;
      });
    }, description: 'saveMoment (transaction)').then((result) => result.fold(
          (failure) => left(SaveMomentFailed(message: failure.message)),
          (_) => right(unit),
        ));
  }

  @override
  Future<Either<WriteMomentFailure, Unit>> saveMedias(
    String momentId,
    List<File> medias,
  ) async {
    final mediaPaths = medias.map((file) => file.path).toList();
    final result =
        await writeMomentLocalProvider.saveMedia(momentId, mediaPaths);

    return result.fold(
      (failure) => left(SaveMediaFailed(message: failure.message)),
      (_) => right(unit),
    );
  }

  @override
  Future<Either<WriteMomentFailure, Unit>> updateMoment(Moment moment) async {
    final result = await writeMomentLocalProvider.updateMoment(
      MomentDto.fromDomain(moment),
    );

    return result.fold(
      (failure) => left(SaveMomentFailed(message: failure.message)),
      (_) => right(unit),
    );
  }

  @override
  Future<Either<WriteMomentFailure, Unit>> updateMedias(
    String momentId,
    List<File> medias,
  ) async {
    final mediaPaths = medias.map((file) => file.path).toList();
    final result =
        await writeMomentLocalProvider.updateMedia(momentId, mediaPaths);

    return result.fold(
      (failure) => left(SaveMediaFailed(message: failure.message)),
      (_) => right(unit),
    );
  }

  @override
  Future<Either<WriteMomentFailure, Unit>> deleteMedias(
    String momentId,
    List<String> mediaIds,
  ) async {
    final result =
        await writeMomentLocalProvider.deleteMedias(momentId, mediaIds);

    return result.fold(
      (failure) => left(SaveMediaFailed(message: failure.message)),
      (_) => right(unit),
    );
  }

  @override
  Future<Either<WriteMomentFailure, List<MediaInfo>>> fetchMediasByMomentId(
    String momentId,
  ) async {
    final result =
        await writeMomentLocalProvider.fetchMediaByMomentId(momentId);

    return result.fold(
      (failure) => left(FetchMediaByMomentIdFailed(message: failure.message)),
      (medias) => right(medias.map((e) => e.toDomain()).toList()),
    );
  }
}
