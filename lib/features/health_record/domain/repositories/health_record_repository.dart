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

  Future<List<HealthRecordEntity>> getHealthRecords();
  Future<HealthRecordEntity?> getLatestHealthRecord();
  Future<void> clearRecords();
  Future<void> deleteHealthRecord(String recordId);

  Future<List<HealthRecordEntity>> getHealthRecordsByEmail(String patientEmail);

  Future<HealthRecordEntity?> getLatestHealthRecordByEmail(String patientEmail);

  /// 연결된 모든 환자의 건강 기록 조회 (보호자/주치의용)
  ///
  /// Returns: Map<patientEmail, List<HealthRecordEntity>>
  Future<List<HealthRecordEntity>> getAllConnectedPatientsHealthRecords();
}
