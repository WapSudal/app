import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import 'form_field_tokens.dart';

/// Floating Label 애니메이션을 위한 Mixin
///
/// AppOutlinedTextField, AppLinedTextField, AppOutlinedDropdown, AppLinedDropdown에서
/// 공통으로 사용되는 플로팅 라벨 애니메이션 로직을 제공합니다.
///
/// 사용법:
/// ```dart
/// class _MyWidgetState extends State<MyWidget>
///     with SingleTickerProviderStateMixin, FloatingLabelMixin {
///   @override
///   void initState() {
///     super.initState();
///     initFloatingLabelAnimation(initiallyFloated: hasValue);
///   }
/// }
/// ```
mixin FloatingLabelMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  late AnimationController floatingLabelController;
  late Animation<double> floatingLabelAnimation;

  /// 플로팅 라벨 애니메이션 초기화
  ///
  /// [initiallyFloated]: 초기에 라벨이 위로 올라간 상태인지 여부
  void initFloatingLabelAnimation({bool initiallyFloated = false}) {
    floatingLabelController = AnimationController(
      duration: FormFieldTokens.animationDuration,
      vsync: this,
    );

    floatingLabelAnimation =
        Tween<double>(
          begin: 0.0, // 중앙 위치
          end: 1.0, // 상단 위치
        ).animate(
          CurvedAnimation(
            parent: floatingLabelController,
            curve: Curves.easeOut,
          ),
        );

    if (initiallyFloated) {
      floatingLabelController.value = 1.0;
    }
  }

  /// 라벨 애니메이션 업데이트
  ///
  /// [shouldFloat]: 라벨이 위로 올라가야 하는지 여부
  void updateFloatingLabel(bool shouldFloat) {
    if (shouldFloat) {
      floatingLabelController.forward();
    } else {
      floatingLabelController.reverse();
    }
  }

  /// 플로팅 라벨 애니메이션 해제
  void disposeFloatingLabelAnimation() {
    floatingLabelController.dispose();
  }

  /// Outlined 스타일 플로팅 라벨 빌드
  ///
  /// [label]: 라벨 텍스트
  /// [labelColor]: 라벨 색상
  Widget buildOutlinedFloatingLabel({
    required String label,
    required Color labelColor,
  }) {
    // Scale factor: 13/16 = 0.8125
    const double baseFontSize = 16.0;
    const double smallFontSize = 13.0;
    const double scaleFactor = smallFontSize / baseFontSize;

    final double verticalOffset =
        FormFieldTokens.outlinedLabelVerticalOffset *
        floatingLabelAnimation.value;
    final double scale =
        1.0 - (1.0 - scaleFactor) * floatingLabelAnimation.value;
    final double horizontalPadding = 4.0 * floatingLabelAnimation.value;
    final double backgroundOpacity = floatingLabelAnimation.value;

    return IgnorePointer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(0, verticalOffset),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft,
            child: Container(
              color:
                  AppColorScheme.white100.withValues(alpha: backgroundOpacity),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: baseFontSize,
                  fontWeight: FontWeight.w500,
                  height: 20 / baseFontSize,
                  letterSpacing: -0.32,
                  color: labelColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Lined 스타일 플로팅 라벨 빌드
  ///
  /// [label]: 라벨 텍스트
  /// [labelColor]: 라벨 색상
  Widget buildLinedFloatingLabel({
    required String label,
    required Color labelColor,
  }) {
    // Scale factor: 13/16 = 0.8125
    const double baseFontSize = 16.0;
    const double smallFontSize = 13.0;
    const double scaleFactor = smallFontSize / baseFontSize;

    final double verticalOffset =
        FormFieldTokens.linedLabelVerticalOffset * floatingLabelAnimation.value;
    final double scale =
        1.0 - (1.0 - scaleFactor) * floatingLabelAnimation.value;

    return IgnorePointer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(0, verticalOffset),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft,
            // Lined style: 배경 없음
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: baseFontSize,
                fontWeight: FontWeight.w500,
                height: 20 / baseFontSize,
                letterSpacing: -0.32,
                color: labelColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
