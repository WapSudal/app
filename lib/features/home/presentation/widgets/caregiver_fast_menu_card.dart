import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

/// 보호자/주치의 전용 빠른 메뉴 카드
///
/// Figma: Home/FastMenu (Caregiver Version)
/// Guardian/Doctor 홈 화면 하단의 빠른 액션 메뉴
/// TODO: Fast Menu Card home_fast_menu_card.dart 와 해당 파일 통합 필요
class CaregiverFastMenuCard extends StatelessWidget {
  const CaregiverFastMenuCard({
    super.key,
    this.onNewPatientConnection,
    this.onPatientList,
    this.onContentExplore,
  });

  /// 새로운 환자 연결 콜백
  final VoidCallback? onNewPatientConnection;

  /// 환자 목록 콜백
  final VoidCallback? onPatientList;

  /// 추천 콘텐츠 탐색 콜백
  final VoidCallback? onContentExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 새로운 환자 연결
          _CaregiverFastMenuItem(
            icon: Assets.icons.plus,
            iconBackgroundColor: AppColorScheme.primaryColor,
            title: '새로운 환자 연결',
            onTap: onNewPatientConnection,
          ),
          const _MenuDivider(),
          // 환자 목록
          _CaregiverFastMenuItem(
            icon: Assets.icons.person,
            iconBackgroundColor: AppColorScheme.danger,
            title: '환자 목록',
            onTap: onPatientList,
          ),
          const _MenuDivider(),
          // 추천 콘텐츠 탐색
          _CaregiverFastMenuItem(
            icon: Assets.icons.compass,
            iconBackgroundColor: AppColorScheme.black100,
            title: '추천 콘텐츠 탐색',
            onTap: onContentExplore,
          ),
        ],
      ),
    );
  }
}

/// 보호자/주치의 빠른 메뉴 아이템
class _CaregiverFastMenuItem extends StatelessWidget {
  const _CaregiverFastMenuItem({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    this.onTap,
  });

  final SvgGenImage icon;
  final Color iconBackgroundColor;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 아이콘 프레임
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  AppColorScheme.white100.withValues(alpha: 0.9),
                  iconBackgroundColor,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon.svg(
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  iconBackgroundColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 타이틀
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColorScheme.black100),
              ),
            ),
            // 화살표
            Assets.icons.right.svg(
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                AppColorScheme.grey400,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 메뉴 구분선
class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColorScheme.black100.withValues(alpha: 0.1),
    );
  }
}
