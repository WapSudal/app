import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../gen/assets.gen.dart';
import '../../theme/color_scheme.dart';
import 'app_icon.dart';

/// 재사용 가능한 커스텀 AppBar 위젯
///
/// 기본적으로 뒤로가기 버튼과 타이틀을 포함하며,
/// 프로젝트의 디자인 시스템을 따릅니다.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// AppBar에 표시될 타이틀
  final String title;

  /// 뒤로가기 버튼 클릭 시 호출될 콜백
  /// null인 경우 기본적으로 context.pop()을 호출합니다.
  final VoidCallback? onBackPressed;

  const CustomAppBar({super.key, required this.title, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: AppColorScheme.white100,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: AppIcon(
          Assets.icons.left,
          color: AppColorScheme.black100,
          size: 24,
        ),
        onPressed: onBackPressed ?? () => context.pop(),
      ),
      title: Text(title, style: theme.textTheme.headlineMedium),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
