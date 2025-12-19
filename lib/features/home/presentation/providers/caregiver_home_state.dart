import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../health_record/domain/entities/health_record_entity.dart';

part 'caregiver_home_state.freezed.dart';

/// 보호자/주치의 홈 화면 상태
///
/// Guardian과 Doctor 역할이 공유하는 홈 화면 상태
/// 환자 목록, 고위험 환자, 최근 기록 등을 관리
@freezed
abstract class CaregiverHomeState with _$CaregiverHomeState {
  const factory CaregiverHomeState({
    /// 연결된 환자 목록
    @Default([]) List<UserEntity> connectedPatients,

    /// 고위험 환자 목록 (Warning/Danger 상태)
    @Default([]) List<UserEntity> highRiskPatients,

    /// 최근 환자 기록 목록
    required List<HealthRecordEntity> recentRecords,

    /// 현재 선택된 환자 ID (바텀 시트용, null이면 선택 안됨)
    String? selectedPatientEmail,
  }) = _CaregiverHomeState;
}

// ==================== Extensions ====================

extension CaregiverHomeStateX on CaregiverHomeState {
  /// 관리 중인 환자 수
  int get connectedPatientCount => connectedPatients.length;

  /// 고위험 환자 수
  int get highRiskPatientCount => highRiskPatients.length;

  /// 현재 선택된 환자 Entity
  UserEntity? get selectedPatient {
    if (selectedPatientEmail == null) return null;
    return connectedPatients
        .where((p) => p.email == selectedPatientEmail)
        .firstOrNull;
  }

  /// 데이터가 있는지 여부
  bool get hasData => connectedPatients.isNotEmpty;

  /// 주의가 필요한 환자가 있는지 여부
  bool get hasHighRiskPatients => highRiskPatients.isNotEmpty;
}
