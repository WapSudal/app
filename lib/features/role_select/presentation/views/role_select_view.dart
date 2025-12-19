import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/presentation/helpers/snackbar_helper.dart';
import '../../../../core/presentation/widgets/app_loading_overlay.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../auth/applications/auth_mutations.dart';
import '../../../auth/applications/auth_notifier.dart';
import '../../../auth/applications/auth_state.dart';
import '../../../auth/applications/registered_user_notifier.dart';
import '../providers/role_select_mutations.dart';
import '../providers/role_select_notifier.dart';
import '../widgets/account_info_card.dart';
import '../widgets/role_select_button.dart';

/// 역할 선택 화면
///
/// 유저 첫 로그인 시 표시되는 역할 선택 페이지
/// - 일반 사용자
/// - 가족 및 보호자
/// - 주치의
class RoleSelectView extends ConsumerStatefulWidget {
  const RoleSelectView({super.key});

  @override
  ConsumerState<RoleSelectView> createState() => _RoleSelectViewState();
}

class _RoleSelectViewState extends ConsumerState<RoleSelectView> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final switchAccountState = ref.watch(switchAccountMutation);
    final confirmRoleState = ref.watch(confirmRoleMutation);

    // 계정 전환 Mutation 상태 처리
    ref.listen(switchAccountMutation, (previous, next) {
      if (next is MutationPending) {
        LoadingOverlay.show(context, message: '계정 전환 중');
      } else {
        LoadingOverlay.hide();
      }

      if (next case MutationError(:final error)) {
        showErrorSnackBar(context, error);
      }
    });

    // 역할 확정 Mutation 상태 처리
    ref.listen(confirmRoleMutation, (previous, next) {
      if (next is MutationPending) {
        LoadingOverlay.show(context, message: '요청 처리중');
      } else {
        LoadingOverlay.hide();
      }

      switch (next) {
        case MutationSuccess():
          if (context.mounted) {
            context.go('/home');
          }
        case MutationError(:final error):
          showErrorSnackBar(context, error);
        default:
          break;
      }
    });

    final isLoading =
        switchAccountState is MutationPending ||
        confirmRoleState is MutationPending;

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
                    _buildAccountInfo(authState, isLoading),
                    const SizedBox(height: 52),
                    // 역할 선택 섹션
                    _buildRoleSelectSection(isLoading),
                  ],
                ),
              ),
            ),
            // 하단 안내 문구
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// 계정 정보 카드
  Widget _buildAccountInfo(AuthState authState, bool isLoading) {
    return AccountInfoCard(
      name: authState.isAuthenticated ? '${authState.displayName}님' : '사용자님',
      email: authState.email,
      photoUrl: authState.photoUrl,
      isLoading: false,
      onSwitchAccount: isLoading
          ? null
          : () => _onSwitchAccountPressed(context, ref),
    );
  }

  /// 계정 전환 버튼 클릭 처리
  void _onSwitchAccountPressed(BuildContext context, WidgetRef ref) {
    switchAccountMutation.run(ref, (tsx) async {
      final repository = tsx.get(authRepositoryProvider);
      final user = await repository.switchAccount();

      // 상태 업데이트
      tsx.get(authProvider.notifier).updateUser(user);

      return user;
    });
  }

  /// 역할 선택 섹션
  Widget _buildRoleSelectSection(bool isLoading) {
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
        _buildRoleButtons(isLoading),
      ],
    );
  }

  /// 역할 선택 버튼 목록
  Widget _buildRoleButtons(bool isLoading) {
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
          onTap: isLoading ? null : () => _onRoleSelected(UserRole.generalUser),
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
          onTap: isLoading ? null : () => _onRoleSelected(UserRole.guardian),
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
          onTap: isLoading ? null : () => _onRoleSelected(UserRole.doctor),
        ),
      ],
    );
  }

  /// 역할 선택 시 처리
  void _onRoleSelected(UserRole role) {
    ref.read(roleSelectProvider.notifier).selectRole(role);

    // 역할 선택 확정 Mutation 실행
    confirmRoleMutation.run(ref, (tsx) async {
      // Firebase Auth에서 현재 로그인된 사용자 정보 가져오기
      final authState = tsx.get(authProvider);
      final authUser = authState.user;

      if (authUser == null) {
        throw Exception('로그인이 필요합니다.');
      }

      final repository = tsx.get(userRepositoryProvider);
      final user = await repository.registerUser(
        uid: authUser.uid,
        email: authUser.email ?? '',
        displayName: authUser.displayName,
        photoUrl: authUser.photoUrl,
        role: role,
      );

      // RegisteredUser 상태 업데이트
      tsx.get(registeredUserProvider.notifier).updateUser(user);

      return user;
    });
  }

  /// 하단 안내 문구
  Widget _buildFooter() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        'Stroke Spoiler는 건강보조 어플리케이션입니다.\n정확한 의료 정보는 주치의와 상담하세요.',
        style: textTheme.labelSmall?.copyWith(color: AppColorScheme.grey300),
        textAlign: TextAlign.center,
      ),
    );
  }
}
