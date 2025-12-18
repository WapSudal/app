import '../entities/connection_entity.dart';
import '../repositories/connection_repository.dart';

/// 연결 요청 수락 UseCase
///
/// 환자가 보호자/주치의의 연결 요청을 수락합니다
class AcceptConnectionUseCase {
  final ConnectionRepository _repository;

  AcceptConnectionUseCase(this._repository);

  /// 연결 요청 수락 실행
  ///
  /// [connectionId]: 수락할 연결 ID
  ///
  /// Returns: status가 accepted로 변경된 연결 Entity
  Future<ConnectionEntity> call({
    required String connectionId,
  }) async {
    return await _repository.acceptConnection(
      connectionId: connectionId,
    );
  }
}
