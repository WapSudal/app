import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/analysis/presentation/views/analysis_view.dart';
import '../../features/explore/presentation/views/explore_view.dart';
import '../../features/health_record/presentation/views/health_record_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../enums/user_role.dart';

/// 역할별 라우트 구성을 제공하는 클래스
///
/// 각 역할마다 다른 탭 구성을 가진 네비게이션을 제공합니다.
class RoleRoutes {
  /// 역할에 따른 StatefulShellBranch 리스트 반환
  ///
  /// [role]: 사용자 역할
  /// Returns: 해당 역할에 맞는 네비게이션 탭 리스트
  static List<StatefulShellBranch> getBranchesForRole(UserRole role) {
    switch (role) {
      case UserRole.generalUser:
        return _generalUserBranches;
      case UserRole.guardian:
        return _guardianBranches;
      case UserRole.doctor:
        return _doctorBranches;
      case UserRole.admin:
        return _adminBranches;
    }
  }

  /// 일반 사용자 탭 구성 (5개)
  /// - 홈: 대시보드 및 주요 정보
  /// - 기록: 건강 기록 입력 및 관리
  /// - 분석: 건강 데이터 분석 및 통계
  /// - 탐색: 건강 정보 콘텐츠 탐색
  /// - 프로필: 내 정보 및 전체 메뉴
  static final List<StatefulShellBranch> _generalUserBranches = [
    // Tab 1: 홈
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),
      ],
    ),
    // Tab 2: 기록
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/record',
          name: 'record',
          builder: (context, state) => const HealthRecordView(),
        ),
      ],
    ),
    // Tab 3: 분석
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/analysis',
          name: 'analysis',
          builder: (context, state) => const AnalysisView(),
        ),
      ],
    ),
    // Tab 4: 탐색
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/explore',
          name: 'explore',
          builder: (context, state) => const ExploreView(),
        ),
      ],
    ),
    // Tab 5: 프로필
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileView(),
        ),
      ],
    ),
  ];

  /// 보호자 탭 구성 (3개 - 일부 미구현)
  /// - 환자 목록: 관리 중인 환자 목록 (TODO: 미구현)
  /// - 기록 조회: 환자의 건강 기록 조회 (읽기 전용)
  /// - 분석: 환자의 건강 데이터 분석
  static final List<StatefulShellBranch> _guardianBranches = [
    // Tab 1: 환자 목록 (TODO: 추후 구현 예정 - 현재는 홈으로 대체)
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),
      ],
    ),
    // Tab 2: 기록 조회 (읽기 전용)
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/record',
          name: 'record',
          builder: (context, state) => const HealthRecordView(),
        ),
      ],
    ),
    // Tab 3: 분석
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/analysis',
          name: 'analysis',
          builder: (context, state) => const AnalysisView(),
        ),
      ],
    ),
  ];

  /// 주치의 탭 구성 (3개 - 보호자와 동일)
  /// - 환자 목록: 관리 중인 환자 목록 (TODO: 미구현)
  /// - 기록 조회: 환자의 건강 기록 조회 (읽기 전용)
  /// - 분석: 환자의 건강 데이터 분석
  static final List<StatefulShellBranch> _doctorBranches = [
    // Tab 1: 환자 목록 (TODO: 추후 구현 예정 - 현재는 홈으로 대체)
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),
      ],
    ),
    // Tab 2: 기록 조회 (읽기 전용)
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/record',
          name: 'record',
          builder: (context, state) => const HealthRecordView(),
        ),
      ],
    ),
    // Tab 3: 분석
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/analysis',
          name: 'analysis',
          builder: (context, state) => const AnalysisView(),
        ),
      ],
    ),
  ];

  /// 관리자 탭 구성 (1개 - 미구현)
  /// - 콘텐츠 관리: 공지사항, 건강 정보 콘텐츠 관리 (TODO: 미구현)
  static final List<StatefulShellBranch> _adminBranches = [
    // Tab 1: 콘텐츠 관리 (TODO: 추후 구현 예정 - 현재는 홈으로 대체)
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),
      ],
    ),
  ];
}
