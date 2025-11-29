import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';

/// 온보딩 콘텐츠 위젯
///
/// 제목, 부제목, 목업 이미지를 표시하는 온보딩 페이지의 콘텐츠 영역
class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  /// 메인 제목
  final String title;

  /// 부제목 (여러 줄 가능)
  final String subtitle;

  /// 목업 이미지 경로
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 80),
        // 텍스트 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              // 제목 (H3 스타일)
              Text(
                title,
                style: textTheme.displaySmall?.copyWith(
                  color: AppColorScheme.black100,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // 부제목 (B1 스타일)
              Text(
                subtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColorScheme.black400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 목업 이미지 영역
        Expanded(
          child: Stack(
            children: [
              // 목업 이미지
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 58),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              // 하단 그라디언트 오버레이
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.6],
                      colors: [
                        AppColorScheme.white100.withValues(alpha: 0.0),
                        AppColorScheme.white100,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
