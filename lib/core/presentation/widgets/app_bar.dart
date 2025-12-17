import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../gen/assets.gen.dart';
import '../../../features/notification/presentation/widgets/notification_bottom_sheet_content.dart';
import '../../theme/color_scheme.dart';
import 'app_bottom_sheet.dart';
import 'app_icon.dart';

/// AppBar 모드
enum AppBarMode {
  /// 네비게이션 모드: 타이틀/로고 + 알림 버튼
  navigation,

  /// 서브페이지 모드: 뒤로가기 + 타이틀
  subpage,
}

/// 재사용 가능한 커스텀 AppBar 위젯
///
/// 두 가지 모드를 지원합니다:
/// - navigation: 타이틀/로고 + 알림 버튼 (메인 네비게이션용)
/// - subpage: 뒤로가기 버튼 + 타이틀 (하위 페이지용)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// AppBar 모드 (필수)
  final AppBarMode mode;

  /// 타이틀 텍스트 (선택적, customTitle과 배타적)
  final String? title;

  /// 커스텀 타이틀 위젯 (선택적, title과 배타적)
  /// 예: 홈 화면의 로고
  final Widget? customTitle;

  /// 배경색 (선택적, null이면 mode에 따라 자동 선택)
  /// - navigation: Color(0xFFF7F6FB)
  /// - subpage: AppColorScheme.white100
  final Color? backgroundColor;

  /// 알림 버튼 표시 여부 (navigation 모드에서만 유효)
  /// 기본값: true
  final bool showNotificationButton;

  /// 뒤로가기 버튼 클릭 시 콜백 (subpage 모드에서만 유효)
  /// null이면 기본적으로 context.pop() 호출
  final VoidCallback? onBackPressed;

  /// 알림 버튼 클릭 시 추가 동작 (navigation 모드에서만 유효)
  /// null이면 기본 알림 BottomSheet 표시
  final VoidCallback? onNotificationPressed;

  const CustomAppBar({
    super.key,
    required this.mode,
    this.title,
    this.customTitle,
    this.backgroundColor,
    this.showNotificationButton = true,
    this.onBackPressed,
    this.onNotificationPressed,
  }) : assert(
         title == null || customTitle == null,
         'title과 customTitle은 동시에 사용할 수 없습니다.',
       ),
       assert(
         title != null || customTitle != null,
         'title 또는 customTitle 중 하나는 반드시 제공해야 합니다.',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      leading: _buildLeading(context),
      title: _buildTitle(theme),
      titleSpacing: mode == AppBarMode.navigation ? null : 0,
      actions: _buildActions(context),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (mode == AppBarMode.subpage) {
      return IconButton(
        icon: AppIcon(
          Assets.icons.left,
          color: AppColorScheme.black100,
          size: 24,
        ),
        onPressed: onBackPressed ?? () => context.pop(),
      );
    }
    return null;
  }

  Widget _buildTitle(ThemeData theme) {
    if (customTitle != null) {
      return customTitle!;
    }
    return Text(title!, style: theme.textTheme.headlineMedium);
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (mode == AppBarMode.navigation && showNotificationButton) {
      return [
        IconButton(
          icon: Assets.icons.alarm.svg(
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColorScheme.black100,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            if (onNotificationPressed != null) {
              onNotificationPressed!();
            } else {
              _showNotificationBottomSheet(context);
            }
          },
        ),
        const SizedBox(width: 8),
      ];
    }
    return null;
  }

  void _showNotificationBottomSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: '알림',
      maxHeightRatio: 0.6,
      child: const NotificationBottomSheetContent(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
