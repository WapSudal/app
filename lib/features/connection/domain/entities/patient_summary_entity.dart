import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/sharing_scope.dart';

part 'patient_summary_entity.freezed.dart';

/// 연결된 환자 요약 정보 Entity
///
/// Guardian/Doctor가 홈 화면에서 관리하는 환자 목록을 표시할 때 사용
/// 환자의 기본 정보와 최신 건강 상태를 포함
@freezed
abstract class PatientSummaryEntity with _$PatientSummaryEntity {
  const factory PatientSummaryEntity({
    /// 환자 ID
    required String patientId,

    /// 환자 이름
    required String name,

    /// 프로필 이미지 URL (null이면 기본 이미지)
    String? profileImageUrl,

    /// 위험도 레벨
    required PatientRiskLevel riskLevel,

    /// 위험도 점수 (0-100)
    required int riskScore,

    /// 최근 수축기 혈압 (mmHg)
    int? systolicBP,

    /// 최근 이완기 혈압 (mmHg)
    int? diastolicBP,

    /// 기록된 데이터 건수
    required int dataCount,

    /// 마지막 기록 시간
    DateTime? lastRecordedAt,

    /// 공유 범위 (보호자/주치의에게 공유된 범위)
    required SharingScope scope,

    /// 연결 ID (Connection ID)
    required String connectionId,
  }) = _PatientSummaryEntity;

  const PatientSummaryEntity._();

  /// 혈압 표시 문자열 (예: "120/80")
  String? get bloodPressureDisplay {
    if (systolicBP == null || diastolicBP == null) return null;
    return '$systolicBP/$diastolicBP';
  }

  /// 데이터 건수 표시 문자열 (예: "3건")
  String get dataCountDisplay => '$dataCount건';

  /// 위험도 점수 표시 문자열 (예: "54점")
  String get riskScoreDisplay => '$riskScore점';

  /// 고위험 환자 여부
  bool get isHighRisk =>
      riskLevel == PatientRiskLevel.danger ||
      riskLevel == PatientRiskLevel.warning;
}

/// 환자 위험도 레벨
///
/// Guardian/Doctor 홈 화면에서 환자 상태를 시각적으로 구분하기 위한 enum
enum PatientRiskLevel {
  /// 안전 (정상)
  safe('안전', 0xFF71CE6E),

  /// 주의 (경고)
  warning('주의', 0xFFFF9500),

  /// 위험
  danger('위험', 0xFFFF4130),

  /// 데이터 없음
  unknown('미확인', 0xFF9E9E9E);

  const PatientRiskLevel(this.label, this.colorValue);

  final String label;
  final int colorValue;
}
