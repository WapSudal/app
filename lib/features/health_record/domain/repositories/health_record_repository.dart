import '../entities/health_record_entity.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';

abstract class HealthRecordRepository {
  Future<void> saveHealthRecord({
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
  });

  Future<HealthRecordEntity?> getLatestHealthRecord();
  Future<List<HealthRecordEntity>> getAllHealthRecords();
  Future<void> deleteHealthRecord(String id);
}
