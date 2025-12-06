import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';
import '../../theme/color_scheme.dart';

/// Individual bottom navigation item
///
/// Matches Figma design:
/// - Size: 56x48px
/// - Icon: 30x30px
/// - Text: 11px Pretendard Medium
/// - Gap: 4px between icon and text
class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final SvgGenImage icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? AppColorScheme
              .black100 // #000000
        : const Color(0xFFC3CACF); // #C3CACF

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(3.75),
              child: icon.svg(
                width: 22.5,
                height: 22.5,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500, // Medium
                color: color,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
