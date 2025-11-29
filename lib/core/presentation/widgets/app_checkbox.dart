import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';

/// 앱 공통 Checkbox 위젯
///
/// Figma 디자인 스펙:
/// - Size: 20x20px
/// - Default: 테두리만 있는 빈 체크박스 (border: White/500 #DADEE9)
/// - Checked: 파란색 배경에 체크마크 (fill: Primary #1E90FF)
/// - Border Radius: 4px
/// - Label Font Style: B3 (13px, Regular)
/// - Gap between checkbox and label: G2 (8px)
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// 체크 상태
  final bool value;

  /// 체크 상태 변경 콜백
  final ValueChanged<bool>? onChanged;

  /// 체크박스 옆에 표시할 라벨
  final String? label;

  /// 활성화 여부
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !enabled || onChanged == null;
    final double disabledOpacity = isDisabled ? 0.4 : 1.0;

    return Opacity(
      opacity: disabledOpacity,
      child: GestureDetector(
        onTap: isDisabled ? null : () => onChanged?.call(!value),
        child: MouseRegion(
          cursor: isDisabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCheckbox(),
              if (label != null) ...[
                const SizedBox(width: CheckboxTokens.gap),
                Text(
                  label!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColorScheme.black100,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return AnimatedContainer(
      duration: CheckboxTokens.animationDuration,
      width: CheckboxTokens.size,
      height: CheckboxTokens.size,
      decoration: BoxDecoration(
        color: value ? AppColorScheme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(CheckboxTokens.borderRadius),
        border: value
            ? null
            : Border.all(
                color: AppColorScheme.white500,
                width: CheckboxTokens.strokeWidth,
              ),
      ),
      child: Center(
        child: Icon(
          Icons.check,
          size: CheckboxTokens.checkIconSize,
          color: value ? AppColorScheme.white100 : AppColorScheme.white500,
        ),
      ),
    );
  }
}

/// Checkbox 디자인 토큰
abstract class CheckboxTokens {
  CheckboxTokens._();

  /// 체크박스 크기: 20x20px
  static const double size = 20.0;

  /// 체크 아이콘 크기: 14px
  static const double checkIconSize = 14.0;

  /// 테두리 두께: 1.5px
  static const double strokeWidth = 1.5;

  /// 모서리 둥글기: 4px
  static const double borderRadius = 4.0;

  /// 체크박스와 라벨 간격: G2 (8px)
  static const double gap = 8.0;

  /// 애니메이션 지속 시간
  static const Duration animationDuration = Duration(milliseconds: 150);
}
