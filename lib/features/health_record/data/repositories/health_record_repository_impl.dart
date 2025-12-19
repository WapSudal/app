import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../connection/domain/entities/connection_entity.dart';
import '../../domain/repositories/health_record_repository.dart';
import '../../domain/entities/health_record_entity.dart';
import '../datasources/health_record_local_datasource.dart';
import '../models/health_record_model.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../connection/domain/repositories/connection_repository.dart';

class HealthRecordRepositoryImpl implements HealthRecordRepository {
  final HealthRecordLocalDataSource _dataSource;
  final ConnectionRepository _connectionRepository;

  HealthRecordRepositoryImpl({
    required HealthRecordLocalDataSource dataSource,
    required ConnectionRepository connectionRepository,
  }) : _dataSource = dataSource,
       _connectionRepository = connectionRepository;
  @override
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
  }) async {
    // TODO: 개선 필요
    final email = FirebaseAuth.instance.currentUser!.email!;
    final bmi = HealthRecordEntity.calculateBMI(weight, height);

    final model = HealthRecordModel(
      id: const Uuid().v4(),
      patientEmail: email,
      recordedAt: recordedAt.toIso8601String(),
      weight: weight,
      height: height,
      bmi: bmi,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      bloodSugar: bloodSugar,
      smokingStatus: smokingStatus?.name,
      drinkingLevel: drinkingLevel?.name,
      exerciseHours: exerciseHours,
      memo: memo,
    );

    await _dataSource.saveHealthRecord(model);
  }

  @override
  Future<List<HealthRecordEntity>> getHealthRecords() async {
    final models = await _dataSource.getHealthRecords();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<HealthRecordEntity?> getLatestHealthRecord() async {
    final model = await _dataSource.getLatestHealthRecord();
    return model?.toEntity();
  }

  @override
  Future<void> clearRecords() async {
    await _dataSource.clearRecords();
  }

  @override
  Future<void> deleteHealthRecord(String recordId) async {
    await _dataSource.deleteHealthRecord(recordId);
  }

  @override
  Future<List<HealthRecordEntity>> getHealthRecordsByEmail(
    String patientEmail,
  ) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientEmail: patientEmail,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException('해당 환자의 건강 기록에 접근할 권한이 없습니다.');
    }

    final models = await _dataSource.getHealthRecordsByEmail(patientEmail);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<HealthRecordEntity?> getLatestHealthRecordByEmail(
    String patientEmail,
  ) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientEmail: patientEmail,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException('해당 환자의 건강 기록에 접근할 권한이 없습니다.');
    }

    final model = await _dataSource.getLatestHealthRecordByEmail(patientEmail);
    return model?.toEntity();
  }

  @override
  Future<List<HealthRecordEntity>>
  getAllConnectedPatientsHealthRecords() async {
    // 1. 현재 사용자의 활성 연결 목록 조회
    final connections = await _connectionRepository.getCurrentConnections();

    // 2. 각 환자의 건강 기록 조회
    final result = <HealthRecordEntity>[];

    for (final connection in connections) {
      // 활성 연결이고 건강 기록 접근 권한이 있는 경우만 조회
      if (connection.canAccessHealthRecords) {
        try {
          final models = await _dataSource.getHealthRecordsByEmail(
            connection.patientEmail,
          );
          result.addAll(models.map((m) => m.toEntity()).toList());
        } catch (e) {
          // 개별 환자 데이터 조회 실패 시 건너뛰기
          // (다른 환자 데이터는 정상 반환)
          continue;
        }
      }
    }

    return result;
  }
}
