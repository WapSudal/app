import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../connection/data/providers/connection_data_providers.dart';
import 'patients_state.dart';

part 'patients_notifier.g.dart';

/// 환자 목록 화면 상태 관리 Provider
///
/// Guardian/Doctor가 관리하는 환자 목록을 로드하고 관리합니다.
@riverpod
class PatientsNotifier extends _$PatientsNotifier {
  @override
  Future<PatientsState> build() async {
    final userRepository = ref.read(userRepositoryProvider);
    final connectionRepository = ref.read(connectionRepositoryProvider);

    final connections = await connectionRepository.getCurrentConnections(
      status: ConnectionStatus.accepted,
    );
    final users = await userRepository.getAllUsers();

    final patients = users.where((user) {
      return connections.any(
        (connection) => connection.patientEmail == user.email,
      );
    }).toList();

    return PatientsState(patients: patients);
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
