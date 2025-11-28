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
        style: FilledButton.styleFrom(
          backgroundColor: AppColorScheme.primaryColor,
          foregroundColor: AppColorScheme.white100,
          disabledBackgroundColor: AppColorScheme.primaryColor,
          disabledForegroundColor: AppColorScheme.white100.withValues(
            alpha: 0.5,
          ),
          shape: buttonShape,
          padding: buttonPadding,
          textStyle: Theme.of(context).textTheme.labelLarge,
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
