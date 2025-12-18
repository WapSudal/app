import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_recent_record_entity.freezed.dart';

/// 환자 최근 기록 Entity
///
/// Guardian/Doctor 홈 화면에서 "최근 작성된 기록" 섹션에 표시되는 정보
/// 여러 환자의 최근 기록을 통합하여 시간순으로 표시할 때 사용
@freezed
abstract class PatientRecentRecordEntity with _$PatientRecentRecordEntity {
  const factory PatientRecentRecordEntity({
    /// 기록 ID
    required String recordId,

    /// 환자 ID
    required String patientId,

    /// 환자 이름
    required String patientName,

    /// 프로필 이미지 URL (null이면 기본 이미지)
    String? patientProfileImageUrl,

    /// 기록 시간
    required DateTime recordedAt,

    /// 수축기 혈압 (mmHg)
    int? systolicBP,

    /// 이완기 혈압 (mmHg)
    int? diastolicBP,

    /// 혈당 (mg/dL)
    int? bloodSugar,
  }) = _PatientRecentRecordEntity;

  const PatientRecentRecordEntity._();

  /// 혈압 표시 문자열 (예: "120/80")
  String? get bloodPressureDisplay {
    if (systolicBP == null || diastolicBP == null) return null;
    return '$systolicBP/$diastolicBP';
  }

  /// 혈당 표시 문자열 (예: "95")
  String? get bloodSugarDisplay {
    if (bloodSugar == null) return null;
    return '$bloodSugar';
  }

  /// 주요 측정값 요약 (혈압 우선, 없으면 혈당)
  String get primaryValueDisplay {
    if (bloodPressureDisplay != null) {
      return '혈압 $bloodPressureDisplay';
    }
    if (bloodSugarDisplay != null) {
      return '혈당 $bloodSugarDisplay';
    }
    return '기록 있음';
  }

  /// 상대적 시간 표시 (예: "10분 전", "어제")
  String getRelativeTimeDisplay(DateTime now) {
    final diff = now.difference(recordedAt);

    if (diff.inMinutes < 1) {
      return '방금 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays == 1) {
      return '어제';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else {
      return '${recordedAt.month}월 ${recordedAt.day}일';
    }
  }
}
