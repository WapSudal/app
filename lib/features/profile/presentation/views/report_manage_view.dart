import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_icon.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

class ReportManageView extends ConsumerWidget {
  const ReportManageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: const CustomAppBar(mode: AppBarMode.subpage, title: '보고서 관리'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: [_buildManageListCard(context, ref)]),
        ),
      ),
    );
  }

  Widget _buildManageListCard(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildManageButton(
            context,
            icon: Assets.icons.input,
            iconColor: AppColorScheme.primaryColor,
            title: '건강 보고서 생성',
            description: '전체 건강 데이터 요약 (TXT)',
            trailingText: '다운로드',
            onTap: () => {},
          ),
          Container(
            height: 1,
            color: AppColorScheme.black100.withValues(alpha: 0.1),
          ),
          _buildManageButton(
            context,
            icon: Assets.icons.heartRate,
            iconColor: AppColorScheme.danger,
            title: '건강 데이터 내보내기',
            description: 'Raw 전체 (CSV)',
            trailingText: '다운로드',
            onTap: () => {},
          ),
          Container(
            height: 1,
            color: AppColorScheme.black100.withValues(alpha: 0.1),
          ),
          _buildManageButton(
            context,
            icon: Assets.icons.data,
            iconColor: AppColorScheme.success,
            title: '예측 결과 내보내기',
            description: '위험도 예측 이력 (CSV)',
            trailingText: '다운로드',
            onTap: () => {},
          ),
          Container(
            height: 1,
            color: AppColorScheme.black100.withValues(alpha: 0.1),
          ),
          _buildManageButton(
            context,
            icon: Assets.icons.data,
            iconColor: AppColorScheme.black100.withValues(alpha: 0.1),
            title: '전체 데이터 백업',
            description: '데이터 복원용 (JSON)',
            trailingText: '지원 예정',
            onTap: () => {},
          ),
        ],
      ),
    );
  }

  /// 관리 버튼 위젯
  Widget _buildManageButton(
    BuildContext context, {
    required SvgGenImage icon,
    required Color iconColor,
    required String title,
    required String description,
    required String trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // 아이콘 배경
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppIcon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 12),
            // 타이틀
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColorScheme.black100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
