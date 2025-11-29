import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/color_scheme.dart';
import '../../../gen/assets.gen.dart';

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
      // TODO: 로그인 상태에 따라 /home 또는 /onboarding으로 분기
      context.go('/onboarding');
    }
  }

  Future<void> _performInitialization() async {
    // TODO: 실제 초기화 로직 구현
    // - SharedPreferences 로드
    // - 로그인 상태 체크
    // - API 버전 확인
    // - 필요한 데이터 프리로드
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
