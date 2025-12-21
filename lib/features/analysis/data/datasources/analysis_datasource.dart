import '../models/analysis_model.dart';

abstract class AnalysisDataSource {
  Future<AnalysisAvailabilityModel> getAnalysisAvailability();
  Future<AnalysisAvailabilityModel> getAnalysisAvailabilityByEmail(
    String patientEmail,
  );
  Future<RiskPredictionSummaryModel?> getRiskPredictionSummary();
  Future<RiskPredictionSummaryModel?> getRiskPredictionSummaryByEmail(
    String patientEmail,
  );
  Future<RiskAssessmentReportModel?> getRiskAssessmentReport();
  Future<RiskAssessmentReportModel?> getRiskAssessmentReportByEmail(
    String patientEmail,
  );
  Future<WhatIfSimulationReportModel?> getWhatIfSimulationReport();
  Future<WhatIfSimulationReportModel?> getWhatIfSimulationReportByEmail(
    String patientEmail,
  );
}
