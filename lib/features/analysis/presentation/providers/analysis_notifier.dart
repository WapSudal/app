import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/risk_assessment_entity.dart';
import '../../domain/entities/what_if_scenario_entity.dart';
import '../../../health_record/domain/providers/health_record_usecase_providers.dart';
import '../../data/providers/analysis_data_providers.dart';
import 'analysis_state.dart';

part 'analysis_notifier.g.dart';

/// 분석 화면 상태 관리 Provider
@riverpod
class AnalysisNotifier extends _$AnalysisNotifier {
  @override
  Future<AnalysisState> build() async {
    // 건강 기록 개수 조회
    final getAllHealthRecordsUseCase = ref.read(
      getAllHealthRecordsUseCaseProvider,
    );
    final records = await getAllHealthRecordsUseCase();
    final recordCount = records.length;

    // Repository 가져오기
    final repository = ref.read(analysisRepositoryProvider);

    // 분석 상태 조회
    final analysisStatus = await repository.getAnalysisStatus(
      recordCount: recordCount,
    );

    // 분석 가능 여부에 따라 위험도 및 시뮬레이션 결과 조회
    if (analysisStatus.canAnalyze) {
      final riskAssessment = await repository.getRiskAssessment(
        recordCount: recordCount,
      );
      final whatIfSimulation = await repository.getWhatIfSimulation(
        recordCount: recordCount,
      );

      return AnalysisState(
        analysisStatus: analysisStatus,
        riskAssessment: riskAssessment,
        whatIfSimulation: whatIfSimulation,
      );
    }

    return AnalysisState(analysisStatus: analysisStatus);
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// 위험도 측정 결과 로드 (상세 화면 이동용)
  Future<RiskAssessmentEntity?> loadRiskAssessment() async {
    final currentState = state.value;
    if (currentState?.riskAssessment != null) {
      return currentState!.riskAssessment;
    }

    // 캐시된 데이터가 없으면 API 호출
    final repository = ref.read(analysisRepositoryProvider);
    final getAllHealthRecordsUseCase = ref.read(
      getAllHealthRecordsUseCaseProvider,
    );
    final records = await getAllHealthRecordsUseCase();
    final recordCount = records.length;

    return await repository.getRiskAssessment(recordCount: recordCount);
  }

  /// What-if 시뮬레이션 결과 로드 (상세 화면 이동용)
  Future<WhatIfSimulationEntity?> loadWhatIfSimulation() async {
    final currentState = state.value;
    if (currentState?.whatIfSimulation != null) {
      return currentState!.whatIfSimulation;
    }

    // 캐시된 데이터가 없으면 API 호출
    final repository = ref.read(analysisRepositoryProvider);
    final getAllHealthRecordsUseCase = ref.read(
      getAllHealthRecordsUseCaseProvider,
    );
    final records = await getAllHealthRecordsUseCase();
    final recordCount = records.length;

    return await repository.getWhatIfSimulation(recordCount: recordCount);
  }
}
