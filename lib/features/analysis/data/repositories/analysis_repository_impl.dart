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
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReport() async {
    final model = await _dataSource.getRiskAssessmentReport();

    return model?.toEntity();
  }

  @override
  Future<RiskAssessmentReportEntity?> getRiskAssessmentReportByUserId(
    String userId,
  ) async {
    final model = await _dataSource.getRiskAssessmentReportByUserId(userId);

    return model?.toEntity();
  }

  @override
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummary() async {
    final model = await _dataSource.getRiskPredictionSummary();

    return model?.toEntity();
  }

  @override
  Future<RiskPredictionSummaryEntity?> getRiskPredictionSummaryByUserId(
    String userId,
  ) async {
    final model = await _dataSource.getRiskPredictionSummaryByUserId(userId);

    return model?.toEntity();
  }

  @override
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReport() async {
    final model = await _dataSource.getWhatIfSimulationReport();

    return model?.toEntity();
  }

  @override
  Future<WhatIfSimulationReportEntity?> getWhatIfSimulationReportByUserId(
    String userId,
  ) async {
    final model = await _dataSource.getWhatIfSimulationReportByUserId(userId);

    return model?.toEntity();
  }
}
