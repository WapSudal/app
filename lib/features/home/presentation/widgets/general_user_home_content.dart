import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/no_data_card.dart';
import '../providers/home_notifier.dart';
import '../providers/home_state.dart';
import 'general_fast_menu_card.dart';
import 'home_progress_card.dart';
import 'general_home_risk_analysis_card.dart';
import 'home_splash_card.dart';
import 'general_home_weekly_stats_card.dart';
import 'home_welcome_card.dart';

/// 일반 사용자 홈 컨텐츠
///
/// Figma 디자인에 맞춘 홈 화면 레이아웃
/// - 스플래시 카드 (첫 방문 시)
/// - 환영 카드 (시간대별 인사)
/// - 기록 개수에 따라:
///   - 0개: 데이터 없음 카드
///   - 1~2개: 진행 상태 카드 (프로그레스바 + 데이터 없음)
///   - 3개 이상: 위험도 분석 카드
/// - 이번 주 기록 통계 카드
/// - 빠른 메뉴 카드
class GeneralUserHomeContent extends ConsumerWidget {
  const GeneralUserHomeContent({
    super.key,
    this.displayName,
    required this.canManageOwnHealth,
  });

  final String? displayName;
  final bool canManageOwnHealth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider).requireValue;

    return Container(
      color: const Color(0xFFF7F6FB), // dashboard/bg
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (homeState.recordCount == 0 && canManageOwnHealth)
            // 첫 방문 스플래시 카드
            ...[
              HomeSplashCard(
                title: '만나서 반가워요!',
                description: '첫번째 건강 데이터를 입력하여 시작해볼까요?',
                emoji: '✍️',
                buttonText: '기록 입력하기',
                onButtonPressed: () => context.push('/record/input'),
              ),
              const SizedBox(height: 8),
            ],
            // 환영 카드
            HomeWelcomeCard(displayName: displayName),
            const SizedBox(height: 8),
            // 기록 개수에 따른 조건부 렌더링
            _buildRecordBasedCard(context, homeState),
            const SizedBox(height: 8),
            // 이번 주 기록 통계 카드
            GeneralHomeWeeklyStatsCard(
              weeklyRecordCount: homeState.thisWeekRecordCount,
              unreadNotificationCount: 0, // 목업 데이터
            ),
            const SizedBox(height: 8),
            // 빠른 메뉴 카드
            GeneralFastMenuCard(
              onNewDataInput: () => context.push('/record/input'),
              onRiskPrediction: () {
                // TODO: 위험도 예측 페이지로 이동
              },
              onFutureSimulation: () {
                // TODO: 미래 예측 시뮬레이션 페이지로 이동
              },
              onContentExplore: () {
                // TODO: 추천 콘텐츠 탐색 페이지로 이동
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 기록 개수에 따른 카드 렌더링
  Widget _buildRecordBasedCard(BuildContext context, HomeState homeState) {
    final analysisAvailability = homeState.analysisAvailability;

    // 0개: 데이터 없음 카드
    if (homeState.recordCount == 0) {
      return const NoDataCard(
        title: '아직 데이터가 없네요',
        subtitle: '꾸준히 건강 데이터를 입력해주세요!',
      );
    }

    // 1~2개: 진행 상태 카드
    if (homeState.analysisAvailability.canAnalyze) {
      return HomeProgressCard(
        recordCount: homeState.recordCount,
        recordsNeeded:
            analysisAvailability.requiredRecordCount -
            analysisAvailability.currentRecordCount,
        onInputPressed: () => context.push('/record/input'),
      );
    }

    // 3개 이상: 위험도 분석 카드
    if (homeState.riskAssessment != null) {
      return GeneralHomeRiskAnalysisCard(
        riskAssessment: homeState.riskAssessment!,
        onTap: () {
          // TODO: 위험도 상세 페이지로 이동
        },
      );
    }

    // Fallback: 데이터 없음 카드
    return const NoDataCard(
      title: '아직 데이터가 없네요',
      subtitle: '꾸준히 건강 데이터를 입력해주세요!',
    );
  }
}
