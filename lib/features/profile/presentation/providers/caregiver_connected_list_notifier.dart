import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../connection/data/providers/connection_data_providers.dart';
import '../../../home/presentation/providers/home_notifier.dart';
import 'caregiver_connected_list_state.dart';

part 'caregiver_connected_list_notifier.g.dart';

@riverpod
class CaregiverConnectedListNotifier extends _$CaregiverConnectedListNotifier {
  @override
  Future<CaregiverConnectedListState> build({
    required ConnectionType connectionType,
  }) async {
    final connectionRepository = ref.read(connectionRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    final connectedConnections = await connectionRepository
        .getCurrentConnections(
          type: connectionType,
          status: ConnectionStatus.accepted,
        );

    final users = await userRepository.getAllUsers();

    final connectedCaregivers = users.where((user) {
      return connectedConnections.any(
        (connection) => connection.connectorEmail == user.email,
      );
    }).toList();

    return CaregiverConnectedListState(
      connectedCaregivers: connectedCaregivers,
    );
  }

  /// 보호자/주치의 연결 해제
  Future<void> revokeCaregiverConnection(String connectorEmail) async {
    final connectionRepository = ref.read(connectionRepositoryProvider);
    await connectionRepository.revokeConnection(connectorEmail: connectorEmail);

    ref.invalidateSelf();
    ref.invalidate(homeProvider);
  }
}
