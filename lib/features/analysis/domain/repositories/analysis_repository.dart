import '../entities/analysis_entity.dart';

/// 분석 Repository 인터페이스
abstract class AnalysisRepository {
  Future<AnalysisAvailabilityEntity> getAnalysisAvailability();
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummary();
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummaryByUserId(
    String userId,
  );
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReport();
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReportByUserId(
    String userId,
  );
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReport();
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReportByUserId(
    String userId,
  );
}
