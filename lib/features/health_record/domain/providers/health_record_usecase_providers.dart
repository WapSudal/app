import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../usecases/save_health_record_usecase.dart';
import '../usecases/get_latest_health_record_usecase.dart';
import '../usecases/get_all_health_records_usecase.dart';
import '../usecases/delete_health_record_usecase.dart';
import '../../data/providers/health_record_repository_provider.dart';

part 'health_record_usecase_providers.g.dart';

@riverpod
SaveHealthRecordUseCase saveHealthRecordUseCase(Ref ref) {
  return SaveHealthRecordUseCase(ref.watch(healthRecordRepositoryProvider));
}

@riverpod
GetLatestHealthRecordUseCase getLatestHealthRecordUseCase(Ref ref) {
  return GetLatestHealthRecordUseCase(
    ref.watch(healthRecordRepositoryProvider),
  );
}

@riverpod
GetAllHealthRecordsUseCase getAllHealthRecordsUseCase(Ref ref) {
  return GetAllHealthRecordsUseCase(ref.watch(healthRecordRepositoryProvider));
}

@riverpod
DeleteHealthRecordUseCase deleteHealthRecordUseCase(Ref ref) {
  return DeleteHealthRecordUseCase(ref.watch(healthRecordRepositoryProvider));
}
