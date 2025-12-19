import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/analysis_entity.dart';
import '../../data/providers/analysis_data_providers.dart';
import 'analysis_state.dart';

part 'analysis_notifier.g.dart';

/// 분석 화면 상태 관리 Provider
@riverpod
class AnalysisNotifier extends _$AnalysisNotifier {
  @override
  Future<AnalysisState> build() async {
    // Repository 가져오기
    final repository = ref.read(analysisRepositoryProvider);

    final availability = await repository.getAnalysisAvailability();

    // 분석 가능 여부에 따라 위험도 및 시뮬레이션 결과 조회
    if (availability.canAnalyze) {
      final riskAssessment = await repository.getRiskAssessmentReport();
      final whatIfSimulation = await repository.getWhatIfSimulationReport();

      return AnalysisState(
        analysisAvailability: availability,
        riskAssessment: riskAssessment,
        whatIfSimulation: whatIfSimulation,
      );
    }

    return AnalysisState(analysisAvailability: availability);
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// 위험도 측정 결과 로드 (상세 화면 이동용)
  Future<RiskAssessmentReportEntity?> loadRiskAssessment() async {
    final currentState = state.value;
    if (currentState?.riskAssessment != null) {
      return currentState!.riskAssessment;
    }

    // 캐시된 데이터가 없으면 API 호출
    final repository = ref.read(analysisRepositoryProvider);

    return await repository.getRiskAssessmentReport();
  }

  /// What-if 시뮬레이션 결과 로드 (상세 화면 이동용)
  Future<WhatIfSimulationReportEntity?> loadWhatIfSimulation() async {
    final currentState = state.value;
    if (currentState?.whatIfSimulation != null) {
      return currentState!.whatIfSimulation;
    }

    // 캐시된 데이터가 없으면 API 호출
    final repository = ref.read(analysisRepositoryProvider);

    return await repository.getWhatIfSimulationReport();
  }
}
