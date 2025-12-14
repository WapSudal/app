import 'package:flutter/material.dart';

import '../../theme/color_scheme.dart';

/// Bottom Sheet 디자인 토큰
class BottomSheetTokens {
  // 레이아웃
  static const double borderRadius = 16.0;
  static const double handleWidth = 40.0;
  static const double handleHeight = 4.0;
  static const double handleTopMargin = 12.0;
  static const double handleBottomMargin = 8.0;
  static const double contentPadding = 20.0;
  static const double headerHeight = 28.0;

  // 백드롭 효과 (Figma 디자인 기준)
  static const double maxDimOpacity = 0.5; // rgba(0,0,0,0.15)

  // 그림자 (Floating Button 효과: 0px 4px 20px rgba(0,39,76,0.07))
  static const Color shadowColor = Color(0x1200274C);
  static const double shadowBlurRadius = 20.0;
  static const Offset shadowOffset = Offset(0, -4);

  // 드래그 임계값 (25% 이상 드래그 시 닫힘)
  static const double dismissThreshold = 0.25;

  // 애니메이션
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeOutExpo;
}

/// 재사용 가능한 Bottom Sheet 위젯
///
/// dimming backdrop이 적용되며,
/// bottom sheet의 진행률에 따라 애니메이션됩니다.
///
/// 사용 예시:
/// ```dart
/// AppBottomSheet.show(
///   context: context,
///   title: '알림',
///   child: NotificationListContent(),
/// );
/// ```
class AppBottomSheet extends StatefulWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.maxHeightRatio = 0.85,
    this.initialHeightRatio,
    this.showDragHandle = true,
    this.showCloseButton = true,
    this.onClose,
  });

  /// Bottom sheet 내용
  final Widget child;

  /// Bottom sheet 상단 타이틀
  final String? title;

  /// 화면 높이 대비 최대 높이 비율 (기본값: 0.85)
  final double maxHeightRatio;

  /// 화면 높이 대비 초기 높이 비율 (null이면 maxHeightRatio와 동일)
  final double? initialHeightRatio;

  /// 드래그 핸들 표시 여부
  final bool showDragHandle;

  /// 닫기 버튼 표시 여부
  final bool showCloseButton;

  /// 닫기 시 콜백
  final VoidCallback? onClose;

  /// Bottom sheet를 표시하는 헬퍼 메서드
  ///
  /// [context] - BuildContext
  /// [child] - Bottom sheet 내용
  /// [title] - Bottom sheet 상단 타이틀
  /// [maxHeightRatio] - 화면 높이 대비 최대 높이 비율 (기본값: 0.85)
  /// [initialHeightRatio] - 화면 높이 대비 초기 높이 비율 (null이면 maxHeightRatio와 동일)
  /// [showDragHandle] - 드래그 핸들 표시 여부 (기본값: true)
  /// [showCloseButton] - 닫기 버튼 표시 여부 (기본값: true)
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double maxHeightRatio = 0.85,
    double? initialHeightRatio,
    bool showDragHandle = true,
    bool showCloseButton = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    final effectiveInitialRatio = initialHeightRatio ?? maxHeightRatio;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: false, // 커스텀 핸들링
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BottomSheetTokens.animationDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _AnimatedBackdropBottomSheet(
          animation: animation,
          maxHeightRatio: maxHeightRatio,
          initialHeightRatio: effectiveInitialRatio,
          enableDrag: enableDrag,
          isDismissible: isDismissible,
          child: AppBottomSheet(
            title: title,
            maxHeightRatio: maxHeightRatio,
            initialHeightRatio: effectiveInitialRatio,
            showDragHandle: showDragHandle,
            showCloseButton: showCloseButton,
            onClose: () => Navigator.of(context).pop(),
            child: child,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // 페이드 효과 없이 항상 불투명하게 유지
        return child;
      },
    );
  }

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag Handle
        if (widget.showDragHandle) _buildDragHandle(),

        // Header (Title + Close Button)
        if (widget.title != null || widget.showCloseButton)
          _buildHeader(context),

        // Content (스크롤 가능)
        Expanded(child: widget.child),
      ],
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(
          top: BottomSheetTokens.handleTopMargin,
          bottom: BottomSheetTokens.handleBottomMargin,
        ),
        width: BottomSheetTokens.handleWidth,
        height: BottomSheetTokens.handleHeight,
        decoration: BoxDecoration(
          color: AppColorScheme.grey500,
          borderRadius: BorderRadius.circular(
            BottomSheetTokens.handleHeight / 2,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: BottomSheetTokens.contentPadding,
        right: widget.showCloseButton ? 8 : BottomSheetTokens.contentPadding,
        top: widget.showDragHandle ? 8 : 16,
        bottom: 8,
      ),
      child: SizedBox(
        height: BottomSheetTokens.headerHeight,
        child: Row(
          children: [
            if (widget.title != null)
              Expanded(
                child: Text(
                  widget.title!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColorScheme.black100,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    height: 28 / 20,
                  ),
                ),
              ),
            if (widget.showCloseButton)
              Opacity(
                opacity: 0.2, // Figma 디자인 기준
                child: IconButton(
                  onPressed:
                      widget.onClose ?? () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AppColorScheme.black100,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: BottomSheetTokens.headerHeight,
                    minHeight: BottomSheetTokens.headerHeight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 애니메이션 백드롭이 적용된 Bottom Sheet 래퍼
///
/// 진입/퇴장 애니메이션과 드래그에 따른 백드롭 효과를 관리합니다.
class _AnimatedBackdropBottomSheet extends StatefulWidget {
  const _AnimatedBackdropBottomSheet({
    required this.animation,
    required this.child,
    required this.maxHeightRatio,
    required this.initialHeightRatio,
    required this.enableDrag,
    required this.isDismissible,
  });

  final Animation<double> animation;
  final Widget child;
  final double maxHeightRatio;
  final double initialHeightRatio;
  final bool enableDrag;
  final bool isDismissible;

  @override
  State<_AnimatedBackdropBottomSheet> createState() =>
      _AnimatedBackdropBottomSheetState();
}

class _AnimatedBackdropBottomSheetState
    extends State<_AnimatedBackdropBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _dragAnimationController;
  double _currentDragExtent = 1.0; // 1.0 = 완전히 열림, 0.0 = 완전히 닫힘
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _dragAnimationController = AnimationController(
      vsync: this,
      duration: BottomSheetTokens.animationDuration,
    );
  }

  @override
  void dispose() {
    _dragAnimationController.dispose();
    super.dispose();
  }

  /// 드래그 시작
  void _onVerticalDragStart(DragStartDetails details) {
    if (!widget.enableDrag) return;
    // 드래그 시작 시 애니메이션 리스너 정리
    _dragAnimationController.stop();
  }

  /// 드래그 중
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!widget.enableDrag || _isDismissing) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeight = screenHeight * widget.maxHeightRatio;

    // 드래그 델타를 extent 변화로 변환 (아래로 드래그하면 감소)
    final delta = -details.primaryDelta! / sheetHeight;
    final newExtent = (_currentDragExtent + delta).clamp(0.0, 1.0);

    setState(() {
      _currentDragExtent = newExtent;
    });
  }

  /// 드래그 종료
  void _onVerticalDragEnd(DragEndDetails details) {
    if (!widget.enableDrag || _isDismissing) return;

    final velocity = details.primaryVelocity ?? 0;

    // 빠른 스와이프로 닫기 (아래로 빠르게 스와이프, velocity > 0은 아래 방향)
    if (velocity > 700) {
      _dismissSheet();
      return;
    }

    // 빠른 스와이프로 복원 (위로 빠르게 스와이프, velocity < 0은 위 방향)
    if (velocity < -500) {
      _restoreSheet();
      return;
    }

    // 느린 드래그: 임계값 기준으로 닫기/복원 결정
    // 50% 이상 내려가면 닫고, 그렇지 않으면 복원
    if (_currentDragExtent < 0.5) {
      _dismissSheet();
    } else {
      _restoreSheet();
    }
  }

  /// Bottom sheet 닫기 애니메이션
  void _dismissSheet() {
    if (_isDismissing) return;
    _isDismissing = true;

    final startExtent = _currentDragExtent;
    _dragAnimationController.reset();

    _dragAnimationController.addListener(() {
      setState(() {
        _currentDragExtent =
            startExtent * (1.0 - _dragAnimationController.value);
      });
    });

    _dragAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pop();
      }
    });

    _dragAnimationController.forward();
  }

  /// Bottom sheet 원위치로 복원
  void _restoreSheet() {
    final startExtent = _currentDragExtent;
    _dragAnimationController.reset();

    _dragAnimationController.addListener(() {
      setState(() {
        _currentDragExtent =
            startExtent + (1.0 - startExtent) * _dragAnimationController.value;
      });
    });

    _dragAnimationController.forward();
  }

  void _handleBackdropTap() {
    if (widget.isDismissible && !_isDismissing) {
      _dismissSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetMaxHeight = screenHeight * widget.maxHeightRatio;

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, _) {
        // 진입 애니메이션에 curve 적용
        final curvedAnimProgress = BottomSheetTokens.animationCurve.transform(
          widget.animation.value,
        );
        // 부드러운 intensity 계산: 진입 애니메이션 * 드래그 상태
        final intensity = curvedAnimProgress * _currentDragExtent;

        // 슬라이드 오프셋 계산
        final slideOffset = 1.0 - (curvedAnimProgress * _currentDragExtent);

        return Stack(
          children: [
            // Backdrop: Dimming + Blur (화면 전체 - 고정)
            Positioned.fill(
              child: GestureDetector(
                onTap: _handleBackdropTap,
                behavior: HitTestBehavior.opaque,
                child: _AnimatedBackdrop(intensity: intensity),
              ),
            ),

            // Bottom Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(0, sheetMaxHeight * slideOffset),
                child: GestureDetector(
                  onVerticalDragStart: _onVerticalDragStart,
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  onVerticalDragEnd: _onVerticalDragEnd,
                  child: Container(
                    height: sheetMaxHeight,
                    decoration: const BoxDecoration(
                      color: AppColorScheme.white100,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(BottomSheetTokens.borderRadius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: BottomSheetTokens.shadowColor,
                          offset: BottomSheetTokens.shadowOffset,
                          blurRadius: BottomSheetTokens.shadowBlurRadius,
                        ),
                      ],
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 백드롭 위젯 (Dimming only)
///
/// intensity에 따라 dimming 효과가 적용됩니다.
class _AnimatedBackdrop extends StatelessWidget {
  const _AnimatedBackdrop({required this.intensity});

  final double intensity;
  @override
  Widget build(BuildContext context) {
    final clampedIntensity = intensity.clamp(0.0, 1.0);
    final currentDimOpacity =
        BottomSheetTokens.maxDimOpacity * clampedIntensity;

    return Container(
      color: AppColorScheme.black100.withValues(alpha: currentDimOpacity),
    );
  }
}
