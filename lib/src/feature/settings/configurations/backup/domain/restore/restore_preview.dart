import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_format.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/restore/restore_mode.dart';
import 'package:equatable/equatable.dart';

/// 백업 파일 분석 결과.
///
/// 사용자가 모드를 고르기 전에 보여줄 정보와, 병합 시뮬레이션으로 미리 계산해 둔
/// 충돌/신규 카운트를 함께 들고 다닌다. 이 객체는 `applyRestore` 시점에 다시
/// 사용되므로 [sourcePath]가 필수.
class RestorePreview extends Equatable {
  final RestoreFormat format;
  final String sourcePath;

  /// 백업 안의 모먼트 개수
  final int momentCount;

  /// 백업 안의 미디어 파일 개수 (csvMediaZip만 의미 있음, 나머지는 0)
  final int mediaCount;

  /// 백업 파일 자체의 생성 시각(있으면). SQLite 같은 경우 알기 어려워 null 가능
  final DateTime? backupCreatedAt;

  /// 병합 시뮬레이션 결과 — 현재 DB와 충돌하는 모먼트 수.
  /// SQLite 형식은 병합을 지원하지 않으므로 0.
  final int conflictCount;

  /// 병합 시뮬레이션 결과 — 새로 추가될 모먼트 수.
  final int newCount;

  /// 이 백업에서 사용 가능한 모드 목록. UI 라디오 활성/비활성에 사용.
  final List<RestoreMode> supportedModes;

  /// 파일 크기(bytes). UI에서 표시.
  final int fileSizeBytes;

  /// 화면에 보여줄 파일명(경로 분리해 미리 계산해 둠)
  final String fileName;

  const RestorePreview({
    required this.format,
    required this.sourcePath,
    required this.momentCount,
    required this.mediaCount,
    required this.backupCreatedAt,
    required this.conflictCount,
    required this.newCount,
    required this.supportedModes,
    required this.fileSizeBytes,
    required this.fileName,
  });

  @override
  List<Object?> get props => [
        format,
        sourcePath,
        momentCount,
        mediaCount,
        backupCreatedAt,
        conflictCount,
        newCount,
        supportedModes,
        fileSizeBytes,
        fileName,
      ];
}
