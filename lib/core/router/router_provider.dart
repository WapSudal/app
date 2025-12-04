import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/role_select/presentation/views/role_select_view.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/user/presentation/providers/registered_user_notifier.dart';

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
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
