import 'dart:io';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/repositories/interfaces/i_backup_repository.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_local_provider.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_remote_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IBackupRepository)
class BackupRepository implements IBackupRepository {
  final IBackupRemoteProvider remoteProvider;
  final IBackupLocalProvider localProvider;

  BackupRepository({required this.remoteProvider, required this.localProvider});

  @override
  Future<Either<BackupFailure, Unit>> uploadDatabase() async {
    final exportTask = TaskEither<BackupFailure, File>(() async {
      final localExportResult = await localProvider.exportDriftDatabase();
      return localExportResult
          .mapLeft((failure) => BackupFailure(message: failure.message));
    });

    final uploadTask = exportTask.flatMap((exportedFile) {
      return TaskEither<BackupFailure, Unit>(() async {
        final uploadResult = await remoteProvider.saveToICloud(
          exportedFile.path,
        );
        return uploadResult
            .mapLeft((failure) => BackupFailure(message: failure.message));
      });
    });

    return uploadTask.run();
  }

  @override
  Future<Either<BackupFailure, Unit>> downloadFromICloud(
      String fileName) async {
    return await remoteProvider.downloadFromICloud(fileName).then(
          (result) => result.fold(
            (failure) => left(BackupFailure(message: failure.message)),
            (_) => right(unit),
          ),
        );
  }

  @override
  Future<Either<BackupFailure, List<String>>> listICloudFiles() async {
    return await remoteProvider.listICloudFiles().then(
          (result) => result.fold(
            (failure) => left(BackupFailure(message: failure.message)),
            (files) => right(files),
          ),
        );
  }

  @override
  Future<Either<BackupFailure, Unit>> exportDatabaseZipToUserICloud() async {
    final exportTask = TaskEither<BackupFailure, File>(() async {
      final localExportResult = await localProvider.exportDriftDatabase();
      return localExportResult
          .mapLeft((failure) => BackupFailure(message: failure.message));
    });

    final zipAndExportTask = exportTask.flatMap((exportedFile) {
      return TaskEither<BackupFailure, Unit>(() async {
        try {
          final zipPath = await _zipSingleFile(exportedFile);
          final exportResult = await remoteProvider.exportToUserICloud(zipPath);
          return exportResult
              .mapLeft((failure) => BackupFailure(message: failure.message));
        } catch (e) {
          return left(BackupFailure(message: e.toString()));
        }
      });
    });

    return zipAndExportTask.run();
  }

  @override
  Future<Either<BackupFailure, Unit>> exportMomentsCsvToUserICloud() async {
    final exportTask = TaskEither<BackupFailure, File>(() async {
      final localExportResult = await localProvider.exportMomentsCsv();
      return localExportResult
          .mapLeft((failure) => BackupFailure(message: failure.message));
    });

    final exportToFilesTask = exportTask.flatMap((exportedFile) {
      return TaskEither<BackupFailure, Unit>(() async {
        final exportResult = await remoteProvider.exportToUserICloud(
          exportedFile.path,
        );
        return exportResult
            .mapLeft((failure) => BackupFailure(message: failure.message));
      });
    });

    return exportToFilesTask.run();
  }

  @override
  Future<Either<BackupFailure, Unit>>
      exportMomentsCsvWithMediaZipToUserICloud() async {
    final exportTask = TaskEither<BackupFailure, File>(() async {
      final localExportResult =
          await localProvider.exportMomentsCsvWithMediaZip();
      return localExportResult
          .mapLeft((failure) => BackupFailure(message: failure.message));
    });

    final exportToFilesTask = exportTask.flatMap((exportedFile) {
      return TaskEither<BackupFailure, Unit>(() async {
        final exportResult = await remoteProvider.exportToUserICloud(
          exportedFile.path,
        );
        return exportResult
            .mapLeft((failure) => BackupFailure(message: failure.message));
      });
    });

    return exportToFilesTask.run();
  }

  Future<String> _zipSingleFile(File file) async {
    final bytes = await file.readAsBytes();
    final archive = Archive()
      ..addFile(ArchiveFile(p.basename(file.path), bytes.length, bytes));
    final encoded = ZipEncoder().encode(archive);
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd_HHmmss').format(now);
    final zipPath =
        p.join(file.parent.path, 'crepas_backup_$formattedDate.zip');
    final outFile = File(zipPath);
    await outFile.writeAsBytes(encoded, flush: true);
    return zipPath;
  }
}
