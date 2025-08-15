import 'package:uuid/uuid.dart';

class IdGenerator {
  static final _uuid = Uuid();
  static const _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

  /// 유니크한 ID를 생성합니다.
  ///
  /// [prefix]를 지정하면 'prefix_uuid' 형태로 생성됩니다.
  /// [prefix]를 지정하지 않으면 uuid만 반환됩니다.
  static String generate({String? prefix}) {
    final uuid = _uuid.v4();
    return prefix != null ? '${prefix}_$uuid' : uuid;
  }

  /// 타임스탬프 기반의 ID를 생성합니다.
  ///
  /// [prefix]를 지정하면 'prefix_timestamp' 형태로 생성됩니다.
  /// [prefix]를 지정하지 않으면 timestamp만 반환됩니다.
  static String generateWithTimestamp({String? prefix}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return prefix != null ? '${prefix}_$timestamp' : timestamp;
  }
}
