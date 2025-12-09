import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';

part 'health_record_input_state.freezed.dart';

@freezed
abstract class HealthRecordInputState with _$HealthRecordInputState {
  const factory HealthRecordInputState({
    @Default('') String weight,
    @Default('') String height,
    @Default(null) double? bmi,
    @Default('') String systolicBP,
    @Default('') String diastolicBP,
    @Default('') String bloodSugar,
    @Default(null) SmokingStatus? smokingStatus,
    @Default(null) DrinkingLevel? drinkingLevel,
    @Default('') String exerciseHours,
    @Default('') String memo,
  }) = _HealthRecordInputState;

  const HealthRecordInputState._();

  // Validation helpers
  bool get hasWeight => weight.isNotEmpty;
  bool get hasHeight => height.isNotEmpty;
  bool get hasSystolicBP => systolicBP.isNotEmpty;
  bool get hasDiastolicBP => diastolicBP.isNotEmpty;

  // At least one field must be filled
  bool get hasAnyData =>
      hasWeight ||
      hasHeight ||
      hasSystolicBP ||
      hasDiastolicBP ||
      bloodSugar.isNotEmpty ||
      smokingStatus != null ||
      drinkingLevel != null ||
      exerciseHours.isNotEmpty ||
      memo.isNotEmpty;
}
