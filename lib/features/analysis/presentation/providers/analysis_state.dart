import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/analysis_entity.dart';

part 'analysis_state.freezed.dart';

/// 분석 화면 상태
@freezed
abstract class AnalysisState with _$AnalysisState {
  const factory AnalysisState({
    /// 건강 기록 목록
    required AnalysisAvailabilityEntity analysisAvailability,

    /// 위험도 측정 결과 (분석 가능 시에만 존재)
    RiskAssessmentReportEntity? riskAssessment,

    /// What-if 시뮬레이션 결과 (분석 가능 시에만 존재)
    WhatIfSimulationReportEntity? whatIfSimulation,
  }) = _AnalysisState;
}
