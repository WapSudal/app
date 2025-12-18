import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../enums/nav_tab.dart';
import '../../enums/user_role.dart';
import '../../theme/color_scheme.dart';
import 'app_bottom_nav_bar.dart';

/// Shell widget that wraps tab content with bottom navigation
///
/// Used by StatefulShellRoute to provide persistent bottom nav
class BottomNavShell extends StatelessWidget {
  const BottomNavShell({
    super.key,
    required this.navigationShell,
    required this.userRole,
  });

  final StatefulNavigationShell navigationShell;
  final UserRole userRole;

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabsForRole(userRole);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColorScheme.white100, // White background
        systemNavigationBarIconBrightness: Brightness.dark, // Dark icons
      ),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: Material(
          color: Colors.transparent,
          child: AppBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTabChanged: _onTabChanged,
            tabs: tabs,
          ),
        ),
      ),
    );
  }

  void _onTabChanged(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  /// 역할에 따른 탭 리스트 반환
  List<BaseNavTab> _getTabsForRole(UserRole role) {
    switch (role) {
      case UserRole.generalUser:
        return PatientNavTab.values;
      case UserRole.guardian:
        return GuardianNavTab.values;
      case UserRole.doctor:
        return DoctorNavTab.values;
      case UserRole.admin:
        // Admin은 현재 1개 탭만 있으므로 Patient 탭 사용 (임시)
        return PatientNavTab.values;
    }
  }
}
