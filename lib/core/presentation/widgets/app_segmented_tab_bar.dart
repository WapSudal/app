import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';

/// 세그먼트 탭 아이템
class SegmentedTabItem {
  const SegmentedTabItem({required this.label, this.value});

  final String label;
  final dynamic value;
}

/// 세그먼트 탭 바
///
/// 7일/30일/전체 탭과 같은 세그먼트 형태의 탭 바 위젯
/// 재사용 가능한 공통 컴포넌트
class AppSegmentedTabBar extends StatelessWidget {
  const AppSegmentedTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.borderRadius = 12,
    this.itemBorderRadius = 8,
    this.padding = const EdgeInsets.all(4),
    this.itemHeight = 42,
  });

  /// 탭 아이템 목록
  final List<SegmentedTabItem> items;

  /// 선택된 아이템 인덱스
  final int selectedIndex;

  /// 아이템 선택 콜백
  final ValueChanged<int> onItemSelected;

  /// 전체 배경색
  final Color? backgroundColor;

  /// 선택된 아이템 배경색
  final Color? selectedBackgroundColor;

  /// 선택된 아이템 텍스트 색상
  final Color? selectedTextColor;

  /// 선택되지 않은 아이템 텍스트 색상
  final Color? unselectedTextColor;

  /// 전체 border radius
  final double borderRadius;

  /// 아이템 border radius
  final double itemBorderRadius;

  /// 내부 패딩
  final EdgeInsets padding;

  /// 아이템 높이
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColorScheme.white300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onItemSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: itemHeight,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedBackgroundColor ?? AppColorScheme.white100)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(itemBorderRadius),
                ),
                alignment: Alignment.center,
                child: Text(
                  items[index].label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? (selectedTextColor ?? AppColorScheme.primaryColor)
                        : (unselectedTextColor ?? AppColorScheme.grey400),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// 기간 필터용 세그먼트 탭 바 프리셋
class PeriodSegmentedTabBar extends StatelessWidget {
  const PeriodSegmentedTabBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  static const _items = [
    SegmentedTabItem(label: '7일', value: 7),
    SegmentedTabItem(label: '30일', value: 30),
    SegmentedTabItem(label: '전체', value: null),
  ];

  @override
  Widget build(BuildContext context) {
    return AppSegmentedTabBar(
      items: _items,
      selectedIndex: selectedIndex,
      onItemSelected: onItemSelected,
    );
  }
}
