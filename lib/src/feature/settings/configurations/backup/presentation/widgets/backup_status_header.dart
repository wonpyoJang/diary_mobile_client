import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 백업 페이지 상단의 큰 카드.
///
/// - 마지막 백업 시각 또는 "백업한 적이 없어요"
/// - 큰 "지금 백업하기" 버튼 (default destination에 위임)
/// - 첫 백업 안내 (lastBackupDate가 null일 때)
class BackupStatusHeader extends StatelessWidget {
  final DateTime? lastBackupDate;
  final bool isLoading;
  final VoidCallback onQuickBackup;

  const BackupStatusHeader({
    super.key,
    required this.lastBackupDate,
    required this.isLoading,
    required this.onQuickBackup,
  });

  @override
  Widget build(BuildContext context) {
    final hasBackup = lastBackupDate != null;
    final formatted = hasBackup
        ? DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(lastBackupDate!.toLocal())
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEC7C61),
              Color(0xFFBEBADC),
              Color(0xFF93B1F3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '백업 상태',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasBackup ? '마지막 백업 $formatted' : '백업한 적이 없어요',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.4,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasBackup ? '주기적으로 백업해서 안전하게 보관하세요.' : '첫 백업으로 추억을 안전하게 보관하세요.',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: -0.4,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onQuickBackup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF53545B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.backup_outlined, size: 20),
                label: Text(
                  isLoading ? '백업 중...' : '지금 백업하기',
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
