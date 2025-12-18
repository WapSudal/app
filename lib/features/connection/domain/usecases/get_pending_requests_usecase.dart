import '../entities/connection_entity.dart';
import '../repositories/connection_repository.dart';

/// 대기중인 연결 요청 조회 UseCase
///
/// 환자가 받은 pending 상태의 연결 요청 목록을 조회합니다
class GetPendingRequestsUseCase {
  final ConnectionRepository _repository;

  GetPendingRequestsUseCase(this._repository);

  /// 대기중인 연결 요청 조회 실행
  ///
  /// Returns: pending 상태의 연결 목록
  Future<List<ConnectionEntity>> call() async {
    return await _repository.getPendingRequests();
  }
}
