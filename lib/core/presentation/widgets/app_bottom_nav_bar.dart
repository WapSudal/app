import 'package:flutter/material.dart';

import '../../enums/nav_tab.dart';
import '../../theme/color_scheme.dart';
import 'bottom_nav_item.dart';

/// Custom bottom navigation bar
///
/// Figma specs:
/// - Total height: 90px (56px content + 34px bottom padding)
/// - Background: #FFFFFF
/// - Top border: 1px #DADEE9
/// - Border radius: 24px (top corners only)
/// - Horizontal padding: 28px
/// - Items: justify-between (evenly distributed)
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColorScheme.white100, // #FFFFFF
        border: Border(
          top: BorderSide(
            color: AppColorScheme.white500, // #DADEE9
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: NavTab.values.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;

              return BottomNavItem(
                icon: tab.icon,
                label: tab.label,
                isSelected: currentIndex == index,
                onTap: () => onTabChanged(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
