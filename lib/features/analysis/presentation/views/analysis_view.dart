import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/analysis_notifier.dart';
import '../providers/analysis_state.dart';
import '../widgets/analysis_empty_card.dart';
import '../widgets/analysis_menu_content.dart';

/// 분석 화면
///
/// Figma: Analyze - 1, Analyze - 2
/// 건강 정보 수집 상태에 따라 다른 화면을 표시합니다.
/// - 데이터 부족: 빈 상태 카드 (Analyze-1)
/// - 데이터 충분: 분석 메뉴 화면 (Analyze-2)
class AnalysisView extends ConsumerWidget {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: const CustomAppBar(mode: AppBarMode.navigation, title: '분석'),
      body: analysisState.when(
        data: (state) => _buildContent(context, ref, state),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '데이터를 불러오는 중 오류가 발생했습니다.\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColorScheme.grey400),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AnalysisState state,
  ) {
    if (!state.canAnalyze) {
      return _buildEmptyContent(context, state);
    }
    return _buildDataContent(context, ref, state);
  }

  /// 데이터 없음 상태
  Widget _buildEmptyContent(BuildContext context, AnalysisState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 빈 상태 카드 (Expanded로 남은 공간 채우기)
          Expanded(
            child: AnalysisEmptyCard(analysisStatus: state.analysisStatus),
          ),
          const SizedBox(height: 8),
          // 기록 입력하기 버튼
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.push('/record/input'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorScheme.primaryColor,
                foregroundColor: AppColorScheme.white100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                '기록 입력하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// 데이터 있음 상태
  Widget _buildDataContent(
    BuildContext context,
    WidgetRef ref,
    AnalysisState state,
  ) {
    return const AnalysisMenuContent();
  }
}
