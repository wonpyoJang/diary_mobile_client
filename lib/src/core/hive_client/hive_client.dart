import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../failure/local_failure.dart';

/// Hive 기반 로컬 스토리지 클라이언트 인터페이스
abstract class HiveClient {
  /// Hive 초기화
  Future<Either<LocalFailure, Unit>> initialize();

  /// 박스 열기 (존재하지 않으면 생성)
  Future<Either<LocalFailure, Unit>> openBox<T>(String boxName);

  /// 값 저장
  Future<Either<LocalFailure, Unit>> put<T>(
    String boxName,
    String key,
    T value,
  );

  /// 값 조회
  Future<Either<LocalFailure, T?>> get<T>(String boxName, String key);

  /// 값 삭제
  Future<Either<LocalFailure, Unit>> delete(String boxName, String key);

  /// 박스 비우기
  Future<Either<LocalFailure, Unit>> clearBox(String boxName);

  /// 박스 길이
  Future<Either<LocalFailure, int>> getBoxLength(String boxName);

  /// 키 존재 여부
  Future<Either<LocalFailure, bool>> containsKey(String boxName, String key);

  /// 모든 키 조회
  Future<Either<LocalFailure, List<String>?>> getAllKeys(String boxName);

  /// 모든 값 조회
  Future<Either<LocalFailure, List<T>?>> getAllValues<T>(String boxName);

  /// 박스가 비어있는지 확인
  Future<Either<LocalFailure, bool>> isBoxEmpty(String boxName);

  /// 특정 박스 닫기
  Future<Either<LocalFailure, Unit>> closeBox(String boxName);

  /// 모든 박스 닫기
  Future<Either<LocalFailure, Unit>> closeAllBoxes();
}

@LazySingleton(as: HiveClient)
class HiveClientImpl implements HiveClient {
  const HiveClientImpl();

  @override
  Future<Either<LocalFailure, Unit>> initialize() async {
    try {
      try {
        await Hive.initFlutter();
      } catch (e) {
        // 테스트 등 경로 제공이 필요한 환경에서 임시 디렉터리로 초기화
        final Directory tempDir =
            await Directory.systemTemp.createTemp('hive_');
        Hive.init(tempDir.path);
      }
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: 'Hive 초기화 실패',
        code: 'HIVE_INIT_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> openBox<T>(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<dynamic>(boxName);
      }
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '박스 열기 실패: $boxName',
        code: 'HIVE_OPEN_BOX_ERROR',
        details: e.toString(),
      ));
    }
  }

  Future<Box<dynamic>> _ensureOpenBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return Hive.openBox<dynamic>(boxName);
    }
    return Hive.box<dynamic>(boxName);
  }

  @override
  Future<Either<LocalFailure, Unit>> put<T>(
    String boxName,
    String key,
    T value,
  ) async {
    try {
      final box = await _ensureOpenBox(boxName);
      await box.put(key, value);
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '데이터 저장 실패: $boxName/$key',
        code: 'HIVE_PUT_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, T?>> get<T>(String boxName, String key) async {
    try {
      final box = await _ensureOpenBox(boxName);
      final value = box.get(key) as T?;
      return right(value);
    } catch (e) {
      return left(LocalFailure(
        message: '데이터 조회 실패: $boxName/$key',
        code: 'HIVE_GET_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> delete(String boxName, String key) async {
    try {
      final box = await _ensureOpenBox(boxName);
      await box.delete(key);
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '데이터 삭제 실패: $boxName/$key',
        code: 'HIVE_DELETE_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> clearBox(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        // 타입을 모를 수 있으니 dynamic 박스를 엽니다
        await Hive.openBox<dynamic>(boxName);
      }
      final box = Hive.box(boxName);
      await box.clear();
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '박스 초기화 실패: $boxName',
        code: 'HIVE_CLEAR_BOX_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, int>> getBoxLength(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<dynamic>(boxName);
      }
      final box = Hive.box(boxName);
      return right(box.length);
    } catch (e) {
      return left(LocalFailure(
        message: '박스 길이 조회 실패: $boxName',
        code: 'HIVE_BOX_LENGTH_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, bool>> containsKey(
    String boxName,
    String key,
  ) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<dynamic>(boxName);
      }
      final box = Hive.box(boxName);
      return right(box.containsKey(key));
    } catch (e) {
      return left(LocalFailure(
        message: '키 존재 확인 실패: $boxName/$key',
        code: 'HIVE_CONTAINS_KEY_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, List<String>?>> getAllKeys(
    String boxName,
  ) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<dynamic>(boxName);
      }
      final box = Hive.box(boxName);
      final keys = box.keys.cast<String>().toList();
      return right(keys);
    } catch (e) {
      return left(LocalFailure(
        message: '모든 키 조회 실패: $boxName',
        code: 'HIVE_GET_ALL_KEYS_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, List<T>?>> getAllValues<T>(
    String boxName,
  ) async {
    try {
      final box = await _ensureOpenBox(boxName);
      final values = box.values.cast<T>().toList();
      return right(values);
    } catch (e) {
      return left(LocalFailure(
        message: '모든 값 조회 실패: $boxName',
        code: 'HIVE_GET_ALL_VALUES_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, bool>> isBoxEmpty(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<dynamic>(boxName);
      }
      final box = Hive.box(boxName);
      return right(box.isEmpty);
    } catch (e) {
      return left(LocalFailure(
        message: '박스 빈 상태 확인 실패: $boxName',
        code: 'HIVE_IS_EMPTY_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> closeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.close();
      }
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '박스 닫기 실패: $boxName',
        code: 'HIVE_CLOSE_BOX_ERROR',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<LocalFailure, Unit>> closeAllBoxes() async {
    try {
      await Hive.close();
      return right(unit);
    } catch (e) {
      return left(LocalFailure(
        message: '모든 박스 닫기 실패',
        code: 'HIVE_CLOSE_ALL_ERROR',
        details: e.toString(),
      ));
    }
  }
}

/// fpdart Either 간편 접근 확장 (테스트 호환용)
extension EitherGetters<L, R> on Either<L, R> {
  R? get right => fold((_) => null, (r) => r);
  L? get left => fold((l) => l, (_) => null);
}
