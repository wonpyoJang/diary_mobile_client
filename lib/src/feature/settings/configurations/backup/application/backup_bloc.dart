import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_event.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/application/backup_state.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/repositories/interfaces/i_backup_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BackupBloc extends HydratedBloc<BackupEvent, BackupState> {
  final IBackupRepository _backupRepository;
  BackupBloc(this._backupRepository) : super(const BackupState()) {
    on<UploadBackup>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final ok = await _backupRepository.uploadDatabase();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(
            state.copyWith(lastBackupDate: DateTime.now(), isLoading: false)),
      );
    });
    on<FetchICloudFiles>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final files = await _backupRepository.listICloudFiles();
      emit(state.copyWith(
          files: files.fold((failure) => [], (files) => files),
          isLoading: false));
    });
    on<ExportBackupToUserICloud>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final ok = await _backupRepository.exportDatabaseZipToUserICloud();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(state.copyWith(isLoading: false)),
      );
    });
    on<ExportMomentsCsvToUserICloud>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final ok = await _backupRepository.exportMomentsCsvToUserICloud();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(state.copyWith(isLoading: false)),
      );
    });
    on<ExportMomentsCsvWithMediaZipToUserICloud>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final ok =
          await _backupRepository.exportMomentsCsvWithMediaZipToUserICloud();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(state.copyWith(isLoading: false)),
      );
    });
  }

  @override
  BackupState? fromJson(Map<String, dynamic> json) {
    return BackupState(
      lastBackupDate: json['lastBackupDate'] as DateTime?,
    );
  }

  @override
  Map<String, dynamic>? toJson(BackupState state) {
    return {
      'lastBackupDate': state.lastBackupDate?.toIso8601String(),
    };
  }
}
