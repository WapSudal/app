import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../gen/assets.gen.dart';
import '../../../auth/applications/registered_user_notifier.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
      appBar: CustomAppBar(
        mode: AppBarMode.navigation,
        customTitle: Assets.logos.textLogo.svg(height: 14),
      ),
      body: SafeArea(bottom: false, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    final registeredUserState = ref.watch(registeredUserProvider);
    final user = registeredUserState.user;
    final role = user?.role;

    // Scenario B: 권한 플래그에 따라 컨텐츠 위젯 분기
    switch (role) {
      case UserRole.generalUser:
        return GeneralUserHomeContent(displayName: user?.displayName);
      case UserRole.guardian:
      case UserRole.doctor:
        // Guardian과 Doctor는 동일한 CaregiverHomeContent 사용
        return CaregiverHomeContent(displayName: user?.displayName);
      default:
        throw UnimplementedError('지원되지 않는 사용자 역할입니다.');
    }
  }
}
