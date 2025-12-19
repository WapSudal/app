import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/user_role.dart';
import '../../../analysis/data/providers/analysis_data_providers.dart';
import '../../../auth/applications/registered_user_notifier.dart';
import '../../../health_record/data/providers/health_record_repository_provider.dart';
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
  Future<HomeState> build() async {
    // registeredUserProvider에서 역할 정보 가져와서 State 초기화
    final registeredUserState = ref.watch(registeredUserProvider);
    final user = registeredUserState.user;

    if (user == null) throw Exception('User not found');

    final healthRecordRepository = ref.watch(healthRecordRepositoryProvider);
    final analysisRepository = ref.watch(analysisRepositoryProvider);

    final analysisAvailability = await analysisRepository
        .getAnalysisAvailability();
    final healthRecords = await healthRecordRepository.getHealthRecords();
    final riskSummary = await analysisRepository.getRiskPredictionSummary();

    final role = user.role;
    return HomeState(
      healthRecords: healthRecords,
      riskSummary: riskSummary,
      analysisAvailability: analysisAvailability,
      role: role,
      canManagePatients: role.canManagePatients,
      canAccessGuardianFeatures: role.canAccessGuardianFeatures,
      canManageOwnHealth: role.canManageOwnHealth,
    );
  }
}
