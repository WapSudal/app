import '../repositories/health_record_repository.dart';

class DeleteHealthRecordUseCase {
  final HealthRecordRepository _repository;

  DeleteHealthRecordUseCase(this._repository);

  Future<void> call(String id) async {
    return await _repository.deleteHealthRecord(id);
  }
}
