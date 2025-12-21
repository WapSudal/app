import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/storage/first_launch_provider.dart';
import '../../../core/theme/color_scheme.dart';
import '../../../gen/assets.gen.dart';
import '../../auth/data/providers/auth_data_providers.dart';
import '../../auth/applications/auth_notifier.dart';
import '../../auth/applications/registered_user_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isUserRegistered = false;

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
      // 첫 실행 여부 확인
      final firstLaunchState = ref.read(firstLaunchProvider);
      final isFirstLaunch = firstLaunchState.value ?? true;

      // 첫 실행이면 온보딩으로
      if (isFirstLaunch) {
        context.go('/onboarding');
        return;
      }

      // 이후 실행: 인증 상태에 따라 분기
      final isAuthenticated = ref.read(isAuthenticatedProvider);

      if (isAuthenticated) {
        // 이미 가입 완료된 사용자면 홈으로, 아니면 역할 선택으로
        if (_isUserRegistered) {
          context.go('/home');
        } else {
          context.go('/role-select');
        }
      } else {
        // 인증되지 않은 경우 역할 선택으로 (온보딩 스킵)
        context.go('/role-select');
      }
    }
  }

  Future<void> _performInitialization() async {
    // 현재 로그인 상태 확인
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final currentUser = await authRepository.getCurrentUser();

      debugPrint('[SplashScreen] currentUser: ${currentUser?.email}');

      if (currentUser != null) {
        // 이미 로그인된 사용자가 있으면 AuthProvider 상태 업데이트
        ref.read(authProvider.notifier);

        // 사용자 가입 완료 여부 확인
        // Note: isRegistered()는 내부적으로 FirebaseAuth.instance.currentUser?.email을 사용하므로
        // 위에서 currentUser를 확인한 후 호출해야 정확한 결과를 얻음
        try {
          final userRepository = ref.read(userRepositoryProvider);
          _isUserRegistered = await userRepository.isRegistered();
          debugPrint('[SplashScreen] isRegistered: $_isUserRegistered');

          // RegisteredUserProvider의 초기화가 완료될 때까지 대기
          // 라우터의 redirect가 이 provider를 watch하므로, 초기화 완료 전에
          // 네비게이션하면 redirect에서 role-select로 리다이렉트됨
          if (_isUserRegistered) {
            await _waitForRegisteredUserInitialization();
          }
        } catch (e) {
          debugPrint('[SplashScreen] isRegistered error: $e');
          _isUserRegistered = false;
        }
      }
    } catch (e) {
      debugPrint('[SplashScreen] initialization error: $e');
      // 초기화 실패 시 무시 (온보딩으로 이동)
    }
  }

  /// RegisteredUserProvider 초기화 완료 대기
  Future<void> _waitForRegisteredUserInitialization() async {
    // registeredUserProvider의 refresh를 명시적으로 호출하여 초기화
    await ref.read(registeredUserProvider.notifier).refresh();
    debugPrint('[SplashScreen] RegisteredUserProvider refreshed');
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
