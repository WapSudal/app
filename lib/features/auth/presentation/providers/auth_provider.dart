import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/providers/auth_data_providers.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../state/auth_state.dart';

part 'auth_provider.g.dart';

/// 인증 상태 관리 Notifier
///
/// 로그인, 로그아웃, 계정 전환 기능 제공
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    // 앱 시작 시 현재 로그인 상태 확인
    _initializeAuthState();
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

  /// Google 계정으로 로그인
  ///
  /// 성공 시 true 반환, 실패 시 false 반환 및 errorMessage 설정
  Future<bool> signInWithGoogle() async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithGoogle();

      state = state.copyWith(user: user, isLoading: false);

      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 로그아웃
  ///
  /// 성공 시 true 반환, 실패 시 false 반환
  Future<bool> signOut() async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();

      state = const AuthState();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그아웃 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 계정 전환
  ///
  /// 기존 계정 로그아웃 후 Google 계정 선택 UI 표시
  /// 성공 시 true 반환, 실패 시 false 반환
  Future<bool> switchAccount() async {
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.switchAccount();

      state = state.copyWith(user: user, isLoading: false);

      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '계정 전환 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
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
