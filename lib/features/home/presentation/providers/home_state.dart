import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/user_role.dart';
import '../../../analysis/domain/entities/analysis_entity.dart';
import '../../../health_record/domain/entities/health_record_entity.dart';

part 'home_state.freezed.dart';

/// 홈 화면 상태
///
/// Scenario B 패턴: 역할 정보를 State에 포함하여 권한 플래그로 UI 분기
///
/// Note: 로그아웃 작업의 isLoading과 errorMessage는 signOutMutation으로 분리됨
@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    /// 현재 사용자 역할
    /// TODO: riverpod 프로바이더로 사용하도록 삭제 필요
    @Default(UserRole.generalUser) UserRole role,

    /// 환자 관리 권한 (의료인만)
    @Default(false) bool canManagePatients,

    /// 보호자 기능 접근 권한 (보호자만)
    @Default(false) bool canAccessGuardianFeatures,

    /// 본인 건강 관리 권한 (일반 사용자만)
    @Default(false) bool canManageOwnHealth,

    /// 건강 기록 목록
    required List<HealthRecordEntity> healthRecords,

    /// 분석 가능 여부
    required AnalysisAvailabilityEntity analysisAvailability,

    /// 최신 위험도 분석 결과 (목업 데이터)
    RiskPredictionSummaryEntity? riskSummary,
  }) = _HomeState;
}

// ==================== Extensions ====================

extension HomeStateX on HomeState {
  /// 역할 표시 이름
  String get roleDisplayName => role.displayName;

  /// 역할 설명
  String get roleDescription => role.description;

  /// 건강 기록 개수
  int get recordCount => healthRecords.length;

  /// 이번 주 건강 기록 개수
  int get thisWeekRecordCount {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return healthRecords
        .where((record) => record.recordedAt.isAfter(startOfWeekDate))
        .length;
  }
}
