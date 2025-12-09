import '../repositories/health_record_repository.dart';
import '../entities/health_record_entity.dart';

class GetLatestHealthRecordUseCase {
  final HealthRecordRepository _repository;

  GetLatestHealthRecordUseCase(this._repository);

  Future<HealthRecordEntity?> call() async {
    return await _repository.getLatestHealthRecord();
  }
}
