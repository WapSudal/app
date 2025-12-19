import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/entities/user_entity.dart';
import '../data/providers/auth_data_providers.dart';
import 'registered_user_state.dart';

part 'registered_user_notifier.g.dart';

/// 등록된(가입 완료된) 사용자 상태 관리 Provider
///
/// 앱 전역에서 서버 가입 완료된 사용자 정보를 관리
/// - 앱 시작 시 저장된 사용자 정보 로드
/// - 역할 선택(가입) 완료 시 사용자 정보 저장 → confirmRoleMutation 사용
/// - 로그아웃 시 사용자 정보 초기화 → signOutMutation 사용
///
/// Note: 가입/등록 작업의 로딩/에러 상태는 Mutations로 분리됨
@Riverpod(keepAlive: true)
class RegisteredUser extends _$RegisteredUser {
  @override
  RegisteredUserState build() {
    // build() 완료 후 비동기 초기화 실행
    Future.microtask(_initializeUser);
    return const RegisteredUserState();
  }

  /// 초기 사용자 정보 로드
  Future<void> _initializeUser() async {
    try {
      final repository = ref.read(userRepositoryProvider);

      final user = await repository.getCurrentUser();

      state = state.copyWith(user: user, isInitializing: false);
    } catch (e) {
      state = state.copyWith(isInitializing: false);
    }
  }

  /// 사용자 정보 업데이트 (Mutation 콜백에서 호출)
  void updateUser(UserEntity user) {
    state = state.copyWith(user: user, isInitializing: false);
  }

  /// 사용자 정보 새로고침
  Future<void> refresh() async {
    try {
      final repository = ref.read(userRepositoryProvider);
      final user = await repository.getCurrentUser();

      state = state.copyWith(user: user);
    } catch (e) {
      // 새로고침 실패 시 기존 상태 유지
    }
  }

  /// 사용자 상태 초기화 (로그아웃 시 호출)
  ///
  /// 로컬 데이터는 보존하고 메모리 상의 상태만 초기화
  void resetState() {
    state = const RegisteredUserState(isInitializing: false);
  }

  /// 사용자 정보 초기화 (로컬 데이터 삭제 포함)
  Future<void> clear() async {
    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.clearUserData();

      state = const RegisteredUserState(isInitializing: false);
    } catch (e) {
      // 초기화 실패해도 상태는 초기화
      state = const RegisteredUserState(isInitializing: false);
    }
  }
}

// ==================== Convenience Providers ====================

/// 가입 완료 여부 Provider
///
/// Router redirect에서 사용
@Riverpod(keepAlive: true)
bool isUserRegistered(Ref ref) {
  return ref.watch(registeredUserProvider).isRegistered;
}
