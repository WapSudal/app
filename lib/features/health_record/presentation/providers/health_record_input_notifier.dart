import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'health_record_input_state.dart';
import '../../domain/entities/health_record_entity.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';

part 'health_record_input_notifier.g.dart';

@riverpod
class HealthRecordInput extends _$HealthRecordInput {
  @override
  HealthRecordInputState build() {
    return const HealthRecordInputState();
  }

  void updateWeight(String value) {
    state = state.copyWith(weight: value);
    _recalculateBMI();
  }

  void updateHeight(String value) {
    state = state.copyWith(height: value);
    _recalculateBMI();
  }

  void updateSystolicBP(String value) {
    state = state.copyWith(systolicBP: value);
  }

  void updateDiastolicBP(String value) {
    state = state.copyWith(diastolicBP: value);
  }

  void updateBloodSugar(String value) {
    state = state.copyWith(bloodSugar: value);
  }

  void updateSmokingStatus(SmokingStatus? value) {
    state = state.copyWith(smokingStatus: value);
  }

  void updateDrinkingLevel(DrinkingLevel? value) {
    state = state.copyWith(drinkingLevel: value);
  }

  void updateExerciseHours(String value) {
    state = state.copyWith(exerciseHours: value);
  }

  void updateMemo(String value) {
    state = state.copyWith(memo: value);
  }

  void _recalculateBMI() {
    final weight = double.tryParse(state.weight);
    final height = double.tryParse(state.height);
    final bmi = HealthRecordEntity.calculateBMI(weight, height);
    state = state.copyWith(bmi: bmi);
  }

  void reset() {
    state = const HealthRecordInputState();
  }
}
