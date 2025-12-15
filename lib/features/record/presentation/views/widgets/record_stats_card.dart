import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../../core/theme/color_scheme.dart';
import '../../../../health_record/domain/entities/health_record_entity.dart';
import '../../providers/record_state.dart';

/// 혈압/혈당 변화율 카드
///
/// Figma: Record - 2 (혈압/혈당 변화율 카드)
/// 7일/30일/전체 탭 + 통계 요약 + 그래프
class RecordStatsCard extends StatelessWidget {
  const RecordStatsCard({
    super.key,
    required this.recordState,
    required this.onPeriodChanged,
  });

  final RecordState recordState;
  final ValueChanged<RecordPeriodFilter> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final periodIndex = RecordPeriodFilter.values.indexOf(
      recordState.periodFilter,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Text(
            '혈압/혈당 변화율',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColorScheme.black100,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(height: 12),

          // 기간 탭
          AppSegmentedTabBar(
            items: RecordPeriodFilter.values
                .map((f) => SegmentedTabItem(label: f.label, value: f))
                .toList(),
            selectedIndex: periodIndex,
            onItemSelected: (index) {
              onPeriodChanged(RecordPeriodFilter.values[index]);
            },
          ),
          const SizedBox(height: 12),

          // 통계 요약
          _buildStatsSummary(context),
          const SizedBox(height: 16),

          // 혈압 그래프
          _buildBloodPressureChart(context),
          const SizedBox(height: 16),

          // 혈당 그래프
          _buildBloodSugarChart(context),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColorScheme.white300),
      ),
      child: Row(
        children: [
          // 총 기록
          Expanded(
            child: _buildStatItem(
              context,
              label: '총 기록',
              value: '${recordState.filteredRecordCount}회',
            ),
          ),
          // 평균 혈압
          Expanded(
            child: _buildStatItem(
              context,
              label: '평균 혈압',
              value: recordState.averageBPString ?? '-',
            ),
          ),
          // 평균 혈당
          Expanded(
            child: _buildStatItem(
              context,
              label: '평균 혈당',
              value: recordState.averageBloodSugar?.toString() ?? '-',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColorScheme.grey300,
            letterSpacing: -0.325,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColorScheme.black100,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.45,
          ),
        ),
      ],
    );
  }

  Widget _buildBloodPressureChart(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${recordState.periodFilter.label}간 혈압 변화',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorScheme.black100,
              letterSpacing: -0.4,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: _BloodPressureLineChart(records: recordState.filteredRecords),
        ),
      ],
    );
  }

  Widget _buildBloodSugarChart(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${recordState.periodFilter.label}간 혈당 변화',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorScheme.black100,
              letterSpacing: -0.4,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: _BloodSugarLineChart(records: recordState.filteredRecords),
        ),
      ],
    );
  }
}

/// 혈압 라인 차트
class _BloodPressureLineChart extends StatelessWidget {
  const _BloodPressureLineChart({required this.records});

  final List<HealthRecordEntity> records;

  @override
  Widget build(BuildContext context) {
    // 혈압 데이터가 있는 기록만 필터링
    final validRecords =
        records
            .where((r) => r.systolicBP != null && r.diastolicBP != null)
            .toList()
          ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    if (validRecords.isEmpty) {
      return Center(
        child: Text(
          '데이터가 없습니다',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColorScheme.grey400),
        ),
      );
    }

    // 수축기 혈압 스팟
    final systolicSpots = <FlSpot>[];
    // 이완기 혈압 스팟
    final diastolicSpots = <FlSpot>[];

    for (int i = 0; i < validRecords.length; i++) {
      final record = validRecords[i];
      systolicSpots.add(FlSpot(i.toDouble(), record.systolicBP!.toDouble()));
      diastolicSpots.add(FlSpot(i.toDouble(), record.diastolicBP!.toDouble()));
    }

    // Y축 범위 계산
    final allBP = validRecords
        .expand((r) => [r.systolicBP!, r.diastolicBP!])
        .toList();
    final minY = (allBP.reduce((a, b) => a < b ? a : b) - 10).toDouble();
    final maxY = (allBP.reduce((a, b) => a > b ? a : b) + 10).toDouble();

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppColorScheme.white300, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppColorScheme.grey400,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= validRecords.length) {
                  return const SizedBox.shrink();
                }
                final date = validRecords[index].recordedAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.month}/${date.day}',
                    style: const TextStyle(
                      color: AppColorScheme.grey400,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // 수축기 혈압 (빨간색)
          LineChartBarData(
            spots: systolicSpots,
            isCurved: true,
            color: const Color(0xFFFF6B6B),
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFFFF6B6B),
                  strokeWidth: 2,
                  strokeColor: AppColorScheme.white100,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
          // 이완기 혈압 (파란색)
          LineChartBarData(
            spots: diastolicSpots,
            isCurved: true,
            color: AppColorScheme.primaryColor,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColorScheme.primaryColor,
                  strokeWidth: 2,
                  strokeColor: AppColorScheme.white100,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColorScheme.black100,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final isSystolic = spot.barIndex == 0;
                return LineTooltipItem(
                  '${isSystolic ? '수축기' : '이완기'}: ${spot.y.toInt()}',
                  TextStyle(
                    color: spot.bar.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

/// 혈당 라인 차트
class _BloodSugarLineChart extends StatelessWidget {
  const _BloodSugarLineChart({required this.records});

  final List<HealthRecordEntity> records;

  @override
  Widget build(BuildContext context) {
    // 혈당 데이터가 있는 기록만 필터링
    final validRecords = records.where((r) => r.bloodSugar != null).toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    if (validRecords.isEmpty) {
      return Center(
        child: Text(
          '데이터가 없습니다',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColorScheme.grey400),
        ),
      );
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < validRecords.length; i++) {
      spots.add(FlSpot(i.toDouble(), validRecords[i].bloodSugar!.toDouble()));
    }

    // Y축 범위 계산
    final allBS = validRecords.map((r) => r.bloodSugar!).toList();
    final minY = (allBS.reduce((a, b) => a < b ? a : b) - 10).toDouble();
    final maxY = (allBS.reduce((a, b) => a > b ? a : b) + 10).toDouble();

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppColorScheme.white300, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppColorScheme.grey400,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= validRecords.length) {
                  return const SizedBox.shrink();
                }
                final date = validRecords[index].recordedAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.month}/${date.day}',
                    style: const TextStyle(
                      color: AppColorScheme.grey400,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFFFFB946),
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFFFFB946),
                  strokeWidth: 2,
                  strokeColor: AppColorScheme.white100,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFFFB946).withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColorScheme.black100,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '혈당: ${spot.y.toInt()}',
                  const TextStyle(
                    color: Color(0xFFFFB946),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
