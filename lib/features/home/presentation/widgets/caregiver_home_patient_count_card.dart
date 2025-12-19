import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';

/// 관리 중인 환자 수 / 고위험 환자 수 카드
///
/// Figma: Home/Count
/// Guardian/Doctor 홈 화면 상단에 가로로 2개 배치되는 통계 카드
class CaregiverHomePatientCountCard extends StatelessWidget {
  const CaregiverHomePatientCountCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.content,
    this.countColor,
    this.backgroundColor,
  });

  /// 카드 제목 (예: "관리 중인 환자 수", "고위험 환자")
  final String title;

  /// 카드 이모지 (예: "🩺", "⚠️")
  final String emoji;

  final String content;

  /// 숫자 색상 (null이면 기본 색상)
  final Color? countColor;

  /// 배경 색상 (null이면 흰색)
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24, fontFamily: 'TossFace'),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColorScheme.grey300),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColorScheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// 환자 수 카드 행 (2개의 카드를 가로로 배치)
class CaregiverHomePatientCountRow extends StatelessWidget {
  const CaregiverHomePatientCountRow({
    super.key,
    required this.totalPatientCount,
    required this.highRiskPatientCount,
  });

  final int totalPatientCount;
  final int highRiskPatientCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 관리 중인 환자 수
        Expanded(
          child: CaregiverHomePatientCountCard(
            title: '관리 중인 환자 수',
            emoji: '👤',
            content: '$totalPatientCount명',
          ),
        ),
        const SizedBox(width: 8),
        // 고위험 환자
        Expanded(
          child: CaregiverHomePatientCountCard(
            title: '고위험 환자',
            emoji: '⚠️',
            content: '$highRiskPatientCount명',
          ),
        ),
      ],
    );
  }
}
