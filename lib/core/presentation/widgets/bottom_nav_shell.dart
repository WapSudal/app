import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'custom_bottom_nav_bar.dart';

/// Shell widget that wraps tab content with bottom navigation
///
/// Used by StatefulShellRoute to provide persistent bottom nav
class BottomNavShell extends StatelessWidget {
  const BottomNavShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabChanged: _onTabChanged,
      ),
    );
  }

  void _onTabChanged(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
