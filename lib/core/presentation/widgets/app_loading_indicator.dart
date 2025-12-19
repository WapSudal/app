import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';

/// 2x2 그리드 로딩 애니메이션 인디케이터
///
/// 4개의 정사각형이 시계방향으로 순차적으로 하이라이트되는
/// 로딩 애니메이션을 표시합니다.
class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 64,
    this.color = AppColorScheme.black500,
  });

  /// 전체 인디케이터 크기 (정사각형)
  final double size;

  /// 인디케이터 색상
  final Color color;

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 애니메이션 값에 따라 각 사각형의 opacity 계산
  ///
  /// [index]: 사각형 인덱스 (0: 좌상단, 1: 우상단, 2: 우하단, 3: 좌하단)
  /// [value]: 애니메이션 값 (0.0 ~ 1.0)
  double _getOpacity(int index, double value) {
    const minOpacity = 0.15;
    const maxOpacity = 1.0;

    // 각 사각형의 활성화 중심 시점 (0, 0.25, 0.5, 0.75)
    final centerPoint = index * 0.25;

    // 현재 애니메이션 값과의 거리 계산
    double distance = (value - centerPoint).abs();

    // 순환 거리 계산 (0.5를 넘으면 반대편이 더 가까움)
    if (distance > 0.5) {
      distance = 1.0 - distance;
    }

    // 거리 0.0 ~ 0.25 범위를 0.0 ~ 1.0으로 정규화
    final normalizedDistance = (distance / 0.25).clamp(0.0, 1.0);

    // Ease-in-out curve를 적용하여 부드러운 전환
    final easedDistance = _easeInOutCubic(normalizedDistance);

    // 거리가 가까울수록 밝게 (1.0 - easedDistance)
    final opacity =
        minOpacity + (maxOpacity - minOpacity) * (1.0 - easedDistance);

    return opacity.clamp(minOpacity, maxOpacity);
  }

  /// Ease-in-out cubic 함수
  double _easeInOutCubic(double t) {
    if (t < 0.5) {
      return 4 * t * t * t;
    } else {
      final f = 2 * t - 2;
      return 1 + f * f * f / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final squareSize = widget.size / 2;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // 좌상단 (인덱스 0)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  color: widget.color.withValues(
                    alpha: _getOpacity(0, _controller.value),
                  ),
                ),
              ),
              // 우상단 (인덱스 1)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  color: widget.color.withValues(
                    alpha: _getOpacity(1, _controller.value),
                  ),
                ),
              ),
              // 우하단 (인덱스 2)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  color: widget.color.withValues(
                    alpha: _getOpacity(2, _controller.value),
                  ),
                ),
              ),
              // 좌하단 (인덱스 3)
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  color: widget.color.withValues(
                    alpha: _getOpacity(3, _controller.value),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
