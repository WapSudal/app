import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user_entity.dart';

part 'auth_state.freezed.dart';

/// 인증 상태
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    /// 현재 로그인된 사용자 정보 (없으면 null)
    AuthUserEntity? user,

    /// 로딩 중 여부 (로그인/로그아웃/계정전환 작업 중)
    @Default(false) bool isLoading,

    /// 에러 메시지 (있으면 표시 후 null로 초기화)
    String? errorMessage,
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
