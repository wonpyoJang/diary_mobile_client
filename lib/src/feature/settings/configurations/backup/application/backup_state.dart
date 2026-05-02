import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:equatable/equatable.dart';

class BackupState extends Equatable {
  final DateTime? lastBackupDate;
  final BackupFailure? failure;
  final String? successMessage;
  final bool isLoading;
  final List<String>? files;

  const BackupState({
    this.lastBackupDate,
    this.failure,
    this.successMessage,
    this.isLoading = false,
    this.files,
  });

  @override
  List<Object?> get props =>
      [lastBackupDate, failure, successMessage, isLoading, files];

  BackupState copyWith({
    DateTime? lastBackupDate,
    BackupFailure? failure,
    bool clearFailure = false,
    String? successMessage,
    bool clearSuccess = false,
    bool? isLoading,
    List<String>? files,
  }) {
    return BackupState(
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      failure: clearFailure ? null : (failure ?? this.failure),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      isLoading: isLoading ?? this.isLoading,
      files: files ?? this.files,
    );
  }
}
