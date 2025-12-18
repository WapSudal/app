import '../entities/connection_entity.dart';
import '../repositories/connection_repository.dart';

/// 연결 요청 거절 UseCase
///
/// 환자가 보호자/주치의의 연결 요청을 거절합니다
class RejectConnectionUseCase {
  final ConnectionRepository _repository;

  RejectConnectionUseCase(this._repository);

  /// 연결 요청 거절 실행
  ///
  /// [connectionId]: 거절할 연결 ID
  ///
  /// Returns: status가 rejected로 변경된 연결 Entity
  Future<ConnectionEntity> call({
    required String connectionId,
  }) async {
    return await _repository.rejectConnection(
      connectionId: connectionId,
    );
  }
}
