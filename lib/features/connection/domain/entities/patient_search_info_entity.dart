import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_search_info_entity.freezed.dart';

/// 환자 검색 정보 Entity
///
/// 보호자/주치의가 환자에게 연결 요청 시 제공하는 정보
@freezed
abstract class PatientSearchInfoEntity with _$PatientSearchInfoEntity {
  const factory PatientSearchInfoEntity({
    /// 환자 이름
    required String name,

    /// 환자 생년월일
    required DateTime birthDate,

    /// 환자 이메일
    required String email,
  }) = _PatientSearchInfoEntity;

  const PatientSearchInfoEntity._();

  /// 생년월일을 YYYY-MM-DD 형식으로 반환
  String get birthDateString {
    return '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}';
  }

  /// 나이 계산 (만 나이)
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// 검색을 위한 정규화된 이메일 (소문자, 공백 제거)
  String get normalizedEmail => email.trim().toLowerCase();

  /// 검색을 위한 정규화된 이름 (공백 제거)
  String get normalizedName => name.trim().replaceAll(' ', '');
}
