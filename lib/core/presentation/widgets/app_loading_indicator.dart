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
    this.color = AppColorScheme.white100,
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
    // 8 프레임으로 나누어 각 사각형이 2프레임씩 활성화
    final frame = (value * 8).floor();
    final activeIndex = (frame / 2).floor() % 4;

    // 활성 상태: opacity 1.0, 비활성 상태: opacity 0.2
    return activeIndex == index ? 1.0 : 0.2;
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
                  color: widget.color.withOpacity(
                    _getOpacity(0, _controller.value),
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
                  color: widget.color.withOpacity(
                    _getOpacity(1, _controller.value),
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
                  color: widget.color.withOpacity(
                    _getOpacity(2, _controller.value),
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
                  color: widget.color.withOpacity(
                    _getOpacity(3, _controller.value),
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
