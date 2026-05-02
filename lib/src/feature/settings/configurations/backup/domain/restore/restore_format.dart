/// 복원 대상 백업 파일의 형식.
///
/// 기존 백업 기능이 만들어내는 4가지 산출물 + 미식별(unknown) 케이스.
enum RestoreFormat {
  /// raw `.sqlite` (Drift DB 파일 그대로)
  sqlite,

  /// `.zip` 안에 `.sqlite` 1개
  sqliteZip,

  /// `moments.csv` 단일 파일
  csv,

  /// `.zip` 안에 `moments.csv` + `medias/<momentId>/<filename>`
  csvMediaZip,

  /// 헤더 검출에 실패한 알 수 없는 형식
  unknown,
}
