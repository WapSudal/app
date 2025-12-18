import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/theme/color_scheme.dart';

/// 홈 화면 스플래시 카드 (첫 방문 시 표시)
///
/// Figma: Home/Splash
class HomeSplashCard extends StatelessWidget {
  const HomeSplashCard({
    super.key,
    required this.title,
    required this.description,
    required this.emoji,
    required this.buttonText,
    required this.onButtonPressed,
  });

  final String title;
  final String description;
  final String emoji;
  final String buttonText;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 텍스트 영역
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColorScheme.black100,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColorScheme.grey200),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 아이콘 영역
          Center(
            child: SizedBox(
              width: 72,
              height: 72,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 56),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 버튼 영역
          SizedBox(
            width: double.infinity,
            child: AppFlatButton(
              text: buttonText,
              onPressed: onButtonPressed,
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
