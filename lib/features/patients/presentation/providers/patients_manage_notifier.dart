import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../connection/data/providers/connection_data_providers.dart';
import '../../../home/presentation/providers/caregiver_home_notifier.dart';
import 'patients_manage_state.dart';
import 'patients_notifier.dart';

part 'patients_manage_notifier.g.dart';

/// 환자 목록 화면 상태 관리 Provider
///
/// Guardian/Doctor가 관리하는 환자 목록을 로드하고 관리합니다.
@riverpod
class PatientsManageNotifier extends _$PatientsManageNotifier {
  @override
  Future<PatientsManageState> build() async {
    final connectionRepository = ref.read(connectionRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    final pendingConnections = await connectionRepository.getCurrentConnections(
      status: ConnectionStatus.pending,
    );

    final users = await userRepository.getAllUsers();

    final pendingPatients = users.where((user) {
      return pendingConnections.any(
        (connection) => connection.patientEmail == user.email,
      );
    }).toList();

    return PatientsManageState(pendingPatients: pendingPatients);
  }

  /// 환자에게 연결 요청 생성
  Future<void> createConnectionRequest({
    required String patientEmail,
    required SharingScope scope,
  }) async {
    final connectionRepository = ref.read(connectionRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    // 사용자 존재 여부 확인
    final users = await userRepository.getAllUsers();
    final userExists = users.any((user) => user.email == patientEmail);

    if (!userExists) {
      throw Exception('존재하지 않는 사용자입니다');
    }

    await connectionRepository.requestConnection(
      targetPatientEmail: patientEmail,
      scope: scope,
    );

    ref.invalidate(patientsProvider);
    ref.invalidate(caregiverHomeProvider);
  }
}
