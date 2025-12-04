import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/auth_data_providers.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../state/auth_state.dart';

part 'auth_notifier.g.dart';

/// 인증 상태 관리 Notifier
///
/// Note: 로그인/로그아웃/계정전환 작업은 Mutations로 분리됨
/// - signInWithGoogleMutation, signOutMutation, switchAccountMutation 참조
/// - UI에서 Mutations의 상태(MutationPending, MutationSuccess, MutationError)를 watch하여 처리
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    // build() 완료 후 비동기 초기화 실행
    Future.microtask(_initializeAuthState);
    return const AuthState();
  }

  /// 초기 인증 상태 확인
  Future<void> _initializeAuthState() async {
    try {
      final repository = ref.read(authRepositoryProvider);
      final currentUser = await repository.getCurrentUser();

      if (currentUser != null) {
        state = state.copyWith(user: currentUser);
      }
    } catch (e) {
      // 초기화 실패 시 로그아웃 상태 유지
    }
  }

  /// 사용자 정보 업데이트 (Mutation 콜백에서 호출)
  void updateUser(AuthUserEntity? user) {
    state = state.copyWith(user: user);
  }

  /// 사용자 정보 초기화 (로그아웃 시 호출)
  void clearUser() {
    state = const AuthState();
  }
}

/// 인증 여부 Provider (편의용)
@Riverpod(keepAlive: true)
bool isAuthenticated(Ref ref) {
  return ref.watch(authProvider).isAuthenticated;
}

/// 현재 사용자 Provider (편의용)
@Riverpod(keepAlive: true)
AuthUserEntity? currentUser(Ref ref) {
  return ref.watch(authProvider).user;
}
