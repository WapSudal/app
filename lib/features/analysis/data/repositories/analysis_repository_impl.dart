import '../../domain/entities/analysis_entity.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_datasource.dart';
import '../models/analysis_model.dart';

/// 분석 Repository 구현체
class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisDataSource _dataSource;

  AnalysisRepositoryImpl({required AnalysisDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<AnalysisAvailabilityEntity> getAnalysisAvailability() async {
    final model = await _dataSource.getAnalysisAvailability();

    return model.toEntity();
  }

  @override
  Future<AnalysisAvailabilityEntity> getAnalysisAvailabilityByEmail(
    String patientEmail,
  ) async {
    final model = await _dataSource.getAnalysisAvailabilityByEmail(
      patientEmail,
    );

    return model.toEntity();
  }

  @override
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReport() async {
    final model = await _dataSource.getRiskAssessmentReport();

    return model?.toEntity();
  }

  @override
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReportByEmail(
    String patientEmail,
  ) async {
    final model = await _dataSource.getRiskAssessmentReportByEmail(
      patientEmail,
    );

    return model?.toEntity();
  }

  @override
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummary() async {
    final model = await _dataSource.getRiskPredictionSummary();

    return model?.toEntity();
  }

  @override
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummaryByEmail(
    String patientEmail,
  ) async {
    final model = await _dataSource.getRiskPredictionSummaryByEmail(
      patientEmail,
    );

    return model?.toEntity();
  }

  @override
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReport() async {
    final model = await _dataSource.getWhatIfSimulationReport();

    return model?.toEntity();
  }

  @override
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReportByEmail(
    String patientEmail,
  ) async {
    final model = await _dataSource.getWhatIfSimulationReportByEmail(
      patientEmail,
    );

    return model?.toEntity();
  }
}
