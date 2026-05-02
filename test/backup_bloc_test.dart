import 'dart:io';

import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_bloc.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_state.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/repositories/interfaces/i_backup_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class _MockBackupRepository implements IBackupRepository {
  Future<Either<BackupFailure, Unit>> Function()? onUpload;
  Future<Either<BackupFailure, List<String>>> Function()? onListICloudFiles;
  Future<Either<BackupFailure, Unit>> Function()? onExportZip;
  Future<Either<BackupFailure, Unit>> Function()? onExportCsv;
  Future<Either<BackupFailure, Unit>> Function()? onExportCsvWithMedia;
  Future<Either<BackupFailure, Unit>> Function(String)? onDownload;

  @override
  Future<Either<BackupFailure, Unit>> uploadDatabase() =>
      onUpload?.call() ?? Future.value(right(unit));

  @override
  Future<Either<BackupFailure, Unit>> downloadFromICloud(String fileName) =>
      onDownload?.call(fileName) ?? Future.value(right(unit));

  @override
  Future<Either<BackupFailure, List<String>>> listICloudFiles() =>
      onListICloudFiles?.call() ?? Future.value(right(const <String>[]));

  @override
  Future<Either<BackupFailure, Unit>> exportDatabaseZipToUserICloud() =>
      onExportZip?.call() ?? Future.value(right(unit));

  @override
  Future<Either<BackupFailure, Unit>> exportMomentsCsvToUserICloud() =>
      onExportCsv?.call() ?? Future.value(right(unit));

  @override
  Future<Either<BackupFailure, Unit>> exportMomentsCsvWithMediaZipToUserICloud() =>
      onExportCsvWithMedia?.call() ?? Future.value(right(unit));
}

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('hydrated_backup_test_');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });

  setUp(() async {
    await HydratedBloc.storage.clear();
  });

  group('BackupState', () {
    test('기본 생성자는 모든 필드가 null/false 기본값을 가져야 함', () {
      const state = BackupState();
      expect(state.lastBackupDate, isNull);
      expect(state.failure, isNull);
      expect(state.successMessage, isNull);
      expect(state.isLoading, isFalse);
      expect(state.files, isNull);
    });

    test('copyWith는 명시한 필드만 변경해야 함', () {
      const original = BackupState();
      final updated = original.copyWith(isLoading: true);
      expect(updated.isLoading, isTrue);
      expect(updated.lastBackupDate, isNull);
      expect(updated.successMessage, isNull);
    });

    test('clearFailure: true 는 failure 를 null 로 만들어야 함', () {
      const failure = BackupFailure(message: 'oops');
      const stateWithFailure = BackupState(failure: failure);
      final cleared = stateWithFailure.copyWith(clearFailure: true);
      expect(cleared.failure, isNull);
    });

    test('clearSuccess: true 는 successMessage 를 null 로 만들어야 함', () {
      const stateWithSuccess = BackupState(successMessage: '완료');
      final cleared = stateWithSuccess.copyWith(clearSuccess: true);
      expect(cleared.successMessage, isNull);
    });

    test('Equatable 동등성: 동일 값은 equal, 다르면 not equal', () {
      final date = DateTime(2026, 5, 1);
      final s1 = BackupState(lastBackupDate: date, isLoading: true);
      final s2 = BackupState(lastBackupDate: date, isLoading: true);
      final s3 = BackupState(lastBackupDate: date, isLoading: false);
      expect(s1, equals(s2));
      expect(s1.hashCode, equals(s2.hashCode));
      expect(s1, isNot(equals(s3)));
    });
  });

  group('BackupEvent', () {
    test('서로 다른 이벤트 클래스는 동등하지 않아야 함', () {
      expect(UploadBackup(), isNot(equals(FetchICloudFiles())));
      expect(ExportBackupToUserICloud(),
          isNot(equals(ExportMomentsCsvToUserICloud())));
    });

    test('같은 종류의 이벤트는 동등해야 함', () {
      expect(UploadBackup(), equals(UploadBackup()));
      expect(ClearBackupMessage(), equals(ClearBackupMessage()));
    });

    test('모든 이벤트가 BackupEvent 의 하위 타입이어야 함', () {
      expect(UploadBackup(), isA<BackupEvent>());
      expect(FetchICloudFiles(), isA<BackupEvent>());
      expect(ExportBackupToUserICloud(), isA<BackupEvent>());
      expect(ExportMomentsCsvToUserICloud(), isA<BackupEvent>());
      expect(ExportMomentsCsvWithMediaZipToUserICloud(), isA<BackupEvent>());
      expect(ClearBackupMessage(), isA<BackupEvent>());
    });
  });

  group('BackupBloc — UploadBackup', () {
    test('성공 시 successMessage 와 lastBackupDate 가 설정되고 isLoading: false', () async {
      final repo = _MockBackupRepository()..onUpload = () async => right(unit);
      final bloc = BackupBloc(repo);

      bloc.add(UploadBackup());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BackupState>((s) => s.isLoading == true),
          predicate<BackupState>((s) =>
              !s.isLoading &&
              s.successMessage == 'iCloud 백업이 완료되었습니다' &&
              s.lastBackupDate != null),
        ]),
      );
      await bloc.close();
    });

    test('실패 시 failure 가 설정되고 successMessage 는 null', () async {
      const failure = BackupFailure(message: 'iCloud 미사용');
      final repo = _MockBackupRepository()
        ..onUpload = () async => left(failure);
      final bloc = BackupBloc(repo);

      bloc.add(UploadBackup());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BackupState>((s) => s.isLoading == true),
          predicate<BackupState>((s) =>
              !s.isLoading &&
              s.failure == failure &&
              s.successMessage == null),
        ]),
      );
      await bloc.close();
    });
  });

  group('BackupBloc — FetchICloudFiles', () {
    test('성공 시 files 가 채워지고 isLoading: false', () async {
      final repo = _MockBackupRepository()
        ..onListICloudFiles = () async => right(['a.zip', 'b.zip']);
      final bloc = BackupBloc(repo);

      bloc.add(FetchICloudFiles());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BackupState>((s) => s.isLoading == true),
          predicate<BackupState>((s) =>
              !s.isLoading &&
              s.files != null &&
              s.files!.length == 2 &&
              s.files!.first == 'a.zip'),
        ]),
      );
      await bloc.close();
    });

    test('실패 시 files 는 빈 배열로 떨어져야 함', () async {
      final repo = _MockBackupRepository()
        ..onListICloudFiles =
            () async => left(const BackupFailure(message: 'no creds'));
      final bloc = BackupBloc(repo);

      bloc.add(FetchICloudFiles());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BackupState>((s) => s.isLoading == true),
          predicate<BackupState>((s) =>
              !s.isLoading && s.files != null && s.files!.isEmpty),
        ]),
      );
      await bloc.close();
    });
  });

  group('BackupBloc — Export 시리즈', () {
    test('ExportBackupToUserICloud 성공 시 ZIP 메시지', () async {
      final repo = _MockBackupRepository()
        ..onExportZip = () async => right(unit);
      final bloc = BackupBloc(repo);
      bloc.add(ExportBackupToUserICloud());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<BackupState>((s) =>
            !s.isLoading &&
            s.successMessage == '데이터베이스를 ZIP으로 내보냈습니다')),
      );
      await bloc.close();
    });

    test('ExportMomentsCsvToUserICloud 성공 시 CSV 메시지', () async {
      final repo = _MockBackupRepository()
        ..onExportCsv = () async => right(unit);
      final bloc = BackupBloc(repo);
      bloc.add(ExportMomentsCsvToUserICloud());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<BackupState>(
            (s) => !s.isLoading && s.successMessage == 'CSV로 내보냈습니다')),
      );
      await bloc.close();
    });

    test('ExportMomentsCsvWithMediaZipToUserICloud 성공 시 CSV+사진 메시지', () async {
      final repo = _MockBackupRepository()
        ..onExportCsvWithMedia = () async => right(unit);
      final bloc = BackupBloc(repo);
      bloc.add(ExportMomentsCsvWithMediaZipToUserICloud());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<BackupState>((s) =>
            !s.isLoading &&
            s.successMessage == 'CSV와 사진을 ZIP으로 내보냈습니다')),
      );
      await bloc.close();
    });

    test('Export 실패 시 successMessage 는 null, failure 가 설정', () async {
      const failure = BackupFailure(message: '디스크 부족');
      final repo = _MockBackupRepository()
        ..onExportCsv = () async => left(failure);
      final bloc = BackupBloc(repo);
      bloc.add(ExportMomentsCsvToUserICloud());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<BackupState>(
            (s) => !s.isLoading && s.successMessage == null && s.failure == failure)),
      );
      await bloc.close();
    });
  });

  group('BackupBloc — ClearBackupMessage', () {
    test('failure 와 successMessage 를 모두 비워야 함', () async {
      final repo = _MockBackupRepository()
        ..onUpload = () async => left(const BackupFailure(message: 'x'));
      final bloc = BackupBloc(repo);

      bloc.add(UploadBackup());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(ClearBackupMessage());

      await expectLater(
        bloc.stream,
        emitsThrough(predicate<BackupState>(
            (s) => s.failure == null && s.successMessage == null)),
      );
      await bloc.close();
    });
  });

  group('BackupBloc — Hydration (toJson/fromJson)', () {
    test('lastBackupDate 가 ISO 문자열로 직렬화되고 복원되어야 함', () async {
      final date = DateTime(2026, 5, 1, 12, 30);
      final bloc = BackupBloc(_MockBackupRepository());
      final json = bloc.toJson(BackupState(lastBackupDate: date));
      expect(json, isNotNull);
      expect(json!['lastBackupDate'], equals(date.toIso8601String()));

      final restored = bloc.fromJson(json);
      expect(restored, isNotNull);
      expect(restored!.lastBackupDate, equals(date));
      await bloc.close();
    });

    test('lastBackupDate 가 null 인 상태도 복원 가능해야 함', () async {
      final bloc = BackupBloc(_MockBackupRepository());
      final json = bloc.toJson(const BackupState());
      final restored = bloc.fromJson(json!);
      expect(restored, isNotNull);
      expect(restored!.lastBackupDate, isNull);
      await bloc.close();
    });

    test('잘못된 형식의 lastBackupDate 는 기본 BackupState 로 복원돼야 함', () async {
      final bloc = BackupBloc(_MockBackupRepository());
      final restored = bloc.fromJson({'lastBackupDate': 12345});
      expect(restored, isNotNull);
      expect(restored!.lastBackupDate, isNull);
      await bloc.close();
    });
  });
}
