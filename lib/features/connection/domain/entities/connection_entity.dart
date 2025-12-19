import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/sharing_scope.dart';

part 'connection_entity.freezed.dart';

/// 환자와 보호자/주치의 간의 연결 관계 Entity
///
/// 연결 요청, 수락, 거절, 해제 등의 상태를 관리
@freezed
abstract class ConnectionEntity with _$ConnectionEntity {
  const factory ConnectionEntity({
    /// 연결 ID
    required String id,

    /// 환자 이메일
    required String patientEmail,

    /// 연결자 이메일 (보호자 또는 주치의)
    required String connectorEmail,

    /// 연결 유형 (보호자 또는 주치의)
    required ConnectionType type,

    /// 연결 상태 (대기중, 수락됨, 거절됨, 해제됨)
    required ConnectionStatus status,

    /// 공유 범위 (전체, 요약만, 알림만)
    required SharingScope scope,

    /// 연결 요청 시각
    required DateTime requestedAt,
  }) = _ConnectionEntity;
}

extension ConnectionEntityX on ConnectionEntity {
  /// 활성 연결 여부
  bool get isActive => status.isActive;

  /// 대기중 여부
  bool get isPending => status.isPending;

  /// 종료된 상태 여부
  bool get isTerminated => status.isTerminated;

  /// 건강 기록 접근 가능 여부
  bool get canAccessHealthRecords => isActive && scope.canAccessHealthRecords;

  /// 위험도 분석 접근 가능 여부
  bool get canAccessRiskAnalysis => isActive && scope.canAccessRiskAnalysis;

  /// What-if 시뮬레이션 접근 가능 여부
  bool get canAccessWhatIf => isActive && scope.canAccessWhatIf;

  /// 알림 수신 가능 여부
  bool get canReceiveAlerts => isActive && scope.canReceiveAlerts;
}
