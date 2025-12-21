import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../models/connection_model.dart';

abstract class ConnectionLocalDataSource {
  Future<ConnectionModel> requestConnection({
    required String targetPatientEmail,
    required ConnectionType type,
    required SharingScope scope,
  });
  Future<List<ConnectionModel>> getCurrentConnections({
    ConnectionType? type,
    ConnectionStatus? status,
  });
  Future<void> acceptConnection({required String connectorEmail});
  Future<void> rejectConnection({required String connectorEmail});
  Future<void> revokeConnection({required String connectorEmail});
  Future<bool> canAccessPatientData({
    required String patientEmail,
    required SharingScope requiredScope,
  });
}
