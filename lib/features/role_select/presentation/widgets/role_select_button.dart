import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';

/// 역할 선택 버튼 위젯
///
/// Figma 디자인에 맞춰 아이콘, 제목, 설명을 표시하는 리스트 타일 형태의 버튼
class RoleSelectButton extends StatelessWidget {
  const RoleSelectButton({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.showTopBorder = false,
  });

  /// 왼쪽에 표시할 아이콘 위젯
  final Widget icon;

  /// 역할 제목 (예: "일반 사용자")
  final String title;

  /// 역할 설명 (예: "스스로 정보를 관리할게요")
  final String description;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 상단 구분선 표시 여부 (첫 번째 항목은 false)
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: showTopBorder
              ? const Border(
                  top: BorderSide(color: AppColorScheme.white500, width: 1),
                )
              : null,
        ),
        child: Row(
          children: [
            // 아이콘
            SizedBox(width: 24, height: 24, child: icon),
            const SizedBox(width: 12),
            // 텍스트 영역
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColorScheme.black100,
                    ),
                  ),
                  // 설명
                  Text(
                    description,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColorScheme.grey300,
                    ),
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
