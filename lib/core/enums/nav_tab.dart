import '../../gen/assets.gen.dart';

/// Navigation tab enum for bottom navigation bar
///
/// Only used for general users
enum NavTab {
  home,
  record,
  analysis,
  explore,
  profile,
}

extension NavTabExtension on NavTab {
  /// Display name for the tab (Korean)
  String get label {
    switch (this) {
      case NavTab.home:
        return '홈';
      case NavTab.record:
        return '기록';
      case NavTab.analysis:
        return '분석';
      case NavTab.explore:
        return '탐색';
      case NavTab.profile:
        return '프로필';
    }
  }

  /// Route path for the tab
  String get path {
    switch (this) {
      case NavTab.home:
        return '/home';
      case NavTab.record:
        return '/record';
      case NavTab.analysis:
        return '/analysis';
      case NavTab.explore:
        return '/explore';
      case NavTab.profile:
        return '/profile';
    }
  }

  /// Icon asset for the tab
  SvgGenImage get icon {
    switch (this) {
      case NavTab.home:
        return Assets.icons.home;
      case NavTab.record:
        return Assets.icons.heartRate;
      case NavTab.analysis:
        return Assets.icons.data;
      case NavTab.explore:
        return Assets.icons.compass;
      case NavTab.profile:
        return Assets.icons.more;
    }
  }

  /// Get tab from index (for bottom nav)
  static NavTab fromIndex(int index) {
    return NavTab.values[index];
  }
}
