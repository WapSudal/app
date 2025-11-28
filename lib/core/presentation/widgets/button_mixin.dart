import 'package:flutter/material.dart';

/// 버튼 위젯 공통 디자인 토큰
abstract class ButtonTokens {
  ButtonTokens._();

  /// 버튼 기본 높이: 50px
  static const double height = 50.0;

  /// 버튼 모서리 둥글기: BR2 (8px)
  static const double borderRadius = 8.0;

  /// 버튼 테두리 두께: 1.5px
  static const double strokeWidth = 1.5;

  /// 버튼 수평 패딩: 20px
  static const double horizontalPadding = 20.0;

  /// 버튼 수직 패딩: 15px
  static const double verticalPadding = 15.0;

  /// 아이콘과 텍스트 사이 간격: 4px
  static const double iconSpacing = 4.0;

  /// 로딩 인디케이터 크기: 24px
  static const double loadingIndicatorSize = 24.0;

  /// 로딩 인디케이터 두께: 2.5px
  static const double loadingIndicatorStrokeWidth = 2.5;
}

/// 버튼 공통 로직을 위한 Mixin
///
/// AppFlatButton과 AppOutlinedButton에서 공통으로 사용되는
/// 로딩 상태, 아이콘 처리 등의 로직을 제공합니다.
mixin AppButtonMixin {
  /// 버튼 콘텐츠 빌드 (로딩 상태, 아이콘 포함)
  Widget buildButtonContent({
    required String text,
    required bool isLoading,
    Widget? icon,
    required Color loadingColor,
  }) {
    if (isLoading) {
      return SizedBox(
        width: ButtonTokens.loadingIndicatorSize,
        height: ButtonTokens.loadingIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: ButtonTokens.loadingIndicatorStrokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: ButtonTokens.iconSpacing),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  /// 버튼 패딩
  EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
    horizontal: ButtonTokens.horizontalPadding,
    vertical: ButtonTokens.verticalPadding,
  );

  /// 버튼 모양
  RoundedRectangleBorder get buttonShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(ButtonTokens.borderRadius),
  );
}
