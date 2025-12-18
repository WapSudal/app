import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import 'app_loading_indicator.dart';

/// 전체 화면 로딩 오버레이
///
/// 화면 전체를 덮는 반투명 배경과 블러 효과를 적용하고
/// 중앙에 로딩 인디케이터와 메시지를 표시합니다.
///
/// 사용 예시:
/// ```dart
/// // 로딩 표시
/// LoadingOverlay.show(context, message: '요청 처리중');
///
/// // 작업 수행
/// await apiCall();
///
/// // 로딩 숨김
/// LoadingOverlay.hide();
/// ```
class LoadingOverlay {
  LoadingOverlay._();

  static OverlayEntry? _entry;

  /// 로딩 오버레이를 표시합니다.
  ///
  /// [context]: BuildContext
  /// [message]: 로딩 메시지 (기본값: '요청 처리중')
  static void show(BuildContext context, {String message = '요청 처리중'}) {
    // 이미 표시 중이면 무시
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (context) => _LoadingOverlayWidget(message: message),
    );

    Overlay.of(context).insert(_entry!);
  }

  /// 로딩 오버레이를 숨깁니다.
  static void hide() {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  }

  /// 현재 로딩 오버레이가 표시 중인지 확인합니다.
  static bool get isShowing => _entry != null;
}

/// 로딩 오버레이 위젯 (내부 구현)
class _LoadingOverlayWidget extends StatelessWidget {
  const _LoadingOverlayWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 배경: 블러 + 반투명 검은색
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: AppColorScheme.black100.withValues(alpha: 0.3),
              ),
            ),
          ),
          // 중앙: 로딩 인디케이터 + 메시지
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 로딩 인디케이터
                const AppLoadingIndicator(
                  size: 64,
                  color: AppColorScheme.white100,
                ),
                const SizedBox(height: 20),
                // 메시지
                Text(
                  message,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColorScheme.white100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
