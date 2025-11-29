import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/color_scheme.dart';
import 'form_field_tokens.dart';

/// 앱 공통 Outlined TextArea 위젯
///
/// Figma 디자인 스펙:
/// - Default Height: 50px (minHeight, 멀티라인 확장 가능)
/// - Placeholder Font Style: B2 (bodyMedium, 14px, Regular) - Grey/300
/// - Value Font Style: B2 (bodyMedium, 14px)
/// - Horizontal Padding: G4 (16px)
/// - Vertical Padding: G3 (12px)
/// - Outline Stroke: BW2 (1.5px)
/// - Border Radius: BR2 (8px)
///
/// 주요 차이점 (AppOutlinedTextField 대비):
/// - Floating label 없음, placeholder 사용
/// - 멀티라인 입력에 최적화
class AppOutlinedTextArea extends StatefulWidget {
  const AppOutlinedTextArea({
    super.key,
    this.placeholder,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLength,
    this.maxLines,
    this.minLines = 1,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.errorText,
    this.isExpanded = false,
    this.minHeight,
  });

  /// Placeholder 텍스트 (입력값이 없을 때 표시)
  final String? placeholder;

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

  /// 키보드 타입
  final TextInputType? keyboardType;

  /// 키보드 액션 버튼
  final TextInputAction? textInputAction;

  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;

  /// 최대 길이
  final int? maxLength;

  /// 최대 라인 수 (null이면 무제한)
  final int? maxLines;

  /// 최소 라인 수
  final int minLines;

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

  /// 최소 높이 (null이면 기본값 50px 사용)
  final double? minHeight;

  @override
  State<AppOutlinedTextArea> createState() => _AppOutlinedTextAreaState();
}

class _AppOutlinedTextAreaState extends State<AppOutlinedTextArea> {
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
  }

  @override
  void didUpdateWidget(covariant AppOutlinedTextArea oldWidget) {
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
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {});
    widget.onChanged?.call(_controller.text);
  }

  @override
  void dispose() {
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

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  Color get _borderColor {
    if (!widget.enabled) return AppColorScheme.white500;
    if (_hasError) return AppColorScheme.danger;
    if (_isFocused) return AppColorScheme.primaryColor;
    return AppColorScheme.white500;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final minHeight = widget.minHeight ?? FormFieldTokens.height;

    Widget textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType ?? TextInputType.multiline,
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
      style: textTheme.bodyMedium?.copyWith(
        color: widget.enabled
            ? AppColorScheme.black100
            : AppColorScheme.grey400,
      ),
      cursorColor: AppColorScheme.primaryColor,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.placeholder,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColorScheme.grey300,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        counterText: '', // maxLength 카운터 숨김
      ),
    );

    Widget textArea = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // TextArea container
        AnimatedContainer(
          duration: FormFieldTokens.animationDuration,
          height: null,
          padding: EdgeInsets.symmetric(
            horizontal: FormFieldTokens.outlinedHorizontalPadding,
            vertical: FormFieldTokens.outlinedVerticalPadding,
          ),
          constraints: BoxConstraints(minHeight: minHeight),
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
          child: textField,
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
        child: SizedBox(width: double.infinity, child: textArea),
      );
    }

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.text
          : SystemMouseCursors.forbidden,
      child: textArea,
    );
  }
}
