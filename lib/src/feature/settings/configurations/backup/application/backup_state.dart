import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:equatable/equatable.dart';

class BackupState extends Equatable {
  final DateTime? lastBackupDate;
  final BackupFailure? failure;
  final bool isLoading;
  final List<String>? files;
  const BackupState(
      {this.lastBackupDate, this.failure, this.isLoading = false, this.files});

  @override
  List<Object?> get props => [lastBackupDate, failure, isLoading];

  BackupState copyWith(
      {DateTime? lastBackupDate,
      BackupFailure? failure,
      bool? isLoading,
      List<String>? files}) {
    return BackupState(
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      files: files ?? this.files,
    );
  }
}
