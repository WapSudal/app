import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';

/// 온보딩 페이지 인디케이터 위젯
///
/// 현재 페이지를 나타내는 4개의 점 인디케이터
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentPage,
    this.pageCount = 4,
  });

  /// 현재 페이지 인덱스 (0-based)
  final int currentPage;

  /// 전체 페이지 수
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(right: index < pageCount - 1 ? 8 : 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColorScheme.black100 : AppColorScheme.grey500,
          ),
        );
      }),
    );
  }
}
