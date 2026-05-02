/// 백업 복원 시 적용할 모드.
///
/// - [overwrite]: 현재 데이터를 모두 삭제하고 백업으로 교체
/// - [merge]: 기존 데이터에 합치되, 동일 ID는 modifiedAt이 최신인 쪽을 유지
enum RestoreMode {
  overwrite,
  merge,
}
