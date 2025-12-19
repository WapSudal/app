import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_icon.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../patients/presentation/widgets/patient_manage_bottom_sheet.dart';
import '../../../auth/applications/registered_user_notifier.dart';
import '../../../auth/applications/registered_user_state.dart';
import '../widgets/caregiver_manage_bottom_sheet.dart';

/// 프로필 화면 - 내 정보 및 전체 메뉴
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
      appBar: CustomAppBar(
        mode: AppBarMode.navigation,
        customTitle: Assets.logos.textLogo.svg(height: 14),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    // 계정 정보 카드
                    _buildAccountInfoCard(context, ref),
                    const SizedBox(height: 8),
                    // 전체 메뉴 카드
                    _buildMenuCard(context),
                    const SizedBox(height: 8),
                    // 보호자/주치의 관리 카드
                    _buildManageListCard(context, ref),
                    const SizedBox(height: 12),
                    // 하단 안내 문구
                    _buildFooterText(context),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 계정 정보 카드
  Widget _buildAccountInfoCard(BuildContext context, WidgetRef ref) {
    final state = ref.read(registeredUserProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 54,
            height: 54,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColorScheme.white100,
              shape: BoxShape.circle,
              border: Border.all(color: AppColorScheme.white300, width: 1),
            ),
            child: Assets.icons.defaultProfile.svg(width: 54, height: 54),
          ),
          const SizedBox(width: 12),
          // 이름 & 이메일
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.displayName}님',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColorScheme.black100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.email,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColorScheme.grey300,
                  ),
                ),
              ],
            ),
          ),
          // 정보 수정 버튼
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColorScheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '정보 수정',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColorScheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 전체 메뉴 카드
  Widget _buildMenuCard(BuildContext context) {
    final menuItems = [
      _MenuItem(emoji: '⚙️', title: '계정 관리', route: '/account-management'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '전체 메뉴',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColorScheme.black100,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 메뉴 리스트
          ...menuItems.map((item) => _buildMenuElement(context, item)),
        ],
      ),
    );
  }

  /// 메뉴 요소
  Widget _buildMenuElement(BuildContext context, _MenuItem item) {
    return InkWell(
      onTap: () {
        if (item.route != null) {
          context.push(item.route!);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            // 이모지 아이콘 배경
            Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColorScheme.white200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 8),
            // 메뉴 타이틀
            Text(
              item.title,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColorScheme.black300),
            ),
          ],
        ),
      ),
    );
  }

  /// 보호자/주치의 관리 카드
  Widget _buildManageListCard(BuildContext context, WidgetRef ref) {
    final role = ref.read(registeredUserProvider).role;

    return Container(
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (role == UserRole.generalUser) ...[
            // 보호자 관리
            _buildManageButton(
              context,
              icon: AppIcon(
                Assets.icons.profile,
                color: AppColorScheme.primaryColor,
                size: 18,
              ),
              iconColor: AppColorScheme.primaryColor,
              title: '보호자 관리',
              // trailingText: '요청 1건',
              onTap: () {
                CaregiverManageBottomSheet.show(
                  context: context,
                  connectionType: ConnectionType.guardian,
                );
              },
            ),
            // 구분선
            Container(
              height: 1,
              color: AppColorScheme.black100.withValues(alpha: 0.1),
            ),
            // 주치의 관리
            _buildManageButton(
              context,
              icon: AppIcon(
                Assets.icons.medicalKit,
                color: AppColorScheme.success,
                size: 18,
              ),
              iconColor: AppColorScheme.success,
              title: '주치의 관리',
              // trailingText: '요청 1건',
              onTap: () {
                CaregiverManageBottomSheet.show(
                  context: context,
                  connectionType: ConnectionType.doctor,
                );
              },
            ),
          ],

          if ([UserRole.guardian, UserRole.doctor].contains(role)) ...[
            // 보호 대상자 관리
            _buildManageButton(
              context,
              icon: AppIcon(
                Assets.icons.profile,
                color: AppColorScheme.primaryColor,
                size: 18,
              ),
              iconColor: AppColorScheme.primaryColor,
              title: '환자 연결 관리',
              // trailingText: '승인 대기중 1건',
              onTap: () {
                PatientManageBottomSheet.show(context: context);
              },
            ),
          ],
        ],
      ),
    );
  }

  /// 관리 버튼 (보호자/주치의)
  Widget _buildManageButton(
    BuildContext context, {
    required Widget icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              child: icon,
            ),

            const SizedBox(width: 12),
            // 타이틀
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColorScheme.black100,
                    ),
                  ),
                  // 요청 건수
                  if (trailingText?.isNotEmpty ?? false)
                    Text(
                      trailingText!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColorScheme.danger,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            // 화살표 아이콘
            Assets.icons.right.svg(
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppColorScheme.grey400,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 하단 안내 문구
  Widget _buildFooterText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'Stroke Spoiler는 건강보조 어플리케이션입니다.\n정확한 의료 정보는 주치의와 상담하세요.',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey300),
      ),
    );
  }
}

/// 메뉴 아이템 모델
class _MenuItem {
  final String emoji;
  final String title;
  final String? route;

  const _MenuItem({required this.emoji, required this.title, this.route});
}
