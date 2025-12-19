import '../../../../core/enums/sharing_scope.dart';
import '../entities/connection_entity.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';

/// 연결 관리 Repository 인터페이스
///
/// 환자와 보호자/주치의 간의 연결 요청, 수락, 거절, 해제 등을 관리
abstract class ConnectionRepository {
  Future<ConnectionEntity> requestConnection({
    required String targetPatientEmail,
    required SharingScope scope,
  });
  Future<List<ConnectionEntity>> getCurrentConnections({
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
