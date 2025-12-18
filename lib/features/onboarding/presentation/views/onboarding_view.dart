import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/helpers/snackbar_helper.dart';
import '../../../../core/presentation/widgets/app_icon.dart';
import '../../../../core/presentation/widgets/app_loading_overlay.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../auth/applications/auth_mutations.dart';
import '../../../auth/applications/auth_notifier.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/page_indicator.dart';

/// 온보딩 페이지 데이터 모델
class OnboardingPageData {
  final String title;
  final String subtitle;
  final String imagePath;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

/// 온보딩 화면
///
/// 앱 초기 실행 시 표시되는 온보딩 페이지 (4개 페이지)
class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 온보딩 페이지 콘텐츠 데이터
  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: '개인 맞춤형 건강 데이터 관리',
      subtitle: '데이터 기반으로 나의 건강 흐름을 한눈에 확인',
      imagePath: 'assets/images/mock-1.png',
    ),
    OnboardingPageData(
      title: 'AI 분석으로 위험도 예측',
      subtitle: 'AI 모델이 나의 데이터를 분석해\n현재 뇌졸중 위험도를 계산',
      imagePath: 'assets/images/mock-2.png',
    ),
    OnboardingPageData(
      title: 'What-if 시뮬레이션 예측',
      subtitle: '건강 수치 변경 시 위험도 변화를\n미리 예측하여 안내',
      imagePath: 'assets/images/mock-3.png',
    ),
    OnboardingPageData(
      title: '나에게 딱 맞는 콘텐츠',
      subtitle: '담당자가 추천해주는 건강 콘텐츠를 손쉽게 시청',
      imagePath: 'assets/images/mock-4.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onGoogleLoginPressed() {
    signInWithGoogleMutation.run(ref, (tsx) async {
      final repository = tsx.get(authRepositoryProvider);
      final user = await repository.signInWithGoogle();

      // 상태 업데이트
      tsx.get(authProvider.notifier).updateUser(user);

      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _pages.length - 1;
    final signInState = ref.watch(signInWithGoogleMutation);

    // Mutation 상태 변화 감지 및 처리
    ref.listen(signInWithGoogleMutation, (previous, next) {
      if (next is MutationPending) {
        LoadingOverlay.show(context, message: 'Google 로그인 중');
      } else {
        LoadingOverlay.hide();
      }

      switch (next) {
        case MutationSuccess():
          if (mounted) {
            context.go('/role-select');
          }
        case MutationError(:final error):
          if (mounted) {
            showErrorSnackBar(context, error);
          }
        default:
          break;
      }
    });

    return Scaffold(
      backgroundColor: AppColorScheme.white100,
      body: SafeArea(
        child: Column(
          children: [
            // 온보딩 콘텐츠 (PageView)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingContent(
                    title: page.title,
                    subtitle: page.subtitle,
                    imagePath: page.imagePath,
                  );
                },
              ),
            ),
            // 페이지 인디케이터
            PageIndicator(currentPage: _currentPage),
            const SizedBox(height: 27),
            // 버튼 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  // 다음 또는 Google 로그인 버튼
                  if (isLastPage)
                    _GoogleLoginButton(
                      onPressed: _onGoogleLoginPressed,
                      isLoading: signInState is MutationPending,
                    )
                  else
                    _NextButton(onPressed: _onNextPressed),
                  const SizedBox(height: 16),
                  // 안내 문구
                  Text(
                    'Stroke Spoiler는 건강보조 어플리케이션입니다.\n정확한 의료 정보는 주치의와 상담하세요.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColorScheme.grey300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 다음 버튼 (검정 배경)
class _NextButton extends StatefulWidget {
  const _NextButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: AppColorScheme.black100,
            borderRadius: BorderRadius.circular(9999),
          ),
          alignment: Alignment.center,
          child: Text(
            '다음',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColorScheme.white100),
          ),
        ),
      ),
    );
  }
}

/// Google 로그인 버튼 (파란 배경)
class _GoogleLoginButton extends StatefulWidget {
  const _GoogleLoginButton({required this.onPressed, this.isLoading = false});

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  State<_GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<_GoogleLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : _onTapDown,
      onTapUp: widget.isLoading ? null : _onTapUp,
      onTapCancel: widget.isLoading ? null : _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: widget.isLoading
                ? AppColorScheme.primaryColor.withValues(alpha: 0.7)
                : AppColorScheme.primaryColor,
            borderRadius: BorderRadius.circular(9999),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(
                Assets.icons.google,
                size: 22,
                color: AppColorScheme.white100,
              ),
              const SizedBox(width: 4),
              Text(
                'Google로 시작하기',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColorScheme.white100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
