import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import 'button_mixin.dart';

/// 앱 공통 Outlined 버튼 위젯
///
/// 테두리만 있는 버튼 스타일입니다.
class AppOutlinedButton extends StatelessWidget with AppButtonMixin {
  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.style,
  });

  /// 버튼 텍스트
  final String text;

  /// 버튼 클릭 시 호출되는 콜백
  final VoidCallback? onPressed;

  /// 버튼 왼쪽에 표시할 아이콘
  final Widget? icon;

  /// 로딩 상태 여부
  final bool isLoading;

  /// 너비를 최대로 확장할지 여부
  final bool isExpanded;

  /// 커스텀 버튼 스타일
  ///
  /// 기본 스타일에 병합되어 적용됩니다.
  /// 예: border radius를 최대로 하려면
  /// ```dart
  /// style: ButtonStyle(
  ///   shape: WidgetStateProperty.all(
  ///     RoundedRectangleBorder(
  ///       borderRadius: BorderRadius.circular(999),
  ///     ),
  ///   ),
  /// )
  /// ```
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      foregroundColor: style?.foregroundColor ??
          WidgetStateProperty.all(AppColorScheme.primaryColor),
      side: style?.side ??
          WidgetStateProperty.all(
            BorderSide(
              color: onPressed == null
                  ? AppColorScheme.grey400
                  : AppColorScheme.primaryColor,
              width: ButtonTokens.strokeWidth,
            ),
          ),
      shape: style?.shape ?? WidgetStateProperty.all(buttonShape),
      padding: style?.padding ?? WidgetStateProperty.all(buttonPadding),
      textStyle: style?.textStyle ??
          WidgetStateProperty.all(
            Theme.of(context).textTheme.labelLarge,
          ),
      splashFactory: style?.splashFactory ?? NoSplash.splashFactory,
      backgroundColor: style?.backgroundColor,
      overlayColor: style?.overlayColor,
      shadowColor: style?.shadowColor,
      elevation: style?.elevation,
      minimumSize: style?.minimumSize,
      maximumSize: style?.maximumSize,
      fixedSize: style?.fixedSize,
      visualDensity: style?.visualDensity,
      tapTargetSize: style?.tapTargetSize,
      animationDuration: style?.animationDuration,
      enableFeedback: style?.enableFeedback,
      alignment: style?.alignment,
      mouseCursor: style?.mouseCursor,
    );

    final Widget button = SizedBox(
      height: ButtonTokens.height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        clipBehavior: Clip.antiAlias,
        child: buildButtonContent(
          text: text,
          isLoading: isLoading,
          icon: icon,
          loadingColor: AppColorScheme.primaryColor,
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
