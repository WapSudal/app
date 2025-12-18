import '../entities/connection_entity.dart';
import '../entities/patient_search_info_entity.dart';
import '../repositories/connection_repository.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/sharing_scope.dart';

/// 연결 요청 전송 UseCase
///
/// 보호자 또는 주치의가 환자에게 연결 요청을 보냅니다
class SendConnectionRequestUseCase {
  final ConnectionRepository _repository;

  SendConnectionRequestUseCase(this._repository);

  /// 연결 요청 실행
  ///
  /// [patientInfo]: 환자 검색 정보 (이름, 생년월일, 이메일)
  /// [type]: 연결 유형 (guardian 또는 doctor)
  /// [scope]: 공유 범위 (full, summary, alertOnly)
  ///
  /// Returns: 생성된 연결 Entity
  Future<ConnectionEntity> call({
    required PatientSearchInfoEntity patientInfo,
    required ConnectionType type,
    required SharingScope scope,
  }) async {
    return await _repository.sendConnectionRequest(
      patientInfo: patientInfo,
      type: type,
      scope: scope,
    );
  }
}
