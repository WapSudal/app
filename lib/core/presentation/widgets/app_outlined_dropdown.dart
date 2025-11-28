import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import 'dropdown_menu.dart';
import 'floating_label_mixin.dart';
import 'form_field_tokens.dart';

// DropdownItem은 dropdown_menu.dart에서 재사용

/// 앱 공통 Outlined Dropdown 위젯
///
/// Figma 디자인 스펙:
/// - Default Height: 50px
/// - Menu Element Height: 40px
/// - Label Font Style (Inactive): L1 (labelLarge, 16px, Medium) - 박스 안쪽 중앙
/// - Label Font Style (Focused/Populated): C1 (labelSmall, 13px, Regular) - 박스 상단
/// - Value Font Style: L1 (labelLarge)
/// - Menu Font Style: L2 (labelMedium)
/// - Horizontal Margin: G4 (16px)
/// - Menu Margin: G2 (8px)
/// - Outline Stroke: BW2 (1.5px)
class AppOutlinedDropdown<T> extends StatefulWidget {
  const AppOutlinedDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    required this.label,
    this.errorText,
    this.isEnabled = true,
    this.isExpanded = false,
  });

  /// 드롭다운 아이템 목록
  final List<DropdownItem<T>> items;

  /// 현재 선택된 값
  final T? value;

  /// 값이 변경될 때 호출되는 콜백
  final ValueChanged<T?>? onChanged;

  /// 레이블 텍스트 (필수 - 플로팅 라벨로 동작)
  final String label;

  /// 에러 텍스트 (아래에 표시)
  final String? errorText;

  /// 활성화 여부
  final bool isEnabled;

  /// 너비를 최대로 확장할지 여부
  final bool isExpanded;

  @override
  State<AppOutlinedDropdown<T>> createState() => _AppOutlinedDropdownState<T>();
}

class _AppOutlinedDropdownState<T> extends State<AppOutlinedDropdown<T>>
    with SingleTickerProviderStateMixin, FloatingLabelMixin {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    // 플로팅 라벨 애니메이션 초기화 (믹스인 사용)
    initFloatingLabelAnimation(initiallyFloated: widget.value != null);
  }

  @override
  void didUpdateWidget(covariant AppOutlinedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLabelAnimation();
  }

  void _updateLabelAnimation() {
    final shouldFloat = _isOpen || widget.value != null;
    updateFloatingLabel(shouldFloat);
  }

  @override
  void dispose() {
    disposeFloatingLabelAnimation();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.isEnabled) return;

    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => DropdownMenuOverlay<T>(
        link: _layerLink,
        width: size.width,
        items: widget.items,
        selectedValue: widget.value,
        onItemSelected: (value) {
          widget.onChanged?.call(value);
          _removeOverlay();
        },
        onDismiss: _removeOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
      _updateLabelAnimation();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
        _updateLabelAnimation();
      });
    }
  }

  String? get _selectedLabel {
    if (widget.value == null) return null;
    try {
      return widget.items
          .firstWhere((item) => item.value == widget.value)
          .label;
    } catch (_) {
      return null;
    }
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  Color get _borderColor {
    if (!widget.isEnabled) return AppColorScheme.white500;
    if (_hasError) return AppColorScheme.danger;
    if (_isOpen) return AppColorScheme.primaryColor;
    return AppColorScheme.white500;
  }

  Color get _iconColor {
    if (!widget.isEnabled) return AppColorScheme.grey500;
    if (_isOpen) return AppColorScheme.primaryColor;
    return AppColorScheme.grey400;
  }

  Color get _labelColor {
    if (!widget.isEnabled) return AppColorScheme.grey500;
    if (_hasError) return AppColorScheme.danger;
    if (_isOpen) return AppColorScheme.primaryColor;
    // Populated but not focused
    if (widget.value != null) return AppColorScheme.black500;
    return AppColorScheme.black500;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget dropdown = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dropdown Button with floating label
        CompositedTransformTarget(
          link: _layerLink,
          child: MouseRegion(
            cursor: widget.isEnabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            child: GestureDetector(
              key: _dropdownKey,
              onTap: _toggleDropdown,
              child: AnimatedBuilder(
                animation: floatingLabelController,
                builder: (context, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Main dropdown container
                      AnimatedContainer(
                        duration: FormFieldTokens.animationDuration,
                        height: FormFieldTokens.height,
                        decoration: BoxDecoration(
                          color: AppColorScheme.white100,
                          borderRadius: BorderRadius.circular(
                            FormFieldTokens.outlinedBorderRadius,
                          ),
                          border: Border.all(
                            color: _borderColor,
                            width: FormFieldTokens.strokeWidth,
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: FormFieldTokens.outlinedHorizontalPadding,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _selectedLabel != null
                                  ? Text(
                                      _selectedLabel!,
                                      style: textTheme.labelLarge?.copyWith(
                                        color: widget.isEnabled
                                            ? AppColorScheme.black100
                                            : AppColorScheme.grey400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            // 세로 구분선
                            Container(
                              width: FormFieldTokens.strokeWidth,
                              height: FormFieldTokens.height,
                              color: _borderColor,
                            ),
                            // 드롭다운 아이콘 영역 (50px에서 테두리 두께 제외)
                            SizedBox(
                              width: 50 - FormFieldTokens.strokeWidth * 2,
                              child: Center(
                                child: AnimatedRotation(
                                  turns: _isOpen ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: _iconColor,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Floating Label
                      Positioned(
                        left: FormFieldTokens.outlinedHorizontalPadding - 1,
                        top: 0,
                        bottom: 0,
                        child: buildOutlinedFloatingLabel(
                          label: widget.label,
                          labelColor: _labelColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        // Error text
        if (_hasError) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: textTheme.labelSmall?.copyWith(color: AppColorScheme.danger),
          ),
        ],
      ],
    );

    if (widget.isExpanded) {
      return SizedBox(width: double.infinity, child: dropdown);
    }

    return dropdown;
  }
}
