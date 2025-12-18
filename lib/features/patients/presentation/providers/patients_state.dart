import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../connection/domain/entities/patient_summary_entity.dart';

part 'patients_state.freezed.dart';

/// 환자 목록 화면 상태
@freezed
abstract class PatientsState with _$PatientsState {
  const factory PatientsState({
    /// 환자 목록
    @Default([]) List<PatientSummaryEntity> patients,
  }) = _PatientsState;

  const PatientsState._();

  /// 연결된 환자가 있는지 여부
  bool get hasPatients => patients.isNotEmpty;
}
