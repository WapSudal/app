import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/patient_summary_entity.dart';
import '../../../../core/enums/sharing_scope.dart';

part 'patient_summary_model.freezed.dart';
part 'patient_summary_model.g.dart';

/// 환자 요약 정보 Model (API 응답용)
///
/// Guardian/Doctor 홈 화면에서 관리하는 환자 목록을 표시할 때 사용
@freezed
abstract class PatientSummaryModel with _$PatientSummaryModel {
  const factory PatientSummaryModel({
    required String patientId,
    required String name,
    String? profileImageUrl,
    required PatientRiskLevel riskLevel,
    required int riskScore,
    int? systolicBP,
    int? diastolicBP,
    required int dataCount,
    DateTime? lastRecordedAt,
    required SharingScope scope,
    required String connectionId,
  }) = _PatientSummaryModel;

  factory PatientSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PatientSummaryModelFromJson(json);
}

/// PatientSummaryModel 확장 메서드
extension PatientSummaryModelX on PatientSummaryModel {
  /// Model을 Entity로 변환
  PatientSummaryEntity toEntity() {
    return PatientSummaryEntity(
      patientId: patientId,
      name: name,
      profileImageUrl: profileImageUrl,
      riskLevel: riskLevel,
      riskScore: riskScore,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      dataCount: dataCount,
      lastRecordedAt: lastRecordedAt,
      scope: scope,
      connectionId: connectionId,
    );
  }
}
