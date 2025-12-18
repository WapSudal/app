import '../entities/connection_entity.dart';
import '../repositories/connection_repository.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';

/// 내 연결 목록 조회 UseCase
///
/// 사용자 역할에 따라 다른 연결 목록을 조회합니다
/// - 환자: 나에게 연결된 보호자/주치의 목록
/// - 보호자/주치의: 내가 연결한 환자 목록
class GetMyConnectionsUseCase {
  final ConnectionRepository _repository;

  GetMyConnectionsUseCase(this._repository);

  /// 내 연결 목록 조회 실행
  ///
  /// [type]: 연결 유형 필터 (null이면 전체)
  /// [status]: 연결 상태 필터 (null이면 전체)
  ///
  /// Returns: 연결 목록
  Future<List<ConnectionEntity>> call({
    ConnectionType? type,
    ConnectionStatus? status,
  }) async {
    return await _repository.getMyConnections(
      type: type,
      status: status,
    );
  }
}
