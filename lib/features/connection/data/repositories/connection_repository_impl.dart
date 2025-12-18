import '../../domain/entities/connection_entity.dart';
import '../../domain/entities/patient_search_info_entity.dart';
import '../../domain/repositories/connection_repository.dart';
import '../datasources/connection_local_datasource.dart';
import '../models/connection_model.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/sharing_scope.dart';

/// ConnectionRepository 구현체
///
/// 현재는 Mock DataSource만 사용 (향후 Remote DataSource 추가)
class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionLocalDataSource _localDataSource;
  final String Function() _getCurrentUserId; // 현재 로그인한 사용자 ID를 얻는 함수

  ConnectionRepositoryImpl({
    required ConnectionLocalDataSource localDataSource,
    required String Function() getCurrentUserId,
  })  : _localDataSource = localDataSource,
        _getCurrentUserId = getCurrentUserId;

  @override
  Future<ConnectionEntity> sendConnectionRequest({
    required PatientSearchInfoEntity patientInfo,
    required ConnectionType type,
    required SharingScope scope,
  }) async {
    final currentUserId = _getCurrentUserId();

    final model = await _localDataSource.sendConnectionRequest(
      currentUserId: currentUserId,
      patientInfo: patientInfo,
      type: type,
      scope: scope,
    );

    return model.toEntity();
  }

  @override
  Future<List<ConnectionEntity>> getPendingRequests() async {
    final currentUserId = _getCurrentUserId();

    final models = await _localDataSource.getPendingRequests(
      currentUserId: currentUserId,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ConnectionEntity> acceptConnection({
    required String connectionId,
  }) async {
    final currentUserId = _getCurrentUserId();

    final model = await _localDataSource.acceptConnection(
      currentUserId: currentUserId,
      connectionId: connectionId,
    );

    return model.toEntity();
  }

  @override
  Future<ConnectionEntity> rejectConnection({
    required String connectionId,
  }) async {
    final currentUserId = _getCurrentUserId();

    final model = await _localDataSource.rejectConnection(
      currentUserId: currentUserId,
      connectionId: connectionId,
    );

    return model.toEntity();
  }

  @override
  Future<List<ConnectionEntity>> getMyConnections({
    ConnectionType? type,
    ConnectionStatus? status,
  }) async {
    final currentUserId = _getCurrentUserId();

    final models = await _localDataSource.getMyConnections(
      currentUserId: currentUserId,
      type: type,
      status: status,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> revokeConnection({
    required String connectionId,
  }) async {
    final currentUserId = _getCurrentUserId();

    await _localDataSource.revokeConnection(
      currentUserId: currentUserId,
      connectionId: connectionId,
    );
  }

  @override
  Future<bool> canAccessPatientData({
    required String patientId,
    required SharingScope requiredScope,
  }) async {
    final currentUserId = _getCurrentUserId();

    return await _localDataSource.canAccessPatientData(
      currentUserId: currentUserId,
      patientId: patientId,
      requiredScope: requiredScope,
    );
  }

  @override
  Future<ConnectionEntity> getConnectionById({
    required String connectionId,
  }) async {
    final model = await _localDataSource.getConnectionById(
      connectionId: connectionId,
    );

    return model.toEntity();
  }
}
