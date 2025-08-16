import 'dart:io';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/emotional_intensity_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/infrastructure/dtos/moment_dto.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/providers/write_moment_local_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:fpdart/fpdart.dart';
import 'package:diary_mobile_client/src/core/drift/drift_client.dart';

void main() {
  late Database database;
  late WriteMomentLocalProvider provider;
  late Directory dbDir;
  late String dbPath;

  setUp(() async {
    // 프로젝트 내 build/test_db/ 경로 사용
    dbDir = Directory(p.join(Directory.current.path, 'build', 'test_db'));
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    dbPath = p.join(
        dbDir.path, 'test_${DateTime.now().microsecondsSinceEpoch}.sqlite');
    database = Database(dbPath);
    provider = WriteMomentLocalProvider(DriftClientImpl(database));
  });

  tearDown(() async {
    await database.close();
    if (await File(dbPath).exists()) {
      await File(dbPath).delete();
    }
    // build/test_db 디렉토리는 남겨둠 (다른 테스트 영향 방지)
  });

  test('saveMoment & updateMoment: 저장/수정 성공', () async {
    final moment = MomentDto(
      id: 'moment1',
      reflection: '테스트 일기',
      date: DateTime.now().toIso8601String(),
      modifiedAt: DateTime.now().toIso8601String(),
      emotionalIntensities: [
        EmotionalIntensityDto(emotion: 'joy', intensity: 0.8),
      ],
      medias: [],
    );
    final saveResult = await provider.saveMoment(moment);
    expect(saveResult.isRight(), true);

    final updated = moment.copyWith(reflection: '수정된 일기');
    final updateResult = await provider.updateMoment(updated);
    expect(updateResult.isRight(), true);
  });

  test('saveMedia & updateMedia & deleteMedias: 미디어 저장/수정/삭제', () async {
    // 임시 파일 생성
    final file =
        await File(p.join(dbDir.path, 'test.png')).writeAsBytes([1, 2, 3, 4]);
    final moment = MomentDto(
      id: 'moment2',
      reflection: '미디어 테스트',
      date: DateTime.now().toIso8601String(),
      modifiedAt: DateTime.now().toIso8601String(),
      emotionalIntensities: [],
      medias: [],
    );
    await provider.saveMoment(moment);
    final saveMediaResult = await provider.saveMedia(moment.id, [file.path]);
    expect(saveMediaResult.isRight(), true);

    final fetchResult = await provider.fetchMediaByMomentId(moment.id);
    expect(fetchResult.isRight(), true);
    final mediaList = fetchResult.getOrElse((_) => []);
    expect(mediaList.length, 1);

    // updateMedia
    final file2 =
        await File(p.join(dbDir.path, 'test2.png')).writeAsBytes([5, 6, 7, 8]);
    final updateMediaResult =
        await provider.updateMedia(moment.id, [file2.path]);
    expect(updateMediaResult.isRight(), true);
    final fetchResult2 = await provider.fetchMediaByMomentId(moment.id);
    final mediaList2 = fetchResult2.getOrElse((_) => []);
    expect(mediaList2.length, 1);

    // deleteMedias
    final ids = mediaList2.map((e) => e.id).toList();
    final deleteResult = await provider.deleteMedias(moment.id, ids);
    expect(deleteResult.isRight(), true);
    final fetchResult3 = await provider.fetchMediaByMomentId(moment.id);
    expect(fetchResult3.getOrElse((_) => []).isEmpty, true);
  });

  test('saveMedia: 존재하지 않는 파일 저장 시 실패', () async {
    final moment = MomentDto(
      id: 'moment3',
      reflection: '파일 없음',
      date: DateTime.now().toIso8601String(),
      modifiedAt: DateTime.now().toIso8601String(),
      emotionalIntensities: [],
      medias: [],
    );
    await provider.saveMoment(moment);
    final result = await provider.saveMedia(moment.id, ['/not/exist/file.png']);
    expect(result.isLeft(), true);
  });
}

extension on MomentDto {
  MomentDto copyWith({
    String? id,
    String? reflection,
    String? date,
    String? modifiedAt,
    List<EmotionalIntensityDto>? emotionalIntensities,
    List<File>? medias,
  }) {
    return MomentDto(
      id: id ?? this.id,
      reflection: reflection ?? this.reflection,
      date: date ?? this.date,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      emotionalIntensities: emotionalIntensities ?? this.emotionalIntensities,
      medias: medias ?? this.medias,
    );
  }
}
