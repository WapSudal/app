import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import 'button_mixin.dart';

/// 앱 공통 Flat(Filled) 버튼 위젯
///
/// 배경색이 채워진 기본 버튼 스타일입니다.
class AppFlatButton extends StatelessWidget with AppButtonMixin {
  const AppFlatButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
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

  @override
  Widget build(BuildContext context) {
    final Widget button = SizedBox(
      height: ButtonTokens.height,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColorScheme.primaryColor;
            }
            if (states.contains(WidgetState.pressed)) {
              // 클릭 시: primaryColor에 검은색 10% 오버레이 효과
              return Color.alphaBlend(
                AppColorScheme.black100.withValues(alpha: 0.1),
                AppColorScheme.primaryColor,
              );
            }
            if (states.contains(WidgetState.hovered)) {
              // 호버 시: primaryColor에 흰색 10% 오버레이 효과
              return Color.alphaBlend(
                AppColorScheme.white100.withValues(alpha: 0.1),
                AppColorScheme.primaryColor,
              );
            }
            return AppColorScheme.primaryColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColorScheme.white100.withValues(alpha: 0.5);
            }
            return AppColorScheme.white100;
          }),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(buttonShape),
          padding: WidgetStateProperty.all(buttonPadding),
          textStyle: WidgetStateProperty.all(
            Theme.of(context).textTheme.labelLarge,
          ),
          splashFactory: NoSplash.splashFactory,
        ),
        child: buildButtonContent(
          text: text,
          isLoading: isLoading,
          icon: icon,
          loadingColor: AppColorScheme.white100,
        ),
      ),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
