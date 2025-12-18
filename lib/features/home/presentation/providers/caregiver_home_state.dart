import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/user_role.dart';
import '../../../connection/domain/entities/patient_summary_entity.dart';
import '../../../connection/domain/entities/patient_recent_record_entity.dart';

part 'caregiver_home_state.freezed.dart';

/// 보호자/주치의 홈 화면 상태
///
/// Guardian과 Doctor 역할이 공유하는 홈 화면 상태
/// 환자 목록, 고위험 환자, 최근 기록 등을 관리
@freezed
abstract class CaregiverHomeState with _$CaregiverHomeState {
  const factory CaregiverHomeState({
    /// 현재 사용자 역할 (guardian 또는 doctor)
    @Default(UserRole.guardian) UserRole role,

    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 에러 메시지
    String? errorMessage,

    /// 연결된 환자 목록
    @Default([]) List<PatientSummaryEntity> connectedPatients,

    /// 고위험 환자 목록 (Warning/Danger 상태)
    @Default([]) List<PatientSummaryEntity> highRiskPatients,

    /// 최근 환자 기록 목록
    @Default([]) List<PatientRecentRecordEntity> recentRecords,

    /// 현재 선택된 환자 ID (바텀 시트용, null이면 선택 안됨)
    String? selectedPatientId,
  }) = _CaregiverHomeState;

  const CaregiverHomeState._();

  /// 역할 기반 초기 상태 생성
  factory CaregiverHomeState.fromRole(UserRole role) {
    return CaregiverHomeState(role: role);
  }
}

// ==================== Extensions ====================

extension CaregiverHomeStateX on CaregiverHomeState {
  /// 관리 중인 환자 수
  int get connectedPatientCount => connectedPatients.length;

  /// 고위험 환자 수
  int get highRiskPatientCount => highRiskPatients.length;

  /// 현재 선택된 환자 Entity
  PatientSummaryEntity? get selectedPatient {
    if (selectedPatientId == null) return null;
    return connectedPatients
        .where((p) => p.patientId == selectedPatientId)
        .firstOrNull;
  }

  /// 데이터가 있는지 여부
  bool get hasData => connectedPatients.isNotEmpty;

  /// 주의가 필요한 환자가 있는지 여부
  bool get hasHighRiskPatients => highRiskPatients.isNotEmpty;

  /// 역할 표시 이름
  String get roleDisplayName => role.displayName;

  /// 보호자 역할인지 여부
  bool get isGuardian => role == UserRole.guardian;

  /// 주치의 역할인지 여부
  bool get isDoctor => role == UserRole.doctor;
}
