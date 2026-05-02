import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 단일 [BackupDestinationKind]를 표현하는 카드 위젯.
///
/// 아이콘 + 제목 + 설명 + (선택) 마지막 백업 시각 + 우측 화살표.
class BackupDestinationCard extends StatelessWidget {
  final BackupDestinationKind kind;
  final DateTime? lastBackupAt;
  final VoidCallback onTap;
  final bool isLoading;

  const BackupDestinationCard({
    super.key,
    required this.kind,
    required this.onTap,
    this.lastBackupAt,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final lastFormatted = lastBackupAt != null
        ? DateFormat('yyyy.MM.dd HH:mm').format(lastBackupAt!.toLocal())
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    kind.iconData,
                    color: const Color(0xFF53545B),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kind.displayKorean,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1B1F),
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        kind.description,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7C7E84),
                          letterSpacing: -0.4,
                        ),
                      ),
                      if (lastFormatted != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '마지막 백업 $lastFormatted',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF93B1F3),
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF93B1F3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
