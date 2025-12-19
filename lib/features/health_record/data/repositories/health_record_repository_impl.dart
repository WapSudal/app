import 'package:uuid/uuid.dart';
import '../../domain/repositories/health_record_repository.dart';
import '../../domain/entities/health_record_entity.dart';
import '../datasources/health_record_datasource.dart';
import '../models/health_record_model.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../connection/domain/repositories/connection_repository.dart';

class HealthRecordRepositoryImpl implements HealthRecordRepository {
  final HealthRecordDataSource _dataSource;
  final ConnectionRepository _connectionRepository;

  HealthRecordRepositoryImpl({
    required HealthRecordDataSource dataSource,
    required ConnectionRepository connectionRepository,
  })  : _dataSource = dataSource,
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
    final bmi = HealthRecordEntity.calculateBMI(weight, height);

    final entity = HealthRecordEntity(
      id: const Uuid().v4(),
      recordedAt: recordedAt,
      weight: weight,
      height: height,
      bmi: bmi,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      bloodSugar: bloodSugar,
      smokingStatus: smokingStatus,
      drinkingLevel: drinkingLevel,
      exerciseHours: exerciseHours,
      memo: memo,
    );

    final model = entity.toModel();
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
  Future<void> deleteHealthRecord(String id) async {
    await _dataSource.deleteHealthRecord(id);
  }

  @override
  Future<List<HealthRecordEntity>> getHealthRecordsByPatientId(
    String patientId,
  ) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientId: patientId,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException(
        '해당 환자의 건강 기록에 접근할 권한이 없습니다.',
      );
    }

    final models = await _dataSource.getHealthRecordsByUserId(patientId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<HealthRecordEntity?> getLatestHealthRecordByPatientId(
    String patientId,
  ) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientId: patientId,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException(
        '해당 환자의 건강 기록에 접근할 권한이 없습니다.',
      );
    }

    final model = await _dataSource.getLatestHealthRecordByUserId(patientId);
    return model?.toEntity();
  }
}
