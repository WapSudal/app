import 'dart:ui';

import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import '../../../gen/assets.gen.dart';

/// 공통 Bottom Sheet 위젯
///
/// BackdropFilter, SafeArea, 컨테이너 스타일 등을 공통화한 Bottom Sheet입니다.
/// [AppBottomSheet.show]를 통해 표시할 수 있습니다.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.title,
    this.maxHeightRatio = 0.8,
    this.heightRatio,
    this.showDragHandle = false,
    this.showCloseButton = true,
    required this.child,
  });

  final String? title;
  final double maxHeightRatio;
  final double? heightRatio;
  final bool showDragHandle;
  final bool showCloseButton;
  final Widget child;

  /// Bottom Sheet를 표시합니다.
  ///
  /// [title]: Bottom Sheet 상단에 표시될 제목
  /// [maxHeightRatio]: Bottom Sheet의 최대 높이 비율 (0.0 ~ 1.0, 기본값: 0.8)
  /// [heightRatio]: Bottom Sheet의 고정 높이 비율 (0.0 ~ 1.0). 설정 시 maxHeightRatio 무시
  /// [showDragHandle]: Drag Handle 표시 여부 (기본값: false)
  /// [showCloseButton]: 닫기 버튼 표시 여부 (기본값: true)
  /// [child]: Bottom Sheet의 내용
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    double maxHeightRatio = 0.8,
    double? heightRatio,
    bool showDragHandle = false,
    bool showCloseButton = true,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.15),
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => AppBottomSheet(
        title: title,
        maxHeightRatio: maxHeightRatio,
        heightRatio: heightRatio,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animationValue = animation.value;
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3 * animationValue,
            sigmaY: 3 * animationValue,
          ),
          child: child!,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height *
                  (heightRatio ?? maxHeightRatio),
              minHeight: heightRatio != null
                  ? MediaQuery.of(context).size.height * heightRatio!
                  : 0,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColorScheme.white100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColorScheme.black100.withValues(alpha: 0.15),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle (선택적)
                  if (showDragHandle) ...[
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColorScheme.grey400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // 헤더 (제목 + 닫기 버튼)
                  if (title != null) ...[
                    _buildHeader(context),
                    const SizedBox(height: 16),
                  ],
                  // 내용
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!, style: Theme.of(context).textTheme.headlineMedium),
        if (showCloseButton)
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Opacity(
              opacity: 0.2,
              child: Assets.icons.close.svg(
                width: 21,
                height: 21,
                colorFilter: ColorFilter.mode(
                  AppColorScheme.black100,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
