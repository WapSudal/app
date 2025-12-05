import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/presentation/helpers/snackbar_helper.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../auth/presentation/providers/auth_mutations.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../user/presentation/providers/registered_user_notifier.dart';
import '../providers/home_notifier.dart';
import '../providers/home_state.dart';
import 'widgets/doctor_home_content.dart';
import 'widgets/general_user_home_content.dart';
import 'widgets/guardian_home_content.dart';

/// 홈 화면
///
/// Scenario B 패턴: 역할에 따라 다른 컨텐츠 위젯 표시
/// 권한 플래그(canManagePatients, canAccessGuardianFeatures 등)로 UI 분기
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final registeredUserState = ref.watch(registeredUserProvider);
    final user = registeredUserState.user;
    final signOutState = ref.watch(signOutMutation);

    // 로그아웃 Mutation 상태 처리
    ref.listen(signOutMutation, (previous, next) {
      switch (next) {
        case MutationSuccess():
          if (context.mounted) {
            context.go('/onboarding');
          }
        case MutationError(:final error):
          showErrorSnackBar(context, error);
        default:
          break;
      }
    });

    final isLoading = signOutState is MutationPending;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Assets.logos.textLogo.svg(height: 14),
        actions: [
          // 알림 버튼
          IconButton(
            icon: Assets.icons.alarm.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColorScheme.black100,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              // TODO: 알림 페이지로 이동
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(homeState, user?.displayName),
      ),
    );
  }

  Widget _buildContent(HomeState homeState, String? displayName) {
    // Scenario B: 권한 플래그에 따라 컨텐츠 위젯 분기
    switch (homeState.role) {
      case UserRole.generalUser:
        return GeneralUserHomeContent(
          displayName: displayName,
          canManageOwnHealth: homeState.canManageOwnHealth,
        );
      case UserRole.guardian:
        return GuardianHomeContent(
          displayName: displayName,
          canAccessGuardianFeatures: homeState.canAccessGuardianFeatures,
        );
      case UserRole.doctor:
        return DoctorHomeContent(
          displayName: displayName,
          canManagePatients: homeState.canManagePatients,
        );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleSignOut();
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  void _handleSignOut() {
    signOutMutation.run(ref, (tsx) async {
      // 사용자 데이터 초기화
      await tsx.get(registeredUserProvider.notifier).clear();

      // Firebase 로그아웃
      final repository = tsx.get(authRepositoryProvider);
      await repository.signOut();

      // Auth 상태 초기화
      tsx.get(authProvider.notifier).clearUser();
    });
  }
}
