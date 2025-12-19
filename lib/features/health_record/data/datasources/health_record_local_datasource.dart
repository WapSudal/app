import '../models/health_record_model.dart';

abstract class HealthRecordLocalDataSource {
  Future<void> saveHealthRecord(HealthRecordModel record);
  Future<List<HealthRecordModel>> getHealthRecords();
  Future<HealthRecordModel?> getLatestHealthRecord();
  Future<void> clearRecords();
  Future<void> deleteHealthRecord(String recordId);

  /// 특정 사용자의 건강 기록 조회 (보호자/주치의용)
  Future<List<HealthRecordModel>> getHealthRecordsByEmail(String patientEmail);

  /// 특정 사용자의 최신 건강 기록 조회 (보호자/주치의용)
  Future<HealthRecordModel?> getLatestHealthRecordByEmail(String patientEmail);
}
