import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_satistics_event.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_satistics_state.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/application/emotional_statistics_bloc.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/diary_statistics.dart';
import 'package:diary_mobile_client/src/feature/emotion_statistics/domain/value_objects/emotion_stats.dart';
import 'package:diary_mobile_client/src/injection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 앱 전반에서 사용되는 디자인 토큰. moment_calendar / settings_view 와 동일한 값.
const _kInkPrimary = Color(0xFF53545B); // 본문/제목
const _kInkSecondary = Color(0xFF959490); // 보조 텍스트
const _kSurface = Color(0xFFF6F6F6); // 카드/연한 배경
const _kDivider = Color(0xFFD9D9D9);
const _kAccent = Color(0xFFEC7D61); // 캘린더 선택일과 동일한 웜 오렌지
const _kAccentSoft = Color(0xFFF3E9E5); // 액센트 배경
const _kNegative = Color(0xFF7E8B9F); // 차분한 슬레이트 블루
const _kFont = 'Pretendard';

class EmotionStatisticsPage extends StatelessWidget {
  static const routeName = '/emotion-statistics';
  const EmotionStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<EmotionalStatisticsBloc>()..add(const FetchDiaryStatistics()),
      child: Scaffold(
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
            '감정 통계',
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
          child: BlocBuilder<EmotionalStatisticsBloc, EmotionalStatisticsState>(
            builder: (context, state) {
              if (state.status == EmotionalStatisticsStatus.loading &&
                  state.diaryStatistics.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: _kAccent),
                );
              }
              if (state.status == EmotionalStatisticsStatus.error) {
                return _CenteredMessage(
                  text: '통계를 불러오지 못했습니다.\n${state.failure?.message ?? ''}',
                );
              }
              final stats = state.diaryStatistics;
              if (stats.isEmpty) {
                return const _CenteredMessage(
                  text: '아직 작성된 일기가 없어요.\n첫 일기를 써보세요.',
                );
              }
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryBlock(stats: stats),
                    const SizedBox(height: 32),
                    const _SectionTitle('감정 분포'),
                    const SizedBox(height: 16),
                    _ValencePieChart(stats: stats),
                    const SizedBox(height: 36),
                    const _SectionTitle('가장 많이 느낀 감정 Top 5'),
                    const SizedBox(height: 16),
                    _TopEmotionsList(stats: stats),
                    const SizedBox(height: 36),
                    const _SectionTitle('최근 30일 작성 빈도'),
                    const SizedBox(height: 16),
                    _DailyTrendChart(stats: stats),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String text;
  const _CenteredMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: _kFont,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: -0.4,
            color: _kInkSecondary,
          ),
        ),
      ),
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

class _SummaryBlock extends StatelessWidget {
  final DiaryStatistics stats;
  const _SummaryBlock({required this.stats});

