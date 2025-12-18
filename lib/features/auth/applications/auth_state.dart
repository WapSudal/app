import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/entities/auth_user_entity.dart';

part 'auth_state.freezed.dart';

/// 인증 상태
///
/// Note: isLoading과 errorMessage는 Mutations로 분리됨
/// - signInWithGoogleMutation: Google 로그인 상태
/// - signOutMutation: 로그아웃 상태
/// - switchAccountMutation: 계정 전환 상태
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    /// 현재 로그인된 사용자 정보 (없으면 null)
    AuthUserEntity? user,
  }) = _AuthState;
}

// ==================== Extensions ====================

extension AuthStateX on AuthState {
  /// 로그인 여부
  bool get isAuthenticated => user != null;

  /// 사용자 표시 이름 (없으면 '사용자')
  String get displayName => user?.displayName ?? '사용자';

  /// 사용자 이메일 (없으면 빈 문자열)
  String get email => user?.email ?? '';

  /// 사용자 프로필 이미지 URL
  String? get photoUrl => user?.photoUrl;
}
