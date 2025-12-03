import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/role_select/presentation/views/role_select_view.dart';
import '../../features/splash/presentation/splash_screen.dart';

part 'router_provider.g.dart';

/// 인증이 필요하지 않은 경로 목록
const _publicRoutes = ['/', '/onboarding'];

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // 인증 상태 구독
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      // Splash 화면에서는 리다이렉트 제외 (자체 로직 처리)
      if (currentPath == '/') {
        return null;
      }

      // 인증되지 않은 상태에서 protected route 접근 시 온보딩으로
      final isPublicRoute = _publicRoutes.contains(currentPath);
      if (!isAuthenticated && !isPublicRoute) {
        return '/onboarding';
      }

      // 인증된 상태에서 온보딩 접근 시 역할 선택으로
      if (isAuthenticated && currentPath == '/onboarding') {
        return '/role-select';
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
        builder: (context, state) => Container(),
      ),
    ],
  );
}