  @override
  Widget build(BuildContext context) {
    final dominant = stats.dominantEmotion;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '지금까지 기록한',
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
                text: '${stats.totalMoments}',
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
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: '최근 30일 작성',
                value: '${stats.activeDaysInWindow}',
                suffix: '일',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                label: '평균 감정 수',
                value: stats.avgEmotionsPerMoment.toStringAsFixed(1),
                suffix: '개',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                label: '총 감정 기록',
                value: '${stats.totalEmotionEntries}',
                suffix: '건',
              ),
            ),
          ],
        ),
        if (dominant != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _kAccentSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dominant.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '가장 많이 느낀 감정 · ${dominant.localizedName(context)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: _kFont,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: -0.35,
                      color: _kInkPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  const _StatTile({
    required this.label,
    required this.value,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: _kFont,
              fontWeight: FontWeight.w400,
              height: 1.4,
              letterSpacing: -0.3,
              color: _kInkSecondary,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: _kFont,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.55,
                    color: _kInkPrimary,
                  ),
                ),
                TextSpan(
                  text: ' $suffix',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: _kFont,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    letterSpacing: -0.3,
                    color: _kInkSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValencePieChart extends StatelessWidget {
  final DiaryStatistics stats;
  const _ValencePieChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final positive = stats.positiveEmotionCount;
    final negative = stats.negativeEmotionCount;
    final neutral = stats.neutralEmotionCount;
    final total = positive + negative + neutral;
    if (total == 0) {
      return const _EmptyChart(message: '감정 데이터가 없습니다');
    }

    final sections = <PieChartSectionData>[
      if (positive > 0) _section(positive, total, _kAccent),
      if (neutral > 0) _section(neutral, total, _kDivider),
      if (negative > 0) _section(negative, total, _kNegative),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 36,
                sectionsSpace: 2,
                startDegreeOffset: -90,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendRow(
                  color: _kAccent,
                  label: '긍정',
                  count: positive,
                  total: total,
                ),
                const SizedBox(height: 10),
                _LegendRow(
                  color: _kDivider,
                  label: '중립',
                  count: neutral,
                  total: total,
                ),
                const SizedBox(height: 10),
                _LegendRow(
                  color: _kNegative,
                  label: '부정',
                  count: negative,
                  total: total,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section(int value, int total, Color color) {
    final pct = (value / total * 100).round();
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      title: pct >= 8 ? '$pct%' : '',
      titleStyle: const TextStyle(
        color: Colors.white,
        fontFamily: _kFont,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: -0.3,
      ),
      radius: 36,
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int total;
  const _LegendRow({
    required this.color,
    required this.label,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0 : (count / total * 100).round();
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: _kFont,
            fontWeight: FontWeight.w500,
            height: 1.4,
            letterSpacing: -0.35,
            color: _kInkPrimary,
          ),
        ),
        const Spacer(),
        Text(
          '$count건  $pct%',
          style: const TextStyle(
            fontSize: 13,
            fontFamily: _kFont,
            fontWeight: FontWeight.w400,
            height: 1.4,
            letterSpacing: -0.3,
            color: _kInkSecondary,
          ),
        ),
      ],
    );
  }
}

class _TopEmotionsList extends StatelessWidget {
  final DiaryStatistics stats;
  const _TopEmotionsList({required this.stats});

  @override
  Widget build(BuildContext context) {
    final top = stats.topEmotions;
    if (top.isEmpty) {
      return const _EmptyChart(message: '감정 데이터가 없습니다');
    }
    final maxCount = top.first.count.toDouble();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (var i = 0; i < top.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 4 : 14, bottom: 4),
              child: _EmotionBar(stat: top[i], max: maxCount),
            ),
        ],
      ),
    );
  }
}

class _EmotionBar extends StatelessWidget {
  final EmotionStats stat;
  final double max;
  const _EmotionBar({required this.stat, required this.max});

  @override
  Widget build(BuildContext context) {
    final ratio = max == 0 ? 0.0 : stat.count / max;
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            stat.emotion.localizedName(context),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: _kFont,
              fontWeight: FontWeight.w500,
              height: 1.4,
              letterSpacing: -0.35,
              color: _kInkPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 14,
                  color: const Color(0xFFEDEDED),
                ),
                FractionallySizedBox(
                  widthFactor: ratio.clamp(0.0, 1.0),
                  child: Container(
                    height: 14,
                    color: stat.emotion.color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            '${stat.count}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: _kFont,
              fontWeight: FontWeight.w500,
              height: 1.4,
              letterSpacing: -0.3,
              color: _kInkPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyTrendChart extends StatelessWidget {
  final DiaryStatistics stats;
  const _DailyTrendChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.dailyMomentCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    if (entries.isEmpty) {
      return const _EmptyChart(message: '데이터가 없습니다');
    }
    final spots = <FlSpot>[
      for (var i = 0; i < entries.length; i++)
        FlSpot(i.toDouble(), entries[i].value.toDouble()),
    ];
    final maxY =
        entries.map((e) => e.value).fold<int>(0, (a, b) => a > b ? a : b);
    final yMax = (maxY < 3 ? 3 : maxY + 1).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (entries.length - 1).toDouble(),
            minY: 0,
            maxY: yMax,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (_) => const FlLine(
                color: _kDivider,
                strokeWidth: 0.6,
                dashArray: [3, 4],
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget: (v, _) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      v.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: _kFont,
                        fontWeight: FontWeight.w400,
                        color: _kInkSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (entries.length / 5).ceilToDouble(),
                  reservedSize: 24,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    if (i < 0 || i >= entries.length) return const SizedBox();
                    final d = entries[i].key;
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '${d.month}/${d.day}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: _kFont,
                          fontWeight: FontWeight.w400,
                          color: _kInkSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.25,
                color: _kAccent,
                barWidth: 2.4,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: _kAccentSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final String message;
  const _EmptyChart({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: _kFont,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: -0.35,
            color: _kInkSecondary,
          ),
        ),
      ),
    );
  }
}
