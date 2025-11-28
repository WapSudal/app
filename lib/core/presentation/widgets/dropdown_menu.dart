import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import 'form_field_tokens.dart';

/// Dropdown 아이템 모델
///
/// 드롭다운 위젯에서 사용되는 아이템의 값과 라벨을 저장합니다.
class DropdownItem<T> {
  const DropdownItem({required this.value, required this.label});

  /// 아이템의 실제 값
  final T value;

  /// 사용자에게 표시되는 라벨
  final String label;
}

/// 드롭다운 메뉴 오버레이
///
/// AppOutlinedDropdown과 AppLinedDropdown에서 공통으로 사용되는 메뉴 오버레이입니다.
class DropdownMenuOverlay<T> extends StatelessWidget {
  const DropdownMenuOverlay({
    super.key,
    required this.link,
    required this.width,
    required this.items,
    required this.selectedValue,
    required this.onItemSelected,
    required this.onDismiss,
  });

  /// CompositedTransformFollower에 연결할 LayerLink
  final LayerLink link;

  /// 메뉴의 너비 (드롭다운 버튼과 동일한 너비)
  final double width;

  /// 드롭다운 아이템 목록
  final List<DropdownItem<T>> items;

  /// 현재 선택된 값
  final T? selectedValue;

  /// 아이템 선택 시 호출되는 콜백
  final ValueChanged<T> onItemSelected;

  /// 메뉴 닫기 요청 시 호출되는 콜백
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        // 배경 탭하면 닫기
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
        // 드롭다운 메뉴
        CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: Offset(
            0,
            FormFieldTokens.height + DropdownMenuTokens.menuMargin + 2,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: width,
              constraints: BoxConstraints(
                maxHeight:
                    DropdownMenuTokens.menuItemHeight * 5 +
                    DropdownMenuTokens.menuPadding * 2,
              ),
              decoration: BoxDecoration(
                color: AppColorScheme.white100,
                borderRadius: BorderRadius.circular(
                  DropdownMenuTokens.menuBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorScheme.black100.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  DropdownMenuTokens.menuBorderRadius,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: DropdownMenuTokens.menuPadding,
                  ),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item.value == selectedValue;

                    return DropdownMenuItemWidget(
                      label: item.label,
                      isSelected: isSelected,
                      onTap: () => onItemSelected(item.value),
                      textStyle: textTheme.labelMedium,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 드롭다운 메뉴 아이템 위젯
///
/// 호버 상태와 선택 상태에 따라 스타일이 변경됩니다.
class DropdownMenuItemWidget extends StatefulWidget {
  const DropdownMenuItemWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.textStyle,
  });

  /// 아이템 라벨
  final String label;

  /// 선택 상태
  final bool isSelected;

  /// 탭 시 호출되는 콜백
  final VoidCallback onTap;

  /// 텍스트 스타일
  final TextStyle? textStyle;

  @override
  State<DropdownMenuItemWidget> createState() => _DropdownMenuItemWidgetState();
}

class _DropdownMenuItemWidgetState extends State<DropdownMenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: DropdownMenuTokens.menuItemHeight,
          padding: EdgeInsets.symmetric(
            horizontal: DropdownMenuTokens.menuItemHorizontalPadding,
          ),
          decoration: BoxDecoration(
            color: _isHovered || widget.isSelected
                ? AppColorScheme.white200
                : AppColorScheme.white100,
            borderRadius: BorderRadius.circular(
              DropdownMenuTokens.menuItemBorderRadius,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: widget.textStyle?.copyWith(
              color: widget.isSelected
                  ? AppColorScheme.primaryColor
                  : AppColorScheme.black100,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
