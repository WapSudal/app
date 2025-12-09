import '../repositories/health_record_repository.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';

class SaveHealthRecordUseCase {
  final HealthRecordRepository _repository;

  SaveHealthRecordUseCase(this._repository);

  Future<void> call({
    required DateTime recordedAt,
    double? weight,
    double? height,
    int? systolicBP,
    int? diastolicBP,
    int? bloodSugar,
    SmokingStatus? smokingStatus,
    DrinkingLevel? drinkingLevel,
    double? exerciseHours,
    String? memo,
  }) async {
    return await _repository.saveHealthRecord(
      recordedAt: recordedAt,
      weight: weight,
      height: height,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      bloodSugar: bloodSugar,
      smokingStatus: smokingStatus,
      drinkingLevel: drinkingLevel,
      exerciseHours: exerciseHours,
      memo: memo,
    );
  }
}
