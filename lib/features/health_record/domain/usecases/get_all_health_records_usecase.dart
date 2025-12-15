import '../repositories/health_record_repository.dart';
import '../entities/health_record_entity.dart';

class GetAllHealthRecordsUseCase {
  final HealthRecordRepository _repository;

  GetAllHealthRecordsUseCase(this._repository);

  Future<List<HealthRecordEntity>> call() async {
    return await _repository.getAllHealthRecords();
  }
}
