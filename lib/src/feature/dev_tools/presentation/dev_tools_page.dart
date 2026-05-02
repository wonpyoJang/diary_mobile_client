import 'package:diary_mobile_client/src/core/dev/moment_seeder.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kInkPrimary = Color(0xFF53545B);
const _kInkSecondary = Color(0xFF959490);
const _kSurface = Color(0xFFF6F6F6);
const _kAccent = Color(0xFFEC7D61);
const _kAccentSoft = Color(0xFFF3E9E5);
const _kDanger = Color(0xFFC54A3F);
const _kFont = 'Pretendard';

/// 디버그 빌드에서만 진입 가능한 개발자 도구 페이지.
/// 더미 데이터 시드 / 데이터 초기화 등 검증용 액션을 모은다.
class DevToolsPage extends StatefulWidget {
  static const routeName = '/dev-tools';
  const DevToolsPage({super.key});

  @override
  State<DevToolsPage> createState() => _DevToolsPageState();
}

class _DevToolsPageState extends State<DevToolsPage> {
  late final MomentSeeder _seeder = getIt<MomentSeeder>();
  int? _currentCount;
  bool _busy = false;
  String? _statusMessage;
  bool _statusIsError = false;

  @override
  void initState() {
    super.initState();
    _refreshCount();
  }

  Future<void> _refreshCount() async {
    final result = await _seeder.getCurrentMomentCount();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _currentCount = null;
        _statusMessage = '개수 조회 실패: ${failure.message}';
        _statusIsError = true;
      }),
      (count) => setState(() => _currentCount = count),
    );
  }

  Future<void> _seed() async {
    setState(() {
      _busy = true;
      _statusMessage = null;
    });
    final result = await _seeder.seedNow();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _statusMessage = '시드 실패: ${failure.message}';
        _statusIsError = true;
      }),
      (n) => setState(() {
        _statusMessage = '$n편의 더미 일기를 추가했습니다.';
        _statusIsError = false;
      }),
    );
    setState(() => _busy = false);
    await _refreshCount();
  }

  Future<void> _confirmAndClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          '전체 데이터 삭제',
          style: TextStyle(
            fontSize: 18,
            fontFamily: _kFont,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.45,
            color: _kInkPrimary,
          ),
        ),
        content: const Text(
          '모든 일기, 감정, 미디어 레코드가 삭제됩니다.\n정말 진행하시겠습니까?',
          style: TextStyle(
            fontSize: 14,
            fontFamily: _kFont,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: -0.35,
            color: _kInkPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 14,
                fontFamily: _kFont,
                fontWeight: FontWeight.w500,
                color: _kInkSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              '삭제',
              style: TextStyle(
                fontSize: 14,
                fontFamily: _kFont,
                fontWeight: FontWeight.w700,
                color: _kDanger,
              ),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() {
      _busy = true;
      _statusMessage = null;
    });
    final result = await _seeder.clearAll();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _statusMessage = '삭제 실패: ${failure.message}';
        _statusIsError = true;
      }),
      (_) => setState(() {
        _statusMessage = '모든 데이터를 삭제했습니다.';
        _statusIsError = false;
      }),
    );
    setState(() => _busy = false);
    await _refreshCount();
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(
          child: Text(
            '개발자 도구는 디버그 빌드에서만 사용할 수 있습니다.',
            style: TextStyle(
              fontFamily: _kFont,
              fontSize: 14,
              color: _kInkSecondary,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: _kInkPrimary,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          '개발자 도구',
          style: TextStyle(
            fontSize: 20,
            fontFamily: _kFont,
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.8,
            color: _kInkPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CurrentCountBlock(count: _currentCount),
              const SizedBox(height: 28),
              const _SectionTitle('더미 데이터'),
              const SizedBox(height: 12),
              _ActionTile(
                title: '더미 일기 100편 추가',
                description: '랜덤한 날짜/감정/강도로 100편을 즉시 생성합니다.',
                actionLabel: '추가',
                onPressed: _busy ? null : _seed,
                primary: true,
              ),
              const SizedBox(height: 12),
              _ActionTile(
                title: '전체 데이터 삭제',
                description: '모든 일기·감정·미디어 레코드를 삭제합니다.',
                actionLabel: '삭제',
                onPressed: _busy ? null : _confirmAndClear,
                destructive: true,
              ),
              if (_statusMessage != null) ...[
                const SizedBox(height: 20),
                _StatusBanner(
                  message: _statusMessage!,
                  isError: _statusIsError,
                ),
              ],
              if (_busy) ...[
                const SizedBox(height: 20),
                const Center(
                  child: CircularProgressIndicator(color: _kAccent),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentCountBlock extends StatelessWidget {
  final int? count;
  const _CurrentCountBlock({required this.count});

  @override
  Widget build(BuildContext context) {
    final display = count == null ? '—' : '$count';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '현재 저장된',
          style: TextStyle(
            fontSize: 14,
            fontFamily: _kFont,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: -0.35,
            color: _kInkSecondary,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: display,
                style: const TextStyle(
                  fontSize: 36,
                  fontFamily: _kFont,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: -0.9,
                  color: _kInkPrimary,
                ),
              ),
              const TextSpan(
                text: '  편의 일기',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: _kFont,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: -0.45,
                  color: _kInkPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: _kFont,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: -0.45,
        color: _kInkPrimary,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback? onPressed;
  final bool primary;
  final bool destructive;

  const _ActionTile({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
    this.primary = false,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = destructive
        ? _kDanger
        : primary
            ? _kAccent
            : _kInkPrimary;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: _kFont,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    letterSpacing: -0.4,
                    color: _kInkPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: _kFont,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: -0.3,
                    color: _kInkSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: buttonColor,
              disabledBackgroundColor: _kInkSecondary.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(64, 36),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: _kFont,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;
  const _StatusBanner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final bg = isError ? const Color(0xFFFCEAE8) : _kAccentSoft;
    final fg = isError ? _kDanger : _kInkPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            size: 18,
            color: fg,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontFamily: _kFont,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.3,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
