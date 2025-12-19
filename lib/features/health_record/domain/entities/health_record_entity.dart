import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';

part 'health_record_entity.freezed.dart';

@freezed
abstract class HealthRecordEntity with _$HealthRecordEntity {
  const factory HealthRecordEntity({
    required String id,
    required String patientEmail,
    required DateTime recordedAt,
    double? weight,
    double? height,
    double? bmi,
    int? systolicBP,
    int? diastolicBP,
    int? bloodSugar,
    SmokingStatus? smokingStatus,
    DrinkingLevel? drinkingLevel,
    double? exerciseHours,
    String? memo,
  }) = _HealthRecordEntity;

  const HealthRecordEntity._();

  /// BMI 계산 로직
  static double? calculateBMI(double? weight, double? height) {
    if (weight == null || height == null || height == 0) return null;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }
}
