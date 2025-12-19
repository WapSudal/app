import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../health_record/data/providers/health_record_datasource_provider.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_mock_datasource.dart';
import '../repositories/analysis_repository_impl.dart';

part 'analysis_data_providers.g.dart';

/// Mock DataSource Provider
@Riverpod(keepAlive: true)
AnalysisMockDataSource analysisMockDataSource(Ref ref) {
  return AnalysisMockDataSource(
    healthRecordDataSource: ref.watch(healthRecordLocalDataSourceProvider),
  );
}

/// Analysis Repository Provider
@Riverpod(keepAlive: true)
AnalysisRepository analysisRepository(Ref ref) {
  return AnalysisRepositoryImpl(
    dataSource: ref.watch(analysisMockDataSourceProvider),
  );
}
