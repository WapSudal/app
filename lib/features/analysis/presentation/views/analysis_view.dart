import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/color_scheme.dart';
import '../providers/analysis_state.dart';
import '../providers/analysis_notifier.dart';
import '../widgets/analysis_menu_content.dart';
import '../widgets/analysis_not_ready_content.dart';

/// 분석 화면
///
/// 건강 정보 수집 상태에 따라 다른 화면을 표시합니다.
/// - 데이터 부족: 데이터 수집 안내 화면 (Analyze-1)
/// - 데이터 충분: 분석 메뉴 화면 (Analyze-2)
class AnalysisView extends ConsumerWidget {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F6FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          '분석',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColorScheme.black100,
          ),
        ),
      ),
      body: analysisState.when(
        data: (state) => _buildContent(context, state, ref),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColorScheme.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '데이터를 불러오는 데 실패했습니다.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColorScheme.grey300,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(analysisProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorScheme.primaryColor,
                  foregroundColor: AppColorScheme.white100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AnalysisState state,
    WidgetRef ref,
  ) {
    if (state.canAnalyze) {
      return const AnalysisMenuContent();
    } else {
      return AnalysisNotReadyContent(analysisStatus: state.analysisStatus);
    }
  }
}
