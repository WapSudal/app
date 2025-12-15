import 'package:uuid/uuid.dart';
import '../../domain/repositories/health_record_repository.dart';
import '../../domain/entities/health_record_entity.dart';
import '../datasources/health_record_local_datasource.dart';
import '../models/health_record_model.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';

class HealthRecordRepositoryImpl implements HealthRecordRepository {
  final HealthRecordLocalDataSource _localDataSource;

  HealthRecordRepositoryImpl({
    required HealthRecordLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

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
    await _localDataSource.saveRecord(model);
  }

  @override
  Future<HealthRecordEntity?> getLatestHealthRecord() async {
    final model = await _localDataSource.getLatestRecord();
    return model?.toEntity();
  }

  @override
  Future<List<HealthRecordEntity>> getAllHealthRecords() async {
    final models = await _localDataSource.getRecords();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deleteHealthRecord(String id) async {
    await _localDataSource.deleteRecord(id);
  }
}
