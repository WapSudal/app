import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_mock_datasource.dart';
import '../repositories/analysis_repository_impl.dart';

part 'analysis_data_providers.g.dart';

/// Mock DataSource Provider
@riverpod
AnalysisMockDataSource analysisMockDataSource(Ref ref) {
  return AnalysisMockDataSource();
}

/// Analysis Repository Provider
@riverpod
AnalysisRepository analysisRepository(Ref ref) {
  return AnalysisRepositoryImpl(
    mockDataSource: ref.watch(analysisMockDataSourceProvider),
  );
}
