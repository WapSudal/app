import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../connection/data/providers/connection_data_providers.dart';
import '../../../home/presentation/providers/home_notifier.dart';
import 'caregiver_request_list_state.dart';

part 'caregiver_request_list_notifier.g.dart';

@riverpod
class CaregiverRequestListNotifier extends _$CaregiverRequestListNotifier {
  @override
  Future<CaregiverRequestListState> build({
    required ConnectionType connectionType,
  }) async {
    final connectionRepository = ref.read(connectionRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    final pendingConnections = await connectionRepository.getCurrentConnections(
      type: connectionType,
      status: ConnectionStatus.pending,
    );

    final users = await userRepository.getAllUsers();

    final pendingCaregivers = users.where((user) {
      return pendingConnections.any(
        (connection) => connection.connectorEmail == user.email,
      );
    }).toList();

    return CaregiverRequestListState(pendingCaregivers: pendingCaregivers);
  }

  /// 보호자/주치의 수락 요청 수락
  Future<void> acceptCaregiverRequest(String connectorEmail) async {
    final connectionRepository = ref.read(connectionRepositoryProvider);
    await connectionRepository.acceptConnection(connectorEmail: connectorEmail);

    ref.invalidateSelf();
    ref.invalidate(homeProvider);
  }

  /// 보호자/주치의 수락 요청 거절
  Future<void> rejectCaregiverRequest(String connectorEmail) async {
    final connectionRepository = ref.read(connectionRepositoryProvider);
    await connectionRepository.rejectConnection(connectorEmail: connectorEmail);
    ref.invalidateSelf();
  }
}
