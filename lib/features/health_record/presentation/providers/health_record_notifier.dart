import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/health_record_period_filter.dart';
import '../../data/providers/health_record_repository_provider.dart';
import 'health_record_state.dart';

part 'health_record_notifier.g.dart';

@riverpod
class HealthRecord extends _$HealthRecord {
  @override
  Future<HealthRecordState> build() async {
    final repository = ref.read(healthRecordRepositoryProvider);
    final records = await repository.getHealthRecords();
    return HealthRecordState(healthRecords: records);
  }

  /// 기간 필터 변경
  void updatePeriodFilter(HealthRecordPeriodFilter filter) {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(periodFilter: filter));
  }

  /// 기록 삭제
  Future<void> deleteRecord(String recordId) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      final repository = ref.read(healthRecordRepositoryProvider);
      await repository.deleteHealthRecord(recordId);

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
