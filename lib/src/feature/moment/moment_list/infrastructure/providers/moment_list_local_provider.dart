import 'dart:collection';
import 'dart:io';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/emotional_intensity.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/infrastructure/interfaces/i_moment_list_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:table_calendar/table_calendar.dart';

@Injectable(as: IMomentListLocalProvider)
class MomentListLocalProvider implements IMomentListLocalProvider {
  final Database _database;

  MomentListLocalProvider(this._database);

  @override
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getAllMoments() async {
    try {
      // 데이터베이스에서 모든 일기 데이터를 가져옵니다
      final momentDataList =
          await _database.select(_database.momentTable).get();

      // MomentTableData를 Moment 엔티티로 변환합니다
      final moments = LinkedHashMap<DateTime, List<Moment>>(
        equals: isSameDay,
        hashCode: getHashCode,
      );

      for (final momentData in momentDataList) {
        // 감정 강도 데이터를 가져옵니다
        final emotionalIntensitiesData =
            await (_database.select(_database.emotionalIntensityTable)
                  ..where((tbl) => tbl.momentId.equals(momentData.id)))
                .get();

        // 감정 강도 엔티티로 변환합니다
        final emotionalIntensities = emotionalIntensitiesData
            .map((data) => EmotionalIntensity(
                  emotion: data.emotion,
                  intensity: data.intensity,
                ))
            .toList();

        // 미디어 데이터를 가져옵니다
        final medias = <File>[];

        // Moment 엔티티를 생성합니다
        final moment = Moment(
          id: momentData.id,
          reflection: momentData.reflection,
          date: momentData.date,
          modifiedAt: momentData.modifiedAt,
          emotionalIntensities: emotionalIntensities,
          medias: medias,
        );

        // 날짜별로 그룹화합니다
        if (moments.containsKey(moment.date)) {
          moments[moment.date]!.add(moment);
        } else {
          moments[moment.date] = [moment];
        }
      }

      return right(moments);
    } catch (e) {
      return left(LocalFailure(message: '일기 목록을 가져오는 중 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<LocalFailure, List<Moment>>> getMomentsByDate(
      DateTime date) async {
    try {
      // 특정 날짜의 일기 데이터를 가져옵니다
      final momentDataList = await (_database.select(_database.momentTable)
            ..where((tbl) => tbl.date.equals(date)))
          .get();

      final moments = <Moment>[];

      for (final momentData in momentDataList) {
        // 감정 강도 데이터를 가져옵니다
        final emotionalIntensitiesData =
            await (_database.select(_database.emotionalIntensityTable)
                  ..where((tbl) => tbl.momentId.equals(momentData.id)))
                .get();

        // 감정 강도 엔티티로 변환합니다
        final emotionalIntensities = emotionalIntensitiesData
            .map((data) => EmotionalIntensity(
                  emotion: data.emotion,
                  intensity: data.intensity,
                ))
            .toList();

        // 미디어 데이터를 가져옵니다
        final medias = <File>[];

        // Moment 엔티티를 생성합니다
        final moment = Moment(
          id: momentData.id,
          reflection: momentData.reflection,
          date: momentData.date,
          modifiedAt: momentData.modifiedAt,
          emotionalIntensities: emotionalIntensities,
          medias: medias,
        );

        moments.add(moment);
      }

      return right(moments);
    } catch (e) {
      return left(LocalFailure(message: '특정 날짜의 일기를 가져오는 중 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Either<LocalFailure, LinkedHashMap<DateTime, List<Moment>>>>
      getMomentsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      // TODO: Drift에서 날짜 범위 쿼리를 위한 적절한 메서드 구현 필요
      // 현재는 getAllMoments()를 사용하여 클라이언트에서 필터링
      final allMoments = await getAllMoments();

      return allMoments.fold(
        (failure) => left(failure),
        (moments) {
          final filteredMoments = LinkedHashMap<DateTime, List<Moment>>(
            equals: isSameDay,
            hashCode: getHashCode,
          );

          for (final entry in moments.entries) {
            if (entry.key
                    .isAfter(startDate.subtract(const Duration(days: 1))) &&
                entry.key.isBefore(endDate.add(const Duration(days: 1)))) {
              filteredMoments[entry.key] = entry.value;
            }
          }

          return right(filteredMoments);
        },
      );
    } catch (e) {
      return left(LocalFailure(message: '특정 기간의 일기를 가져오는 중 오류가 발생했습니다: $e'));
    }
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
