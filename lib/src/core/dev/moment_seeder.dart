import 'dart:math';

import 'package:diary_mobile_client/src/core/drift/drift_client.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/database/app_database.dart';
import 'package:diary_mobile_client/src/feature/common/moment/domain/enums/emotion.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// 개발자 도구 화면에서 호출하는 더미 데이터 시더.
///
/// 100편의 임의 일기와 1~3개의 감정 강도 레코드를 단일 트랜잭션으로 삽입한다.
/// kDebugMode 가드는 호출 측(개발자 도구 페이지) 에서 책임진다.
@LazySingleton()
class MomentSeeder {
  static const int defaultSeedCount = 100;

  final DriftClient _driftClient;

  MomentSeeder(this._driftClient);

  /// 더미 일기를 [count]편 즉시 추가한다. 기존 데이터는 유지된다.
  Future<Either<LocalFailure, int>> seedNow({
    int count = defaultSeedCount,
  }) async {
    debugPrint('[MomentSeeder] $count편 더미 일기 생성 시작');
    final result = await _driftClient.runQuery<int>((db) async {
      return db.transaction<int>(() => _insertMoments(db, count));
    }, description: 'seedMoments');
    result.fold(
      (failure) => debugPrint('[MomentSeeder] 시드 실패: ${failure.message}'),
      (n) => debugPrint('[MomentSeeder] 시드 완료: $n 편'),
    );
    return result;
  }

  /// 모든 moment / emotionalIntensity / media 레코드를 삭제한다.
  Future<Either<LocalFailure, Unit>> clearAll() async {
    debugPrint('[MomentSeeder] 전체 데이터 삭제 시작');
    final result = await _driftClient.runQuery<Unit>((db) async {
      await db.transaction(() async {
        await db.delete(db.emotionalIntensityTable).go();
        await db.delete(db.mediaTable).go();
        await db.delete(db.momentTable).go();
      });
      return unit;
    }, description: 'clearAllMoments');
    result.fold(
      (failure) => debugPrint('[MomentSeeder] 삭제 실패: ${failure.message}'),
      (_) => debugPrint('[MomentSeeder] 삭제 완료'),
    );
    return result;
  }

  /// 현재 저장된 일기(moment) 개수.
  Future<Either<LocalFailure, int>> getCurrentMomentCount() async {
    return _driftClient.runQuery<int>((db) async {
      final countExpr = db.momentTable.id.count();
      final query = db.selectOnly(db.momentTable)..addColumns([countExpr]);
      final row = await query.getSingle();
      return row.read(countExpr) ?? 0;
    }, description: 'getCurrentMomentCount');
  }

  Future<int> _insertMoments(Database db, int count) async {
    final rng = Random(DateTime.now().millisecondsSinceEpoch);
    const uuid = Uuid();
    final now = DateTime.now();
    var inserted = 0;

    for (var i = 0; i < count; i++) {
      final id = uuid.v4();
      final reflection = _pickReflection(rng, i);
      final daysAgo = rng.nextInt(180);
      final hour = rng.nextInt(24);
      final minute = rng.nextInt(60);
      final date =
          DateTime(now.year, now.month, now.day - daysAgo, hour, minute);

      await db.into(db.momentTable).insertOnConflictUpdate(
            MomentTableCompanion.insert(
              id: id,
              reflection: reflection,
              date: date,
              modifiedAt: date,
            ),
          );

      final emotionCount = 1 + rng.nextInt(3);
      final picked = <Emotion>{};
      while (picked.length < emotionCount) {
        picked.add(Emotion.values[rng.nextInt(Emotion.values.length)]);
      }

      for (final emotion in picked) {
        final intensity = 0.3 + rng.nextDouble() * 0.7;
        await db.into(db.emotionalIntensityTable).insert(
              EmotionalIntensityTableCompanion.insert(
                id: '${id}_${emotion.name}',
                emotion: emotion,
                intensity: double.parse(intensity.toStringAsFixed(3)),
                momentId: id,
              ),
            );
      }
      inserted++;
    }
    return inserted;
  }

  String _pickReflection(Random rng, int index) {
    final template = _templates[rng.nextInt(_templates.length)];
    final mood = _moods[rng.nextInt(_moods.length)];
    return '$template $mood (#${index + 1})';
  }

  static const List<String> _templates = [
    '오늘 아침에는 일찍 일어나서 산책을 다녀왔다.',
    '회사에서 동료와 오랜만에 점심을 같이 먹었다.',
    '집 근처 카페에서 책을 한참 읽었다.',
    '오랜만에 친구를 만나 이야기를 많이 나눴다.',
    '저녁에 가족과 함께 식사를 했다.',
    '운동을 하고 나니 머리가 한결 개운해졌다.',
    '날씨가 흐려서 하루 종일 기분이 가라앉았다.',
    '새로운 프로젝트를 시작했다.',
    '면접 준비를 하느라 늦게까지 깨어 있었다.',
    '오늘은 평소보다 출근길이 한산했다.',
    '점심시간에 잠깐 햇볕을 쬐며 걸었다.',
    '주말이 빨리 왔으면 좋겠다.',
    '최근에 본 영화의 장면이 자꾸 떠오른다.',
    '엄마와 통화를 오래 했다.',
    '강아지와 놀아주는 시간이 가장 행복하다.',
    '예전에 즐겨 듣던 노래를 다시 들었다.',
    '회의가 길어져서 지쳤다.',
    '집에 돌아와 따뜻한 차를 마셨다.',
    '오랜만에 일기를 쓰니 마음이 정리된다.',
    '할 일이 많지만 천천히 해보려 한다.',
    '오랜만에 등산을 했다. 정상에서 본 풍경이 인상적이었다.',
    '동네 도서관에 들러 책을 빌렸다.',
    '잠을 잘 못 자서 하루 종일 멍했다.',
    '예상치 못한 칭찬을 들어서 기분이 좋아졌다.',
    '실수한 일이 자꾸 생각나서 잠이 안 왔다.',
    '오늘은 글이 잘 써져서 만족스러웠다.',
    '지하철에서 우연히 옛 친구를 만났다.',
    '새 노트북을 사용해보니 작업 속도가 빨라졌다.',
    '저녁노을이 유난히 붉었다.',
    '며칠째 같은 고민이 머리를 떠나지 않는다.',
  ];

  static const List<String> _moods = [
    '하루의 마무리가 평온했다.',
    '괜히 마음이 분주했다.',
    '이상하게 외로움이 밀려왔다.',
    '잔잔한 만족감이 들었다.',
    '몸은 피곤했지만 마음은 가벼웠다.',
    '내일이 조금 두렵다.',
    '그래도 오늘은 괜찮은 하루였다.',
    '작은 성취감이 따라왔다.',
    '뭔가 새로운 시작이 필요한 듯했다.',
    '익숙한 일상이 새삼 고마웠다.',
  ];
}
