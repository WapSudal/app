import '../../gen/assets.gen.dart';

// ==================== 공통 인터페이스 ====================

/// Navigation Tab 공통 인터페이스
///
/// 역할별 NavTab enum이 구현해야 하는 공통 속성 정의
abstract class BaseNavTab {
  /// 탭 레이블 (한국어)
  String get label;

  /// 라우트 경로
  String get path;

  /// 아이콘 에셋
  SvgGenImage get icon;

  /// 인덱스
  int get index;
}

// ==================== 일반 사용자 (Patient) ====================

/// Navigation tab enum for bottom navigation bar
///
/// 일반 사용자(환자) 전용 - 5개 탭
enum PatientNavTab implements BaseNavTab {
  home,
  record,
  analysis,
  explore,
  profile;

  @override
  String get label {
    switch (this) {
      case PatientNavTab.home:
        return '홈';
      case PatientNavTab.record:
        return '기록';
      case PatientNavTab.analysis:
        return '분석';
      case PatientNavTab.explore:
        return '탐색';
      case PatientNavTab.profile:
        return '프로필';
    }
  }

  @override
  String get path {
    switch (this) {
      case PatientNavTab.home:
        return '/home';
      case PatientNavTab.record:
        return '/record';
      case PatientNavTab.analysis:
        return '/analysis';
      case PatientNavTab.explore:
        return '/explore';
      case PatientNavTab.profile:
        return '/profile';
    }
  }

  @override
  SvgGenImage get icon {
    switch (this) {
      case PatientNavTab.home:
        return Assets.icons.home;
      case PatientNavTab.record:
        return Assets.icons.heartRate;
      case PatientNavTab.analysis:
        return Assets.icons.data;
      case PatientNavTab.explore:
        return Assets.icons.compass;
      case PatientNavTab.profile:
        return Assets.icons.person;
    }
  }

  static PatientNavTab fromIndex(int index) {
    return PatientNavTab.values[index];
  }
}

// ==================== 보호자 (Guardian) ====================

/// Guardian 전용 Navigation Tab
///
/// 보호자 역할 전용 - 4개 탭 (홈, 내 환자, 탐색, 전체)
enum GuardianNavTab implements BaseNavTab {
  home,
  patients,
  explore,
  profile;

  @override
  String get label {
    switch (this) {
      case GuardianNavTab.home:
        return '홈';
      case GuardianNavTab.patients:
        return '내 환자';
      case GuardianNavTab.explore:
        return '탐색';
      case GuardianNavTab.profile:
        return '프로필';
    }
  }

  @override
  String get path {
    switch (this) {
      case GuardianNavTab.home:
        return '/home';
      case GuardianNavTab.patients:
        return '/patients';
      case GuardianNavTab.explore:
        return '/explore';
      case GuardianNavTab.profile:
        return '/profile';
    }
  }

  @override
  SvgGenImage get icon {
    switch (this) {
      case GuardianNavTab.home:
        return Assets.icons.home;
      case GuardianNavTab.patients:
        return Assets.icons.person;
      case GuardianNavTab.explore:
        return Assets.icons.compass;
      case GuardianNavTab.profile:
        return Assets.icons.person;
    }
  }

  static GuardianNavTab fromIndex(int index) {
    return GuardianNavTab.values[index];
  }
}

// ==================== 주치의 (Doctor) ====================

/// Doctor 전용 Navigation Tab
///
/// 주치의 역할 전용 - 4개 탭 (홈, 내 환자, 탐색, 전체)
/// Guardian과 동일한 구조이지만, 향후 확장성을 위해 별도 enum으로 분리
enum DoctorNavTab implements BaseNavTab {
  home,
  patients,
  explore,
  profile;

  @override
  String get label {
    switch (this) {
      case DoctorNavTab.home:
        return '홈';
      case DoctorNavTab.patients:
        return '내 환자';
      case DoctorNavTab.explore:
        return '탐색';
      case DoctorNavTab.profile:
        return '프로필';
    }
  }

  @override
  String get path {
    switch (this) {
      case DoctorNavTab.home:
        return '/home';
      case DoctorNavTab.patients:
        return '/patients';
      case DoctorNavTab.explore:
        return '/explore';
      case DoctorNavTab.profile:
        return '/profile';
    }
  }

  @override
  SvgGenImage get icon {
    switch (this) {
      case DoctorNavTab.home:
        return Assets.icons.home;
      case DoctorNavTab.patients:
        return Assets.icons.person;
      case DoctorNavTab.explore:
        return Assets.icons.compass;
      case DoctorNavTab.profile:
        return Assets.icons.person;
    }
  }

  static DoctorNavTab fromIndex(int index) {
    return DoctorNavTab.values[index];
  }
}
