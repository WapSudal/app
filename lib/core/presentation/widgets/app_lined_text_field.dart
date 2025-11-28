import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/color_scheme.dart';
import 'floating_label_mixin.dart';
import 'form_field_tokens.dart';

/// 앱 공통 Lined TextField 위젯
///
/// Figma 디자인 스펙:
/// - Default Height: 50px
/// - Label Font Style (Inactive): L1 (labelLarge, 16px, Medium) - 중앙
/// - Label Font Style (Focused/Populated): C1 (labelSmall, 13px, Regular) - 상단
/// - Value Font Style: L1 (labelLarge)
/// - Bottom Line Stroke: BW2 (1.5px)
/// - Clear Button Size: 28px
/// - Horizontal Padding: 0px (라인이 전체 너비)
class AppLinedTextField extends StatefulWidget {
  const AppLinedTextField({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.showClearButton = true,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.errorText,
    this.isExpanded = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  /// 레이블 텍스트 (필수 - 플로팅 라벨로 동작)
  final String label;

  /// 텍스트 컨트롤러
  final TextEditingController? controller;

  /// 포커스 노드
  final FocusNode? focusNode;

  /// 초기값
  final String? initialValue;

  /// 활성화 여부
  final bool enabled;

  /// 읽기 전용 여부
  final bool readOnly;

  /// 비밀번호 입력 모드
  final bool obscureText;

  /// Clear 버튼 표시 여부 (포커스 && 값이 있을 때 표시)
  final bool showClearButton;

  /// 키보드 타입
  final TextInputType? keyboardType;

  /// 키보드 액션 버튼
  final TextInputAction? textInputAction;

  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;

  /// 최대 길이
  final int? maxLength;

  /// 최대 라인 수
  final int maxLines;

  /// 최소 라인 수
  final int? minLines;

  /// 값이 변경될 때 호출되는 콜백
  final ValueChanged<String>? onChanged;

  /// 편집 완료 시 호출되는 콜백
  final VoidCallback? onEditingComplete;

  /// 제출 시 호출되는 콜백
  final ValueChanged<String>? onSubmitted;

  /// 탭 시 호출되는 콜백
  final VoidCallback? onTap;

  /// 유효성 검사 함수
  final String? Function(String?)? validator;

  /// 에러 텍스트 (아래에 표시)
  final String? errorText;

  /// 너비를 최대로 확장할지 여부
  final bool isExpanded;

  /// 접미 아이콘 (Clear 버튼 대신 커스텀 아이콘 사용 시)
  final Widget? suffixIcon;

  /// 접두 아이콘
  final Widget? prefixIcon;

  @override
  State<AppLinedTextField> createState() => _AppLinedTextFieldState();
}

class _AppLinedTextFieldState extends State<AppLinedTextField>
    with SingleTickerProviderStateMixin, FloatingLabelMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isInternalController = false;
  bool _isInternalFocusNode = false;

  @override
  void initState() {
    super.initState();

    // Controller 초기화
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _isInternalController = true;
    }

    // FocusNode 초기화
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    }

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);

    // 플로팅 라벨 애니메이션 초기화 (믹스인 사용)
    initFloatingLabelAnimation(initiallyFloated: _controller.text.isNotEmpty);
  }

  @override
  void didUpdateWidget(covariant AppLinedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Controller 업데이트
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null && _isInternalController) {
        _controller.removeListener(_onTextChange);
        _controller.dispose();
        _isInternalController = false;
      }
      if (widget.controller != null) {
        _controller = widget.controller!;
      } else {
        _controller = TextEditingController(text: widget.initialValue);
        _isInternalController = true;
      }
      _controller.addListener(_onTextChange);
    }

    // FocusNode 업데이트
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null && _isInternalFocusNode) {
        _focusNode.removeListener(_onFocusChange);
        _focusNode.dispose();
        _isInternalFocusNode = false;
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
      } else {
        _focusNode = FocusNode();
        _isInternalFocusNode = true;
      }
      _focusNode.addListener(_onFocusChange);
    }

    _updateLabelAnimation();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      _updateLabelAnimation();
    });
  }

  void _onTextChange() {
    setState(() {
      _updateLabelAnimation();
    });
    widget.onChanged?.call(_controller.text);
  }

  void _updateLabelAnimation() {
    final shouldFloat = _isFocused || _controller.text.isNotEmpty;
    updateFloatingLabel(shouldFloat);
  }

  @override
  void dispose() {
    disposeFloatingLabelAnimation();
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    if (_isInternalController) {
      _controller.dispose();
    }
    if (_isInternalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  bool get _hasValue => _controller.text.isNotEmpty;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  Color get _borderColor {
    if (!widget.enabled) return AppColorScheme.white500;
    if (_hasError) return AppColorScheme.danger;
    if (_isFocused) return AppColorScheme.primaryColor;
    return AppColorScheme.white500;
  }

  Color get _labelColor {
    if (!widget.enabled) return AppColorScheme.grey500;
    if (_hasError) return AppColorScheme.danger;
    if (_isFocused) return AppColorScheme.primaryColor;
    return AppColorScheme.grey300;
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget textField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // TextField with floating label
        AnimatedBuilder(
          animation: floatingLabelController,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Main text field container (하단 라인만)
                AnimatedContainer(
                  duration: FormFieldTokens.animationDuration,
                  height: widget.maxLines > 1 ? null : FormFieldTokens.height,
                  constraints: widget.maxLines > 1
                      ? const BoxConstraints(minHeight: FormFieldTokens.height)
                      : null,
                  decoration: BoxDecoration(
                    color: AppColorScheme.white100,
                    border: Border(
                      bottom: BorderSide(
                        color: _borderColor,
                        width: FormFieldTokens.strokeWidth,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: widget.maxLines > 1
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      // Prefix icon
                      if (widget.prefixIcon != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: widget.prefixIcon,
                        ),
                      ],
                      // Text input field
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right:
                                _shouldShowClearButton ||
                                    widget.suffixIcon != null
                                ? 0
                                : 0,
                            top: widget.maxLines > 1 ? 14 : 0,
                            bottom: widget.maxLines > 1 ? 14 : 0,
                          ),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            enabled: widget.enabled,
                            readOnly: widget.readOnly,
                            obscureText: widget.obscureText,
                            keyboardType: widget.keyboardType,
                            textInputAction: widget.textInputAction,
                            inputFormatters: widget.inputFormatters,
                            maxLength: widget.maxLength,
                            maxLines: widget.maxLines,
                            minLines: widget.minLines,
                            onEditingComplete: widget.onEditingComplete,
                            onSubmitted: widget.onSubmitted,
                            onTap: widget.onTap,
                            mouseCursor: widget.enabled
                                ? SystemMouseCursors.text
                                : SystemMouseCursors.forbidden,
                            style: textTheme.labelLarge?.copyWith(
                              color: widget.enabled
                                  ? AppColorScheme.black100
                                  : AppColorScheme.grey400,
                            ),
                            cursorColor: AppColorScheme.primaryColor,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              counterText: '', // maxLength 카운터 숨김
                            ),
                          ),
                        ),
                      ),
                      // Suffix: Clear button or custom icon
                      if (_shouldShowClearButton) ...[
                        _buildClearButton(),
                      ] else if (widget.suffixIcon != null) ...[
                        widget.suffixIcon!,
                      ],
                    ],
                  ),
                ),
                // Floating Label
                Positioned(
                  left: widget.prefixIcon != null ? 32 + 8 : 0,
                  top: 0,
                  bottom: widget.maxLines > 1 ? null : 0,
                  child: buildLinedFloatingLabel(
                    label: widget.label,
                    labelColor: _labelColor,
                  ),
                ),
              ],
            );
          },
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
      return MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.text
            : SystemMouseCursors.forbidden,
        child: SizedBox(width: double.infinity, child: textField),
      );
    }

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.text
          : SystemMouseCursors.forbidden,
      child: textField,
    );
  }

  bool get _shouldShowClearButton =>
      widget.showClearButton &&
      _isFocused &&
      _hasValue &&
      widget.suffixIcon == null &&
      !widget.readOnly;

  Widget _buildClearButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _clearText(),
        child: SizedBox(
          width: FormFieldTokens.clearButtonSize + 8,
          height: FormFieldTokens.clearButtonSize,
          child: Center(
            child: Icon(
              Icons.cancel_rounded,
              color: AppColorScheme.white500,
              size: FormFieldTokens.clearButtonSize - 4,
            ),
          ),
        ),
      ),
    );
  }
}
