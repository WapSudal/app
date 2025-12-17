import '../../domain/entities/analysis_status_entity.dart';
import '../../domain/entities/risk_assessment_entity.dart';
import '../../domain/entities/what_if_scenario_entity.dart';

/// 분석 Repository 인터페이스
abstract class AnalysisRepository {
  /// 분석 상태 조회
  Future<AnalysisStatusEntity> getAnalysisStatus({required int recordCount});

  /// 위험도 측정 결과 조회
  Future<RiskAssessmentEntity?> getRiskAssessment({required int recordCount});

  /// What-if 시뮬레이션 결과 조회
  Future<WhatIfSimulationEntity?> getWhatIfSimulation({
    required int recordCount,
  });
}
