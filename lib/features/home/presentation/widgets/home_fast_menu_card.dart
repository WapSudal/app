import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

/// 빠른 메뉴 카드
///
/// Figma: Home/FastMenu
class HomeFastMenuCard extends StatelessWidget {
  const HomeFastMenuCard({
    super.key,
    this.onNewDataInput,
    this.onRiskPrediction,
    this.onFutureSimulation,
    this.onContentExplore,
  });

  final VoidCallback? onNewDataInput;
  final VoidCallback? onRiskPrediction;
  final VoidCallback? onFutureSimulation;
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
          // 새 데이터 입력
          _FastMenuItem(
            icon: Assets.icons.plus,
            iconBackgroundColor: AppColorScheme.primaryColor,
            title: '새 데이터 입력',
            onTap: onNewDataInput,
          ),
          const _MenuDivider(),
          // 위험도 예측
          _FastMenuItem(
            icon: Assets.icons.heartRate,
            iconBackgroundColor: AppColorScheme.danger,
            title: '위험도 예측',
            onTap: onRiskPrediction,
          ),
          const _MenuDivider(),
          // 미래 예측 시뮬레이션
          _FastMenuItem(
            icon: Assets.icons.data,
            iconBackgroundColor: AppColorScheme.success,
            title: '미래 예측 시뮬레이션',
            onTap: onFutureSimulation,
          ),
          const _MenuDivider(),
          // 추천 콘텐츠 탐색
          _FastMenuItem(
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

/// 빠른 메뉴 아이템
class _FastMenuItem extends StatelessWidget {
  const _FastMenuItem({
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
