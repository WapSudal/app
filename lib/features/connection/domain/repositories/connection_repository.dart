import '../entities/connection_entity.dart';
import '../entities/patient_search_info_entity.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/sharing_scope.dart';

/// 연결 관리 Repository 인터페이스
///
/// 환자와 보호자/주치의 간의 연결 요청, 수락, 거절, 해제 등을 관리
abstract class ConnectionRepository {
  /// 보호자/주치의가 환자에게 연결 신청
  ///
  /// [patientInfo]: 환자 검색 정보 (이름, 생년월일, 이메일)
  /// [type]: 연결 유형 (guardian 또는 doctor)
  /// [scope]: 공유 범위 (full, summary, alertOnly)
  ///
  /// Returns: 생성된 연결 Entity
  ///
  /// Throws:
  /// - PatientNotFoundException: 환자를 찾을 수 없음
  /// - AlreadyConnectedException: 이미 연결 요청이 존재함 (pending 또는 accepted)
  /// - UnauthorizedException: 권한 없음 (일반 사용자는 연결 요청 불가)
  Future<ConnectionEntity> sendConnectionRequest({
    required PatientSearchInfoEntity patientInfo,
    required ConnectionType type,
    required SharingScope scope,
  });

  /// 환자가 받은 대기중인 연결 요청 조회
  ///
  /// Returns: status가 pending인 연결 목록
  ///
  /// Note: 현재 로그인한 사용자가 환자여야 함
  Future<List<ConnectionEntity>> getPendingRequests();

  /// 환자가 연결 요청 수락
  ///
  /// [connectionId]: 수락할 연결 ID
  ///
  /// Returns: status가 accepted로 변경된 연결 Entity
  ///
  /// Throws:
  /// - ConnectionNotFoundException: 연결을 찾을 수 없음
  /// - UnauthorizedException: 권한 없음 (환자 본인만 수락 가능)
  /// - InvalidStatusException: 이미 처리된 요청 (accepted, rejected, revoked)
  Future<ConnectionEntity> acceptConnection({
    required String connectionId,
  });

  /// 환자가 연결 요청 거절
  ///
  /// [connectionId]: 거절할 연결 ID
  ///
  /// Returns: status가 rejected로 변경된 연결 Entity
  ///
  /// Throws:
  /// - ConnectionNotFoundException: 연결을 찾을 수 없음
  /// - UnauthorizedException: 권한 없음 (환자 본인만 거절 가능)
  /// - InvalidStatusException: 이미 처리된 요청
  Future<ConnectionEntity> rejectConnection({
    required String connectionId,
  });

  /// 내 연결 목록 조회
  ///
  /// [type]: 연결 유형 필터 (null이면 전체)
  /// [status]: 연결 상태 필터 (null이면 전체)
  ///
  /// Returns: 연결 목록
  ///
  /// Note: 역할에 따라 다른 데이터 반환
  /// - 환자: connectorId가 타인인 연결들 (나에게 연결된 보호자/주치의)
  /// - 보호자/주치의: patientId가 타인인 연결들 (내가 연결한 환자들)
  Future<List<ConnectionEntity>> getMyConnections({
    ConnectionType? type,
    ConnectionStatus? status,
  });

  /// 연결 해제
  ///
  /// [connectionId]: 해제할 연결 ID
  ///
  /// Note: status를 revoked로 변경, revokedAt 기록
  ///
  /// Throws:
  /// - ConnectionNotFoundException: 연결을 찾을 수 없음
  /// - UnauthorizedException: 권한 없음 (환자 또는 연결자만 해제 가능)
  /// - InvalidStatusException: 이미 종료된 연결 (rejected, revoked)
  Future<void> revokeConnection({
    required String connectionId,
  });

  /// 특정 환자 데이터에 대한 접근 권한 확인
  ///
  /// [patientId]: 환자 ID
  /// [requiredScope]: 필요한 최소 공유 범위
  ///
  /// Returns: 접근 가능 여부
  ///
  /// Note: 다른 feature (HealthRecord, Analysis, WhatIf)에서 사용
  /// - 연결이 accepted 상태여야 함
  /// - scope가 requiredScope 이상이어야 함
  Future<bool> canAccessPatientData({
    required String patientId,
    required SharingScope requiredScope,
  });

  /// 연결 상세 정보 조회
  ///
  /// [connectionId]: 조회할 연결 ID
  ///
  /// Returns: 연결 Entity
  ///
  /// Throws:
  /// - ConnectionNotFoundException: 연결을 찾을 수 없음
  Future<ConnectionEntity> getConnectionById({
    required String connectionId,
  });
}
