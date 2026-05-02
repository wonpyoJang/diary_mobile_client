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
      emit(state.copyWith(
        isLoading: true,
        clearFailure: true,
        clearSuccess: true,
      ));
      final ok = await _backupRepository.uploadDatabase();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(state.copyWith(
          lastBackupDate: DateTime.now(),
          isLoading: false,
          successMessage: 'iCloud 백업이 완료되었습니다',
        )),
      );
    });
    on<FetchICloudFiles>((event, emit) async {
      emit(state.copyWith(isLoading: true, clearFailure: true));
      final files = await _backupRepository.listICloudFiles();
      emit(state.copyWith(
        files: files.fold((failure) => <String>[], (files) => files),
        isLoading: false,
      ));
    });
    on<ExportBackupToUserICloud>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        clearFailure: true,
        clearSuccess: true,
      ));
      final ok = await _backupRepository.exportDatabaseZipToUserICloud();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(state.copyWith(
          isLoading: false,
          successMessage: '데이터베이스를 ZIP으로 내보냈습니다',
        )),
      );
    });
    on<ExportMomentsCsvToUserICloud>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        clearFailure: true,
        clearSuccess: true,
      ));
      final ok = await _backupRepository.exportMomentsCsvToUserICloud();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(state.copyWith(
          isLoading: false,
          successMessage: 'CSV로 내보냈습니다',
        )),
      );
    });
    on<ExportMomentsCsvWithMediaZipToUserICloud>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        clearFailure: true,
        clearSuccess: true,
      ));
      final ok =
          await _backupRepository.exportMomentsCsvWithMediaZipToUserICloud();
      ok.fold(
        (failure) => emit(state.copyWith(failure: failure, isLoading: false)),
        (_) => emit(state.copyWith(
          isLoading: false,
          successMessage: 'CSV와 사진을 ZIP으로 내보냈습니다',
        )),
      );
    });
    on<ClearBackupMessage>((event, emit) {
      emit(state.copyWith(clearFailure: true, clearSuccess: true));
    });
  }

  @override
  BackupState? fromJson(Map<String, dynamic> json) {
    final dateRaw = json['lastBackupDate'];
    if (dateRaw is String) {
      return BackupState(lastBackupDate: DateTime.tryParse(dateRaw));
    }
    return const BackupState();
  }

  @override
  Map<String, dynamic>? toJson(BackupState state) {
    return {
      'lastBackupDate': state.lastBackupDate?.toIso8601String(),
    };
  }
}
