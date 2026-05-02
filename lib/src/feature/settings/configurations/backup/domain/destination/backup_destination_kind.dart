import 'package:flutter/material.dart';

/// 백업 파일을 보낼 수 있는 destination 종류
enum BackupDestinationKind {
  /// iCloud 컨테이너 (iOS 전용)
  icloud,

  /// 이 기기 안의 앱 전용 백업 폴더
  localFolder,

  /// 시스템 공유 시트 (Google Drive, Dropbox 등 사용자가 선택)
  shareSheet,
}

/// 각 destination에 대한 메타데이터(표시명, 아이콘, 설명) 매핑
extension BackupDestinationKindX on BackupDestinationKind {
  String get displayKorean {
    switch (this) {
      case BackupDestinationKind.icloud:
        return 'iCloud';
      case BackupDestinationKind.localFolder:
        return '로컬 폴더';
      case BackupDestinationKind.shareSheet:
        return '공유 시트';
    }
  }

  IconData get iconData {
    switch (this) {
      case BackupDestinationKind.icloud:
        return Icons.cloud_outlined;
      case BackupDestinationKind.localFolder:
        return Icons.folder_outlined;
      case BackupDestinationKind.shareSheet:
        return Icons.ios_share_outlined;
    }
  }

  String get description {
    switch (this) {
      case BackupDestinationKind.icloud:
        return 'iCloud 컨테이너에 자동 저장 (iOS)';
      case BackupDestinationKind.localFolder:
        return '이 기기 안 백업 폴더에 저장 (목록/삭제 가능)';
      case BackupDestinationKind.shareSheet:
        return 'Google Drive, Dropbox 등으로 직접 보내기';
    }
  }
}
