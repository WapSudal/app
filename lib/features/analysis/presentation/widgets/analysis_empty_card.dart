import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/no_data_paint.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../domain/entities/analysis_status_entity.dart';
import 'analysis_common_widgets.dart';

/// 분석 빈 상태 카드 (데이터 부족)
///
/// Figma: Analyze - 1 (Card/None)
/// 분석에 필요한 건강 데이터가 부족할 때 표시되는 카드입니다.
/// 진행 상태 헤더, 프로그레스 바, 빈 상태 메시지를 포함합니다.
class AnalysisEmptyCard extends StatelessWidget {
  const AnalysisEmptyCard({super.key, required this.analysisStatus});

  final AnalysisStatusEntity analysisStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 진행 상태 헤더
          _buildProgressHeader(context),
          const SizedBox(height: 16),
          // 진행 바
          AnalysisProgressBar(progress: analysisStatus.progress),
          const SizedBox(height: 12),
          // 빈 상태 카드
          Expanded(
            child: const NoDataPaint(
              title: '아직 데이터가 없네요',
              subtitle: '꾸준히 건강 데이터를 입력해주세요!',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '분석 가능 상태까지',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey200),
            ),
            const SizedBox(height: 4),
            Text(
              '${analysisStatus.recordsNeeded}개의 건강 정보 필요',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColorScheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        _buildInfoButton(context),
      ],
    );
  }

  Widget _buildInfoButton(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColorScheme.white200,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '정보 입력',
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey300),
      ),
    );
  }
}
