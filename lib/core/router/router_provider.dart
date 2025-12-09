import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/all/presentation/views/all_view.dart';
import '../../features/analysis/presentation/views/analysis_view.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/explore/presentation/views/explore_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/record/presentation/views/record_view.dart';
import '../../features/health_record/presentation/views/health_record_input_view.dart';
import '../../features/role_select/presentation/views/role_select_view.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/user/presentation/providers/registered_user_notifier.dart';
import '../enums/user_role.dart';
import '../presentation/widgets/bottom_nav_shell.dart';

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

      // Conditional routing based on user role
      if (userRole == UserRole.generalUser)
        // General users get bottom navigation with 5 tabs
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BottomNavShell(navigationShell: navigationShell);
          },
          branches: [
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
                  builder: (context, state) => const RecordView(),
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
            // Tab 5: 전체
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/all',
                  name: 'all',
                  builder: (context, state) => const AllView(),
                ),
              ],
            ),
          ],
        )
      else
        // Doctor and Guardian get simple route without bottom nav
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),

      // Full-screen routes without bottom navigation
      GoRoute(
        path: '/record/input',
        name: 'recordInput',
        builder: (context, state) => const HealthRecordInputView(),
      ),
    ],
  );
}
