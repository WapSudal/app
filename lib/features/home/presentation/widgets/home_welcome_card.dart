import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

/// 시간대별 환영 메시지 카드
///
/// Figma: Home/WelcomeByTime
class HomeWelcomeCard extends StatelessWidget {
  const HomeWelcomeCard({super.key, this.displayName});

  final String? displayName;

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColorScheme.white100,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Assets.icons.defaultProfile.svg(width: 50, height: 50),
            ),
          ),
          const SizedBox(width: 12),
          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  greeting.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColorScheme.black100,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  greeting.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColorScheme.grey200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 시간대별 인사말 결정
  _GreetingData _getGreeting() {
    final hour = DateTime.now().hour;
    final name = displayName ?? '사용자';

    if (hour >= 5 && hour < 11) {
      return _GreetingData(
        title: '$name님, 좋은 아침이에요',
        subtitle: '오늘 하루도 건강하게 시작해볼까요?',
      );
    } else if (hour >= 11 && hour < 17) {
      return _GreetingData(title: '$name님, 좋은 오후에요', subtitle: '식사는 하셨나요?');
    } else if (hour >= 17 && hour < 24) {
      return _GreetingData(
        title: '$name님, 좋은 저녁이에요',
        subtitle: '오늘 하루는 어떠셨나요?',
      );
    } else {
      return _GreetingData(
        title: '시간이 늦었어요',
        subtitle: '일찍 잠드는 습관은 다음 날을 개운하게 도와줘요',
      );
    }
  }
}

class _GreetingData {
  const _GreetingData({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
