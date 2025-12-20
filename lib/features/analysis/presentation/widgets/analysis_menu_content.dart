import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/analysis_notifier.dart';
import 'analysis_common_widgets.dart';

/// 분석 메뉴 화면 (Analyze-2)
/// 분석 가능 상태일 때 표시되는 메뉴 선택 화면
class AnalysisMenuContent extends ConsumerWidget {
  const AnalysisMenuContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 위험도 측정 카드
          _buildRiskAssessmentCard(context, ref),
          const SizedBox(height: 8),
          // What-if 시뮬레이션 카드
          _buildWhatIfSimulationCard(context, ref),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRiskAssessmentCard(BuildContext context, WidgetRef ref) {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 + 제목
          Row(
            children: [
              const Text('🩺', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              const Text(
                '위험도 측정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                  letterSpacing: -0.5,
                  color: AppColorScheme.black100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 설명
          const Text(
            '현재 건강 데이터를 기반으로 뇌졸중 위험도를 AI가 분석하여 제공합니다. 정확도 높은 예측을 위해 최근의 건강 정보를 입력해주세요',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 20 / 13,
              letterSpacing: -0.325,
              color: AppColorScheme.grey300,
            ),
          ),
          const SizedBox(height: 16),
          // 기능 목록
          _buildFeatureList(['실시간 위험도 점수 확인', '위험 요인 상세 분석', '맞춤형 건강 관리 조언']),
          const SizedBox(height: 12),
          // 버튼
          AppFlatButton(
            isExpanded: true,
            text: '위험도 측정 시작하기',
            onPressed: () async {
              // 위험도 측정 데이터 로드 후 화면 이동
              final notifier = ref.read(analysisProvider.notifier);
              final riskAssessment = await notifier.loadRiskAssessment();
              if (riskAssessment != null && context.mounted) {
                context.push(
                  '/analysis/risk-assessment',
                  extra: riskAssessment,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIfSimulationCard(BuildContext context, WidgetRef ref) {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 + 제목
          Row(
            children: [
              const Text('⚡', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              const Text(
                'What-if 시뮬레이션',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 28 / 20,
                  letterSpacing: -0.5,
                  color: AppColorScheme.black100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 설명
          const Text(
            '생활 습관을 변경했을 때 위험도가 어떻게 변할지 미리 확인해보세요. 다양한 시나리오를 예측할 수 있습니다.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 20 / 13,
              letterSpacing: -0.325,
              color: AppColorScheme.grey300,
            ),
          ),
          const SizedBox(height: 16),
          // 기능 목록
          _buildFeatureList([
            '생활 습관 변화 후 예측',
            '약물 복용 효과 예측',
            '각 추천 목표 달성 시 시나리오 비교',
          ]),
          const SizedBox(height: 12),
          // 버튼
          AppFlatButton(
            isExpanded: true,
            text: '시뮬레이션 시작하기',
            onPressed: () async {
              // What-if 시뮬레이션 데이터 로드 후 화면 이동
              final notifier = ref.read(analysisProvider.notifier);
              final simulation = await notifier.loadWhatIfSimulation();
              if (simulation != null && context.mounted) {
                context.push('/analysis/what-if', extra: simulation);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColorScheme.white200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '•  ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 18 / 13,
                    letterSpacing: -0.32,
                    color: AppColorScheme.grey300,
                  ),
                ),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 18 / 13,
                      letterSpacing: -0.32,
                      color: AppColorScheme.grey300,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
