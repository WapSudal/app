import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../health_record/domain/providers/health_record_usecase_providers.dart';
import '../../../user/presentation/providers/registered_user_notifier.dart';
import 'home_state.dart';

part 'home_notifier.g.dart';

/// 홈 화면 상태 관리 Provider
///
/// Scenario B 패턴: 역할 정보를 State에 주입하여 권한 기반 UI 분기
///
/// Note: 로그아웃 작업은 signOutMutation으로 분리됨
/// - UI에서 signOutMutation의 상태를 watch하여 로딩/에러 처리
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    // registeredUserProvider에서 역할 정보 가져와서 State 초기화
    final registeredUserState = ref.watch(registeredUserProvider);
    final user = registeredUserState.user;

    if (user != null) {
      final baseState = HomeState.fromRole(user.role);
      // 건강 기록 로드
      _loadHealthRecords(baseState);
      return baseState;
    }

    return const HomeState();
  }

  /// 건강 기록 로드
  Future<void> _loadHealthRecords(HomeState baseState) async {
    try {
      final getAllHealthRecordsUseCase = ref.read(
        getAllHealthRecordsUseCaseProvider,
      );
      final records = await getAllHealthRecordsUseCase();

      // 3개 이상이면 목업 위험도 분석 결과 생성
      RiskAnalysisResult? riskAnalysis;
      if (records.length >= 3) {
        riskAnalysis = RiskAnalysisResult(
          riskPercentage: 13, // 목업 데이터
          riskLevel: RiskLevel.low,
          updatedAt: DateTime(2025, 11, 28), // 목업 데이터
        );
      }

      state = baseState.copyWith(
        healthRecords: records,
        riskAnalysisResult: riskAnalysis,
      );
    } catch (e) {
      // 에러 발생 시 빈 목록 유지
    }
  }

  /// 건강 기록 새로고침
  Future<void> refreshHealthRecords() async {
    await _loadHealthRecords(state);
  }
}
