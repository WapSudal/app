import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../domain/entities/connection_entity.dart';
import '../../domain/repositories/connection_repository.dart';
import '../datasources/connection_local_datasource.dart';
import '../models/connection_model.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionLocalDataSource localDataSource;

  ConnectionRepositoryImpl({required this.localDataSource});

  @override
  Future<ConnectionEntity> requestConnection({
    required String targetPatientEmail,
    required ConnectionType type,
    required SharingScope scope,
  }) {
    final model = localDataSource.requestConnection(
      targetPatientEmail: targetPatientEmail,
      type: type,
      scope: scope,
    );

    return model.then((m) => m.toEntity());
  }

  @override
  Future<List<ConnectionEntity>> getCurrentConnections({
    ConnectionType? type,
    ConnectionStatus? status,
  }) {
    final model = localDataSource.getCurrentConnections(
      type: type,
      status: status,
    );

    return model.then((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> acceptConnection({required String connectorEmail}) {
    return localDataSource.acceptConnection(connectorEmail: connectorEmail);
  }

  @override
  Future<void> rejectConnection({required String connectorEmail}) {
    return localDataSource.rejectConnection(connectorEmail: connectorEmail);
  }

  @override
  Future<void> revokeConnection({required String connectorEmail}) {
    return localDataSource.revokeConnection(connectorEmail: connectorEmail);
  }

  @override
  Future<bool> canAccessPatientData({
    required String patientEmail,
    required SharingScope requiredScope,
  }) {
    return localDataSource.canAccessPatientData(
      patientEmail: patientEmail,
      requiredScope: requiredScope,
    );
  }
}
