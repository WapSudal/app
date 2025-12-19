import '../models/analysis_model.dart';

abstract class AnalysisDataSource {
  Future<AnalysisAvailabilityModel> getAnalysisAvailability();
  Future<RiskPredictionSummaryModel?> getRiskPredictionSummary();
  Future<RiskPredictionSummaryModel?> getRiskPredictionSummaryByUserId(
    String userId,
  );
  Future<RiskAssessmentReportModel?> getRiskAssessmentReport();
  Future<RiskAssessmentReportModel?> getRiskAssessmentReportByUserId(
    String userId,
  );
  Future<WhatIfSimulationReportModel?> getWhatIfSimulationReport();
  Future<WhatIfSimulationReportModel?> getWhatIfSimulationReportByUserId(
    String userId,
  );
}
