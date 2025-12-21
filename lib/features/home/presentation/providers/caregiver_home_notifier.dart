import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/connection_status.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../connection/data/providers/connection_data_providers.dart';
import '../../../health_record/data/providers/health_record_repository_provider.dart';
import 'caregiver_home_state.dart';

part 'caregiver_home_notifier.g.dart';

/// 보호자/주치의 홈 화면 상태 관리 Provider
///
/// Guardian과 Doctor 역할이 공유하는 홈 화면 상태를 관리합니다.
/// 환자 목록, 고위험 환자, 최근 기록 데이터를 로드하고 관리합니다.
@riverpod
class CaregiverHomeNotifier extends _$CaregiverHomeNotifier {
  @override
  Future<CaregiverHomeState> build() async {
    final connectionRepository = ref.read(connectionLocalDataSourceProvider);
    final healthRecordRepository = ref.read(healthRecordRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    final users = await userRepository.getAllUsers();
    final cons = await connectionRepository.getCurrentConnections(
      status: ConnectionStatus.accepted,
    );

    final connectedPatients = users
        .where((u) => cons.any((c) => c.patientEmail == u.email))
        .toList();

    final allRecords = await healthRecordRepository
        .getAllConnectedPatientsHealthRecords();
    allRecords.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return CaregiverHomeState(
      connectedPatients: connectedPatients,
      highRiskPatients: connectedPatients,
      recentRecords: allRecords.take(5).toList(),
    );
  }

  /// 환자 선택 (바텀 시트 표시용)
  void selectPatient(String patientEmail) {
    state = AsyncValue.data(
      state.value!.copyWith(selectedPatientEmail: patientEmail),
    );
  }

  /// 환자 선택 해제 (바텀 시트 닫기용)
  void clearSelectedPatient() {
    state = AsyncValue.data(state.value!.copyWith(selectedPatientEmail: null));
  }
}
