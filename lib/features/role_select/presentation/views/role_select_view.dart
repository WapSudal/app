import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/user_role.dart';
import '../providers/role_select_provider.dart';
import '../widgets/account_info_card.dart';
import '../widgets/role_select_button.dart';

/// 역할 선택 화면
///
/// 유저 첫 로그인 시 표시되는 역할 선택 페이지
/// - 일반 사용자
/// - 가족 및 보호자
/// - 주치의
class RoleSelectView extends ConsumerWidget {
  const RoleSelectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roleSelectProvider);
    final notifier = ref.read(roleSelectProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColorScheme.white100,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // 로고
                    Assets.logos.logoWithText.svg(width: 153),
                    const SizedBox(height: 40),
                    // 계정 정보 카드
                    _buildAccountInfo(),
                    const SizedBox(height: 52),
                    // 역할 선택 섹션
                    _buildRoleSelectSection(
                      context,
                      state.selectedRole,
                      notifier,
                    ),
                  ],
                ),
              ),
            ),
            // 하단 안내 문구
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// 계정 정보 카드
  Widget _buildAccountInfo() {
    // TODO: 로그인 연동 후 실제 사용자 정보로 대체
    return const AccountInfoCard(
      name: '홍길동님',
      email: 'example@gmail.com',
      // 계정 전환 기능은 로그인 연동 후 구현
      onSwitchAccount: null,
    );
  }

  /// 역할 선택 섹션
  Widget _buildRoleSelectSection(
    BuildContext context,
    UserRole? selectedRole,
    RoleSelectNotifier notifier,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // 헤더
        Text(
          '어떤 사용자로 이용하시나요?',
          style: textTheme.headlineSmall?.copyWith(
            color: AppColorScheme.black100,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // 역할 선택 버튼들
        _buildRoleButtons(context, selectedRole, notifier),
      ],
    );
  }

  /// 역할 선택 버튼 목록
  Widget _buildRoleButtons(
    BuildContext context,
    UserRole? selectedRole,
    RoleSelectNotifier notifier,
  ) {
    return Column(
      children: [
        // 일반 사용자
        RoleSelectButton(
          icon: Assets.roleIcons.patient.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              const Color(0xFF80bbff),
              BlendMode.srcIn,
            ),
          ),
          title: UserRole.generalUser.displayName,
          description: UserRole.generalUser.description,
          showTopBorder: false,
          onTap: () => _onRoleSelected(context, notifier, UserRole.generalUser),
        ),
        // 가족 및 보호자
        RoleSelectButton(
          icon: Assets.roleIcons.guardian.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              const Color(0xFFFF4E92),
              BlendMode.srcIn,
            ),
          ),
          title: UserRole.guardian.displayName,
          description: UserRole.guardian.description,
          showTopBorder: true,
          onTap: () => _onRoleSelected(context, notifier, UserRole.guardian),
        ),
        // 주치의
        RoleSelectButton(
          icon: Assets.roleIcons.physician.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(Color(0xFF17DB24), BlendMode.srcIn),
          ),
          title: UserRole.doctor.displayName,
          description: UserRole.doctor.description,
          showTopBorder: true,
          onTap: () => _onRoleSelected(context, notifier, UserRole.doctor),
        ),
      ],
    );
  }

  /// 역할 선택 시 처리
  void _onRoleSelected(
    BuildContext context,
    RoleSelectNotifier notifier,
    UserRole role,
  ) async {
    notifier.selectRole(role);

    // 역할 선택 확정 및 다음 화면으로 이동
    final success = await notifier.confirmRole();
    if (success && context.mounted) {
      // TODO: 역할에 따른 적절한 화면으로 이동
      context.go('/home');
    }
  }

  /// 하단 안내 문구
  Widget _buildFooter(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 58),
      child: Text(
        'Stroke Spoiler는 건강보조 어플리케이션입니다.\n정확한 의료 정보는 주치의와 상담하세요.',
        style: textTheme.labelSmall?.copyWith(color: AppColorScheme.grey300),
        textAlign: TextAlign.center,
      ),
    );
  }
}
