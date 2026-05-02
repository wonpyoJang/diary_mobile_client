import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 백업 파일 이름 목록을 보여주는 위젯.
///
/// 현재는 [BackupBloc.state.files] (iCloud 파일 목록)를 입력으로 받는다.
/// 빈 상태에서는 "백업 파일이 없어요" 플레이스홀더를 보여준다.
class BackupFilesList extends StatelessWidget {
  final List<String>? files;

  const BackupFilesList({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    if (files == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          '백업 파일을 불러오는 중...',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 13,
            color: Color(0xFF7C7E84),
          ),
        ),
      );
    }
    if (files!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.folder_off_outlined,
                  size: 20, color: Color(0xFF7C7E84)),
              SizedBox(width: 10),
              Text(
                '백업 파일이 없어요',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  color: Color(0xFF53545B),
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: files!
          .map(
            (name) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                leading: const Icon(
                  Icons.insert_drive_file_outlined,
                  color: Color(0xFF93B1F3),
                ),
                title: Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF53545B),
                    letterSpacing: -0.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: _parseDateFromName(name) != null
                    ? Text(
                        DateFormat('yyyy.MM.dd HH:mm')
                            .format(_parseDateFromName(name)!),
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          color: Color(0xFF7C7E84),
                          letterSpacing: -0.4,
                        ),
                      )
                    : null,
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  /// `crepas_backup_2025-04-01_120000.sqlite` 같은 파일명에서 날짜 부분을
  /// 추출해 [DateTime]으로 파싱한다. 실패 시 null.
  static DateTime? _parseDateFromName(String name) {
    // yyyy-MM-dd_HHmmss 패턴
    final match =
        RegExp(r'(\d{4}-\d{2}-\d{2})_(\d{2})(\d{2})(\d{2})').firstMatch(name);
    if (match == null) return null;
    try {
      final datePart = match.group(1)!;
      final hh = match.group(2)!;
      final mm = match.group(3)!;
      final ss = match.group(4)!;
      return DateTime.parse('${datePart}T$hh:$mm:$ss');
    } catch (_) {
      return null;
    }
  }
}
