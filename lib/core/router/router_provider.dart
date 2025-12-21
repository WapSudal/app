import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/analysis/domain/entities/analysis_entity.dart';
import '../../features/analysis/presentation/views/risk_assessment_view.dart';
import '../../features/analysis/presentation/views/what_if_simulation_view.dart';
import '../../features/auth/applications/auth_notifier.dart';
import '../../features/auth/applications/registered_user_notifier.dart';
import '../../features/patients/presentation/views/patient_detail_view.dart';
import '../../features/profile/presentation/views/account_manage_view.dart';
import '../../features/health_record/presentation/views/health_record_all_view.dart';
import '../../features/health_record/presentation/views/health_record_input_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/profile/presentation/views/report_manage_view.dart';
import '../../features/role_select/presentation/views/role_select_view.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../presentation/widgets/bottom_nav_shell.dart';
import 'role_routes.dart';

part 'router_provider.g.dart';

/// 인증이 필요하지 않은 경로 목록
const _publicRoutes = ['/', '/onboarding'];

/// 역할 선택 경로
const _roleSelectRoute = '/role-select';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // 인증 상태 구독
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  // 가입 완료 상태 구독
  final isRegistered = ref.watch(isUserRegisteredProvider);

  // 사용자 역할 감지 (bottom nav 표시 여부 결정)
  final registeredUserState = ref.watch(registeredUserProvider);
  final userRole = registeredUserState.user?.role;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      // Splash 화면에서는 리다이렉트 제외 (자체 로직 처리)
      if (currentPath == '/') {
        return null;
      }

      // === 인증 관련 리다이렉트 ===

      // 인증되지 않은 상태에서 protected route 접근 시 온보딩으로
      final isPublicRoute = _publicRoutes.contains(currentPath);
      if (!isAuthenticated && !isPublicRoute) {
        return '/onboarding';
      }

      // 인증된 상태에서 온보딩 접근 시
      if (isAuthenticated && currentPath == '/onboarding') {
        // 가입 완료 시 홈으로, 미완료 시 역할 선택으로
        return isRegistered ? '/home' : _roleSelectRoute;
      }

      // === 가입 완료 관련 리다이렉트 ===

      // 가입 완료된 상태에서 역할 선택 페이지 접근 시 홈으로
      if (isAuthenticated && isRegistered && currentPath == _roleSelectRoute) {
        return '/home';
      }

      // 인증됐지만 가입 미완료 상태에서 홈 등 접근 시 역할 선택으로
      if (isAuthenticated &&
          !isRegistered &&
          !isPublicRoute &&
          currentPath != _roleSelectRoute) {
        return _roleSelectRoute;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/role-select',
        name: 'roleSelect',
        builder: (context, state) => const RoleSelectView(),
      ),

      // Role-based navigation with bottom nav
      // 역할별 탭 구성을 RoleRoutes에서 동적으로 로드
      if (userRole != null)
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BottomNavShell(
              navigationShell: navigationShell,
              userRole: userRole,
            );
          },
          branches: RoleRoutes.getBranchesForRole(userRole),
        ),

      // Full-screen routes without bottom navigation
      GoRoute(
        path: '/record/input',
        name: 'recordInput',
        builder: (context, state) => const HealthRecordInputView(),
      ),
      GoRoute(
        path: '/record/all',
        name: 'recordAll',
        builder: (context, state) => const HealthRecordAllView(),
      ),
      // Analysis feature routes
      GoRoute(
        path: '/analysis/risk-assessment',
        name: 'riskAssessment',
        builder: (context, state) {
          final riskAssessment = state.extra as RiskAssessmentReportEntity;
          return RiskAssessmentView(riskAssessment: riskAssessment);
        },
      ),
      GoRoute(
        path: '/analysis/what-if',
        name: 'whatIfSimulation',
        builder: (context, state) {
          final simulation = state.extra as WhatIfSimulationReportEntity;
          return WhatIfSimulationView(simulation: simulation);
        },
      ),
      // Account management route
      GoRoute(
        path: '/account-management',
        name: 'accountManagement',
        builder: (context, state) => const AccountManageView(),
      ),
      GoRoute(
        path: '/report-management',
        name: 'reportManagement',
        builder: (context, state) => const ReportManageView(),
      ),
      GoRoute(
        path: '/patients/:patientEmail/detail',
        name: 'patientDetail',
        builder: (context, state) {
          final patientEmail = state.pathParameters['patientEmail']!;

          return PatientDetailView(patientEmail: patientEmail);
        },
      ),
    ],
  );
}
