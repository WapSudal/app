import 'dart:ui';

import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';

/// 공통 확인 다이얼로그 위젯
///
/// 제목, 설명, 버튼을 포함하는 모달 다이얼로그입니다.
/// 버튼은 직접 위젯으로 전달하여 유연하게 구성할 수 있습니다.
///
/// ## 사용 예시
/// ```dart
/// AppConfirmDialog.show(
///   context: context,
///   title: '로그아웃할까요?',
///   description: '현재 로그인된 계정을 로그아웃할게요',
///   buttons: [
///     Expanded(
///       child: AppFlatButton(
///         text: '취소',
///         onPressed: () => Navigator.pop(context),
///         style: ButtonStyle(
///           backgroundColor: WidgetStateProperty.all(AppColorScheme.white300),
///           foregroundColor: WidgetStateProperty.all(AppColorScheme.black100),
///         ),
///       ),
///     ),
///     const SizedBox(width: 8),
///     Expanded(
///       child: AppFlatButton(
///         text: '로그아웃',
///         onPressed: () {
///           // 로그아웃 로직
///         },
///       ),
///     ),
///   ],
/// );
/// ```
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    this.description,
    required this.buttons,
    this.barrierDismissible = true,
  });

  /// 다이얼로그 제목
  final String title;

  /// 다이얼로그 설명 (선택)
  final String? description;

  /// 다이얼로그 하단 버튼 목록
  ///
  /// 유연한 레이아웃을 위해 버튼 위젯을 직접 전달합니다.
  /// 버튼 사이 간격이 필요하면 SizedBox를 포함하세요.
  /// 예: [Expanded(child: CancelButton), SizedBox(width: 8), Expanded(child: ConfirmButton)]
  final List<Widget> buttons;

  /// 바깥 영역 터치 시 닫기 여부
  final bool barrierDismissible;

  /// 다이얼로그를 표시합니다.
  ///
  /// [title]: 다이얼로그 제목
  /// [description]: 다이얼로그 설명 (선택)
  /// [buttons]: 하단 버튼 위젯 목록
  /// [barrierDismissible]: 바깥 영역 터치 시 닫기 여부 (기본값: true)
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    required List<Widget> buttons,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.15),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppConfirmDialog(
          title: title,
          description: description,
          buttons: buttons,
          barrierDismissible: barrierDismissible,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 1.25 * animation.value,
            sigmaY: 1.25 * animation.value,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColorScheme.white100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00274C).withValues(alpha: 0.07),
                offset: const Offset(0, 4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 텍스트 영역
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 제목
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColorScheme.black100,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // 설명
                    if (description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColorScheme.black500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              // 버튼 영역
              Row(children: buttons),
            ],
          ),
        ),
      ),
    );
  }
}
