import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/role_select/presentation/views/role_select_view.dart';
import '../../features/splash/presentation/splash_screen.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
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
