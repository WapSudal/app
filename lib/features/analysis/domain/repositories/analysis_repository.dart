import '../entities/analysis_entity.dart';

/// 분석 Repository 인터페이스
abstract class AnalysisRepository {
  Future<AnalysisAvailabilityEntity> getAnalysisAvailability();
  Future<AnalysisAvailabilityEntity> getAnalysisAvailabilityByEmail(
    String patientEmail,
  );
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummary();
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummaryByEmail(
    String patientEmail,
  );
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReport();
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReportByEmail(
    String patientEmail,
  );
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReport();
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReportByEmail(
    String patientEmail,
  );
}
