import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../models/connection_model.dart';

abstract class ConnectionLocalDataSource {
  Future<ConnectionModel> requestConnection({
    required String targetPatientEmail,
    required SharingScope scope,
  });
  Future<List<ConnectionModel>> getCurrentConnections({
    ConnectionType? type,
    ConnectionStatus? status,
  });
  Future<void> acceptConnection({required String connectionId});
  Future<void> rejectConnection({required String connectionId});
  Future<void> revokeConnection({required String connectionId});
  Future<bool> canAccessPatientData({
    required String patientEmail,
    required SharingScope requiredScope,
  });
}
