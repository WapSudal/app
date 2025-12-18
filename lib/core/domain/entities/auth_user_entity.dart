import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_entity.freezed.dart';

/// 인증된 사용자 정보 Entity
@freezed
abstract class AuthUserEntity with _$AuthUserEntity {
  const factory AuthUserEntity({
    /// Firebase UID
    required String uid,

    /// 표시 이름 (Google 계정 이름)
    String? displayName,

    /// 이메일 주소
    String? email,

    /// 프로필 이미지 URL
    String? photoUrl,
  }) = _AuthUserEntity;
}
