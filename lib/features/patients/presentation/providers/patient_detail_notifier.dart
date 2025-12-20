import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/health_record_period_filter.dart';
import '../../../analysis/data/providers/analysis_data_providers.dart';
import '../../../analysis/domain/entities/analysis_entity.dart';
import '../../../health_record/data/providers/health_record_repository_provider.dart';
import 'patient_detail_state.dart';

part 'patient_detail_notifier.g.dart';

/// 분석 화면 상태 관리 Provider
@riverpod
class PatientDetailNotifier extends _$PatientDetailNotifier {
  @override
  Future<PatientDetailState> build({required String patientEmail}) async {
    // Repository 가져오기
    final analysisRepository = ref.read(analysisRepositoryProvider);
    final healthRecordRepository = ref.read(healthRecordRepositoryProvider);

    final availability = await analysisRepository.getAnalysisAvailability();

    final healthRecords = await healthRecordRepository.getHealthRecordsByEmail(
      patientEmail,
    );

    // 분석 가능 여부에 따라 위험도 및 시뮬레이션 결과 조회
    if (availability.canAnalyze) {
      final riskAssessment = await analysisRepository.getRiskAssessmentReport();
      final whatIfSimulation = await analysisRepository
          .getWhatIfSimulationReport();

      return PatientDetailState(
        healthRecords: healthRecords,
        analysisAvailability: availability,
        riskAssessment: riskAssessment,
        whatIfSimulation: whatIfSimulation,
      );
    }

    return PatientDetailState(
      healthRecords: healthRecords,
      analysisAvailability: availability,
    );
  }

  /// 위험도 측정 결과 로드 (상세 화면 이동용)
  Future<RiskAssessmentReportEntity?> loadRiskAssessment() async {
    final currentState = state.value;
    if (currentState?.riskAssessment != null) {
      return currentState!.riskAssessment;
    }

    // 캐시된 데이터가 없으면 API 호출
    final repository = ref.read(analysisRepositoryProvider);

    return await repository.getRiskAssessmentReport();
  }

  /// What-if 시뮬레이션 결과 로드 (상세 화면 이동용)
  Future<WhatIfSimulationReportEntity?> loadWhatIfSimulation() async {
    final currentState = state.value;
    if (currentState?.whatIfSimulation != null) {
      return currentState!.whatIfSimulation;
    }

    // 캐시된 데이터가 없으면 API 호출
    final repository = ref.read(analysisRepositoryProvider);

    return await repository.getWhatIfSimulationReport();
  }

  /// 선택된 탭 변경
  void changeTab(PatientDetailTab tab) {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncValue.data(currentState.copyWith(selectedTab: tab));
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
