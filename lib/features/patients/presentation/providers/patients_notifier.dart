import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/sharing_scope.dart';
import '../../../connection/domain/entities/patient_summary_entity.dart';
import 'patients_state.dart';

part 'patients_notifier.g.dart';

/// 환자 목록 화면 상태 관리 Provider
///
/// Guardian/Doctor가 관리하는 환자 목록을 로드하고 관리합니다.
@riverpod
class PatientsNotifier extends _$PatientsNotifier {
  @override
  Future<PatientsState> build() async {
    // TODO: 실제 API 연동 시 GetMyConnectionsUseCase + PatientSummary 조회로 대체
    // 현재는 Mock 데이터 사용
    final patients = await _loadMockPatients();
    return PatientsState(patients: patients);
  }

  /// Mock 환자 데이터 로드
  Future<List<PatientSummaryEntity>> _loadMockPatients() async {
    // 네트워크 딜레이 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock 데이터 반환
    return [
      PatientSummaryEntity(
        patientId: 'patient1_uid',
        name: '김환자',
        profileImageUrl: null,
        riskLevel: PatientRiskLevel.warning,
        riskScore: 54,
        systolicBP: 145,
        diastolicBP: 92,
        dataCount: 12,
        lastRecordedAt: DateTime.now().subtract(const Duration(hours: 2)),
        scope: SharingScope.full,
        connectionId: 'conn_1',
      ),
      PatientSummaryEntity(
        patientId: 'patient2_uid',
        name: '이환자',
        profileImageUrl: null,
        riskLevel: PatientRiskLevel.danger,
        riskScore: 32,
        systolicBP: 168,
        diastolicBP: 105,
        dataCount: 8,
        lastRecordedAt: DateTime.now().subtract(const Duration(hours: 5)),
        scope: SharingScope.full,
        connectionId: 'conn_2',
      ),
      PatientSummaryEntity(
        patientId: 'patient3_uid',
        name: '박환자',
        profileImageUrl: null,
        riskLevel: PatientRiskLevel.safe,
        riskScore: 15,
        systolicBP: 118,
        diastolicBP: 78,
        dataCount: 25,
        lastRecordedAt: DateTime.now().subtract(const Duration(days: 1)),
        scope: SharingScope.summary,
        connectionId: 'conn_3',
      ),
    ];
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
