import '../repositories/connection_repository.dart';

/// 연결 해제 UseCase
///
/// 환자 또는 보호자/주치의가 기존 연결을 해제합니다
class RevokeConnectionUseCase {
  final ConnectionRepository _repository;

  RevokeConnectionUseCase(this._repository);

  /// 연결 해제 실행
  ///
  /// [connectionId]: 해제할 연결 ID
  Future<void> call({
    required String connectionId,
  }) async {
    await _repository.revokeConnection(
      connectionId: connectionId,
    );
  }
}
