import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

/// 빈 상태 카드
///
/// 목록이 비어있을 때 표시하는 카드입니다.
/// 점선 테두리와 아이콘, 메인/서브 텍스트를 포함합니다.
class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.mainText,
    this.subText,
    this.icon,
  });

  /// 메인 텍스트 (예: "아직 보호자가 없네요")
  final String mainText;

  /// 서브 텍스트 (예: "보호자에게 연결 요청을 해주세요")
  final String? subText;

  /// 커스텀 아이콘 위젯 (null이면 기본 아이콘 사용)
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColorScheme.white500,
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          icon ??
              SizedBox(
                width: 72,
                height: 72,
                child: Assets.icons.box.svg(
                  width: 72,
                  height: 72,
                  colorFilter: const ColorFilter.mode(
                    AppColorScheme.grey400,
                    BlendMode.srcIn,
                  ),
                ),
              ),
          const SizedBox(height: 8),
          // 메인 텍스트
          Text(
            mainText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColorScheme.grey300,
              fontWeight: FontWeight.w500,
            ),
          ),
          // 서브 텍스트
          if (subText != null)
            Text(
              subText!,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey500),
            ),
        ],
      ),
    );
  }
}
