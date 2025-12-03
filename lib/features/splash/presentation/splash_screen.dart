import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/color_scheme.dart';
import '../../../gen/assets.gen.dart';
import '../../auth/data/providers/auth_data_providers.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 페이드인 애니메이션 설정
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();

    // 초기화 및 네비게이션
    _initialize();
  }

  Future<void> _initialize() async {
    // 병렬 초기화 작업
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)), // 최소 표시 시간
      _performInitialization(),
    ]);

    if (mounted) {
      // 인증 상태에 따라 분기
      final isAuthenticated = ref.read(isAuthenticatedProvider);

      if (isAuthenticated) {
        context.go('/role-select');
      } else {
        context.go('/onboarding');
      }
    }
  }

  Future<void> _performInitialization() async {
    // 현재 로그인 상태 확인
    try {
      final repository = ref.read(authRepositoryProvider);
      final currentUser = await repository.getCurrentUser();

      if (currentUser != null) {
        // 이미 로그인된 사용자가 있으면 AuthProvider 상태 업데이트
        ref.read(authProvider.notifier);
      }
    } catch (e) {
      // 초기화 실패 시 무시 (온보딩으로 이동)
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorScheme.white100,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(child: Assets.logos.logoWithText.svg(width: 153)),
        ),
      ),
    );
  }
}
