import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/presentation/helpers/snackbar_helper.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../core/providers/auth_mutations.dart';
import '../../../../core/providers/registered_user_notifier.dart';
import '../providers/home_notifier.dart';
import '../providers/home_state.dart';
import '../widgets/caregiver_home_content.dart';
import '../widgets/general_user_home_content.dart';

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
      appBar: CustomAppBar(
        mode: AppBarMode.navigation,
        customTitle: Assets.logos.textLogo.svg(height: 14),
      ),
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [AppLoadingIndicator(), Text('불러오는 중')],
                ),
              )
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
      case UserRole.doctor:
        // Guardian과 Doctor는 동일한 CaregiverHomeContent 사용
        return CaregiverHomeContent(displayName: displayName);
      default:
        throw UnimplementedError('지원되지 않는 사용자 역할입니다.');
    }
  }
}
