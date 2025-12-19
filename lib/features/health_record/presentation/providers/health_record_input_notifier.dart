import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../analysis/presentation/providers/analysis_notifier.dart';
import '../../../home/presentation/providers/home_notifier.dart';
import '../../data/providers/health_record_repository_provider.dart';
import 'health_record_input_state.dart';
import 'health_record_mutations.dart';
import '../../domain/entities/health_record_entity.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';
import 'health_record_notifier.dart';

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

  /// 건강 기록 저장
  void save() {
    if (!state.hasAnyData) return;

    saveHealthRecordMutation.run(ref, (tsx) async {
      final repository = tsx.get(healthRecordRepositoryProvider);

      await repository.saveHealthRecord(
        recordedAt: DateTime.now(),
        weight: double.tryParse(state.weight),
        height: double.tryParse(state.height),
        systolicBP: int.tryParse(state.systolicBP),
        diastolicBP: int.tryParse(state.diastolicBP),
        bloodSugar: int.tryParse(state.bloodSugar),
        smokingStatus: state.smokingStatus,
        drinkingLevel: state.drinkingLevel,
        exerciseHours: double.tryParse(state.exerciseHours),
        memo: state.memo.isNotEmpty ? state.memo : null,
      );

      ref.invalidate(homeProvider);
      ref.invalidate(healthRecordProvider);
      ref.invalidate(analysisProvider);
    });
  }
}
