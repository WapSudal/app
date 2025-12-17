import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../health_record/domain/entities/health_record_entity.dart';
import '../../../health_record/domain/providers/health_record_usecase_providers.dart';
import 'health_record_state.dart';

part 'health_record_notifier.g.dart';

@riverpod
class HealthRecord extends _$HealthRecord {
  @override
  Future<HealthRecordState> build() async {
    final records = await _fetchAllRecords();
    return HealthRecordState(healthRecords: records);
  }

  Future<List<HealthRecordEntity>> _fetchAllRecords() async {
    final useCase = ref.read(getAllHealthRecordsUseCaseProvider);
    return await useCase();
  }

  /// 기간 필터 변경
  void updatePeriodFilter(HealthRecordPeriodFilter filter) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(periodFilter: filter));
  }

  /// 기록 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final records = await _fetchAllRecords();
      final currentFilter =
          state.value?.periodFilter ?? HealthRecordPeriodFilter.week;
      return HealthRecordState(
        healthRecords: records,
        periodFilter: currentFilter,
      );
    });
  }

  /// 기록 삭제
  Future<void> deleteRecord(String recordId) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      // UseCase를 통해 실제 삭제 수행
      final deleteUseCase = ref.read(deleteHealthRecordUseCaseProvider);
      await deleteUseCase(recordId);

      // 삭제 성공 시 로컬 상태 업데이트
      final updatedRecords = currentState.healthRecords
          .where((r) => r.id != recordId)
          .toList();

      state = AsyncValue.data(
        currentState.copyWith(healthRecords: updatedRecords),
      );
    } catch (error, stackTrace) {
      // 삭제 실패 시 에러 상태로 변경
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
