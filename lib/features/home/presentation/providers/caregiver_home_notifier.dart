import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/user_role.dart';
import '../../../connection/data/datasources/connection_local_datasource.dart';
import '../../../connection/data/models/patient_summary_model.dart';
import '../../../connection/data/models/patient_recent_record_model.dart';
import '../../../../core/providers/registered_user_notifier.dart';
import 'caregiver_home_state.dart';

part 'caregiver_home_notifier.g.dart';

/// 보호자/주치의 홈 화면 상태 관리 Provider
///
/// Guardian과 Doctor 역할이 공유하는 홈 화면 상태를 관리합니다.
/// 환자 목록, 고위험 환자, 최근 기록 데이터를 로드하고 관리합니다.
@riverpod
class CaregiverHomeNotifier extends _$CaregiverHomeNotifier {
  // Mock DataSource (실제 구현에서는 Repository/UseCase로 대체)
  late final ConnectionLocalDataSource _dataSource;

  @override
  CaregiverHomeState build() {
    _dataSource = ConnectionLocalDataSource();

    // registeredUserProvider에서 역할 정보 가져와서 State 초기화
    final registeredUserState = ref.watch(registeredUserProvider);
    final user = registeredUserState.user;

    if (user != null &&
        (user.role == UserRole.guardian || user.role == UserRole.doctor)) {
      final baseState = CaregiverHomeState.fromRole(user.role);
      // 데이터 로드 시작
      _loadCaregiverData(baseState, user.uid);
      return baseState.copyWith(isLoading: true);
    }

    return const CaregiverHomeState();
  }

  /// 보호자/주치의 홈 데이터 로드
  Future<void> _loadCaregiverData(
    CaregiverHomeState baseState,
    String userId,
  ) async {
    try {
      // 역할에 따른 연결 유형 결정
      final connectionType = baseState.role == UserRole.guardian
          ? ConnectionType.guardian
          : ConnectionType.doctor;

      // 병렬로 데이터 로드
      final results = await Future.wait([
        _dataSource.getConnectedPatientsSummary(
          currentUserId: userId,
          type: connectionType,
        ),
        _dataSource.getHighRiskPatients(
          currentUserId: userId,
          type: connectionType,
        ),
        _dataSource.getRecentPatientRecords(
          currentUserId: userId,
          type: connectionType,
          limit: 10,
        ),
      ]);

      final connectedPatients = (results[0] as List<PatientSummaryModel>)
          .map((m) => m.toEntity())
          .toList();

      final highRiskPatients = (results[1] as List<PatientSummaryModel>)
          .map((m) => m.toEntity())
          .toList();

      final recentRecords = (results[2] as List<PatientRecentRecordModel>)
          .map((m) => m.toEntity())
          .toList();

      state = baseState.copyWith(
        isLoading: false,
        connectedPatients: connectedPatients,
        highRiskPatients: highRiskPatients,
        recentRecords: recentRecords,
      );
    } catch (e) {
      state = baseState.copyWith(
        isLoading: false,
        errorMessage: '데이터를 불러오는데 실패했습니다: $e',
      );
    }
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    final registeredUserState = ref.read(registeredUserProvider);
    final user = registeredUserState.user;

    if (user == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    await _loadCaregiverData(state, user.uid);
  }

  /// 환자 선택 (바텀 시트 표시용)
  void selectPatient(String patientId) {
    state = state.copyWith(selectedPatientId: patientId);
  }

  /// 환자 선택 해제 (바텀 시트 닫기용)
  void clearSelectedPatient() {
    state = state.copyWith(selectedPatientId: null);
  }

  /// 에러 메시지 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
