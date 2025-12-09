import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/health_record_repository.dart';
import '../repositories/health_record_repository_impl.dart';
import 'health_record_datasource_provider.dart';

part 'health_record_repository_provider.g.dart';

@Riverpod(keepAlive: true)
HealthRecordRepository healthRecordRepository(Ref ref) {
  return HealthRecordRepositoryImpl(
    localDataSource: ref.watch(healthRecordLocalDataSourceProvider),
  );
}
