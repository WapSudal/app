import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/patient_recent_record_entity.dart';

part 'patient_recent_record_model.freezed.dart';
part 'patient_recent_record_model.g.dart';

/// 환자 최근 기록 Model (API 응답용)
///
/// Guardian/Doctor 홈 화면의 "최근 작성된 기록" 섹션에 표시되는 정보
@freezed
abstract class PatientRecentRecordModel with _$PatientRecentRecordModel {
  const factory PatientRecentRecordModel({
    required String recordId,
    required String patientId,
    required String patientName,
    String? patientProfileImageUrl,
    required DateTime recordedAt,
    int? systolicBP,
    int? diastolicBP,
    int? bloodSugar,
  }) = _PatientRecentRecordModel;

  factory PatientRecentRecordModel.fromJson(Map<String, dynamic> json) =>
      _$PatientRecentRecordModelFromJson(json);
}

/// PatientRecentRecordModel 확장 메서드
extension PatientRecentRecordModelX on PatientRecentRecordModel {
  /// Model을 Entity로 변환
  PatientRecentRecordEntity toEntity() {
    return PatientRecentRecordEntity(
      recordId: recordId,
      patientId: patientId,
      patientName: patientName,
      patientProfileImageUrl: patientProfileImageUrl,
      recordedAt: recordedAt,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      bloodSugar: bloodSugar,
    );
  }
}
