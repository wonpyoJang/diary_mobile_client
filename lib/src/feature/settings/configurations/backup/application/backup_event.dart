import 'package:equatable/equatable.dart';

abstract class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => [];
}

class UploadBackup extends BackupEvent {}

class FetchICloudFiles extends BackupEvent {}

class ExportBackupToUserICloud extends BackupEvent {}

class ExportMomentsCsvToUserICloud extends BackupEvent {}

class ExportMomentsCsvWithMediaZipToUserICloud extends BackupEvent {}
