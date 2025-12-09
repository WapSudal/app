import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';
import '../../domain/entities/health_record_entity.dart';

part 'health_record_model.freezed.dart';
part 'health_record_model.g.dart';

@freezed
abstract class HealthRecordModel with _$HealthRecordModel {
  const factory HealthRecordModel({
    required String id,
    required String recordedAt,
    double? weight,
    double? height,
    double? bmi,
    int? systolicBP,
    int? diastolicBP,
    int? bloodSugar,
    String? smokingStatus,
    String? drinkingLevel,
    double? exerciseHours,
    String? memo,
  }) = _HealthRecordModel;

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordModelFromJson(json);
}

// ==================== Extensions ====================
extension HealthRecordModelX on HealthRecordModel {
  HealthRecordEntity toEntity() {
    return HealthRecordEntity(
      id: id,
      recordedAt: DateTime.parse(recordedAt),
      weight: weight,
      height: height,
      bmi: bmi,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      bloodSugar: bloodSugar,
      smokingStatus: smokingStatus != null
          ? SmokingStatus.values.firstWhere((e) => e.name == smokingStatus)
          : null,
      drinkingLevel: drinkingLevel != null
          ? DrinkingLevel.values.firstWhere((e) => e.name == drinkingLevel)
          : null,
      exerciseHours: exerciseHours,
      memo: memo,
    );
  }
}

extension HealthRecordEntityX on HealthRecordEntity {
  HealthRecordModel toModel() {
    return HealthRecordModel(
      id: id,
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
  }
}
