import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/analysis_status_entity.dart';
import '../../domain/entities/risk_assessment_entity.dart';
import '../../domain/entities/what_if_scenario_entity.dart';

part 'analysis_state.freezed.dart';

/// 분석 화면 상태
@freezed
abstract class AnalysisState with _$AnalysisState {
  const factory AnalysisState({
    /// 분석 상태
    required AnalysisStatusEntity analysisStatus,

    /// 위험도 측정 결과 (분석 가능 시에만 존재)
    RiskAssessmentEntity? riskAssessment,

    /// What-if 시뮬레이션 결과 (분석 가능 시에만 존재)
    WhatIfSimulationEntity? whatIfSimulation,
  }) = _AnalysisState;

  const AnalysisState._();

  /// 분석 가능 여부
  bool get canAnalyze => analysisStatus.canAnalyze;

  /// 분석 준비 상태 메시지
  String get statusMessage {
    if (canAnalyze) {
      return '분석 준비 완료';
    }
    final needed = analysisStatus.recordsNeeded;
    return '$needed개의 건강 정보 필요';
  }
}

/// 기본 AnalysisState 생성
AnalysisState createDefaultAnalysisState() {
  return const AnalysisState(
    analysisStatus: AnalysisStatusEntity(
      canAnalyze: false,
      requiredRecordCount: 3,
      currentRecordCount: 0,
      recordsNeeded: 3,
      progress: 0.0,
    ),
  );
}
