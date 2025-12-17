import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../domain/entities/analysis_status_entity.dart';
import 'analysis_common_widgets.dart';

/// 분석 가능 전 화면 (건강 데이터 부족 상태)
class AnalysisNotReadyContent extends StatelessWidget {
  const AnalysisNotReadyContent({super.key, required this.analysisStatus});

  final AnalysisStatusEntity analysisStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 메인 카드
          Expanded(
            child: AnalysisCard(
              child: Column(
                children: [
                  // 진행 상태 헤더
                  _buildProgressHeader(),
                  const SizedBox(height: 16),
                  // 진행 바
                  AnalysisProgressBar(progress: analysisStatus.progress),
                  const SizedBox(height: 12),
                  // 빈 상태 카드
                  Expanded(child: _buildEmptyStateCard()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 기록 입력 버튼
          AnalysisPrimaryButton(
            text: '기록 입력하기',
            onPressed: () => context.push('/record/input'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '분석 가능 상태까지',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 18 / 13,
                letterSpacing: -0.32,
                color: AppColorScheme.grey200,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${analysisStatus.recordsNeeded}개의 건강 정보 필요',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 26 / 18,
                letterSpacing: -0.45,
                color: AppColorScheme.primaryColor,
              ),
            ),
          ],
        ),
        _buildInfoButton(),
      ],
    );
  }

  Widget _buildInfoButton() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColorScheme.white200,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const Text(
        '정보 입력',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 18 / 13,
          letterSpacing: -0.32,
          color: AppColorScheme.grey300,
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColorScheme.white500,
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            child: const Text('📊', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 0),
          const Text(
            '아직 데이터가 없네요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 20 / 16,
              letterSpacing: -0.32,
              color: AppColorScheme.grey300,
            ),
          ),
          const Text(
            '꾸준히 건강 데이터를 입력해주세요!',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 18 / 13,
              letterSpacing: -0.32,
              color: AppColorScheme.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
