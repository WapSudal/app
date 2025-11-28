/// Form Field 위젯 공통 디자인 토큰
///
/// 이 파일은 AppOutlinedTextField, AppLinedTextField,
/// AppOutlinedDropdown, AppLinedDropdown에서 사용되는
/// 공통 디자인 토큰을 정의합니다.
///
/// 참고: 폰트 사이즈는 Theme.of(context).textTheme에서 가져와 사용합니다.
library;

/// 공통 크기/패딩/테두리 토큰
abstract class FormFieldTokens {
  FormFieldTokens._();

  // ===== 기본 높이 =====

  /// 폼 필드 기본 높이: 50px
  static const double height = 50.0;

  // ===== 테두리 =====

  /// 테두리 두께: BW2 (1.5px)
  static const double strokeWidth = 1.5;

  /// Outlined 스타일 모서리 둥글기: BR2 (8px)
  static const double outlinedBorderRadius = 8.0;

  // ===== 패딩 =====

  /// Outlined 스타일 수평 패딩: G4 (16px)
  static const double outlinedHorizontalPadding = 16.0;

  // ===== Clear 버튼 =====

  /// Clear 버튼 크기: 28px
  static const double clearButtonSize = 28.0;

  // ===== Floating Label 오프셋 =====

  /// Outlined 스타일 플로팅 라벨 수직 오프셋: -24px
  static const double outlinedLabelVerticalOffset = -24.0;

  /// Lined 스타일 플로팅 라벨 수직 오프셋: -26px
  static const double linedLabelVerticalOffset = -26.0;

  // ===== 애니메이션 =====

  /// 애니메이션 지속 시간: 150ms
  static const Duration animationDuration = Duration(milliseconds: 150);
}

/// 드롭다운 메뉴 토큰
abstract class DropdownMenuTokens {
  DropdownMenuTokens._();

  /// 메뉴 아이템 높이: 40px
  static const double menuItemHeight = 40.0;

  /// 메뉴 마진: G2 (8px)
  static const double menuMargin = 8.0;

  /// 메뉴 패딩: G2 (8px)
  static const double menuPadding = 8.0;

  /// 메뉴 모서리 둥글기: BR3 (12px)
  static const double menuBorderRadius = 12.0;

  /// 메뉴 아이템 수평 패딩: G3 (12px)
  static const double menuItemHorizontalPadding = 12.0;

  /// 메뉴 아이템 모서리 둥글기: BR1 (4px)
  static const double menuItemBorderRadius = 4.0;
}
