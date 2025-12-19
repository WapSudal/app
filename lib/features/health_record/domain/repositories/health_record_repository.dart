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
  Future<void> deleteHealthRecord(String id);

  /// 특정 환자의 건강 기록 조회 (보호자/주치의용)
  ///
  /// [patientId]: 조회할 환자 ID
  ///
  /// Returns: 환자의 건강 기록 목록
  ///
  /// Throws:
  /// - UnauthorizedException: 환자 데이터에 접근 권한이 없음
  Future<List<HealthRecordEntity>> getHealthRecordsByPatientId(
    String patientId,
  );

  /// 특정 환자의 최신 건강 기록 조회 (보호자/주치의용)
  ///
  /// [patientId]: 조회할 환자 ID
  ///
  /// Returns: 환자의 최신 건강 기록
  ///
  /// Throws:
  /// - UnauthorizedException: 환자 데이터에 접근 권한이 없음
  Future<HealthRecordEntity?> getLatestHealthRecordByPatientId(
    String patientId,
  );
}
