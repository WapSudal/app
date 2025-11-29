import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user_role.dart';
import '../state/role_select_state.dart';

part 'role_select_provider.g.dart';

/// 역할 선택 화면 상태 관리 Provider
@riverpod
class RoleSelectNotifier extends _$RoleSelectNotifier {
  @override
  RoleSelectState build() => const RoleSelectState();

  /// 역할 선택
  void selectRole(UserRole role) {
    state = state.copyWith(selectedRole: role);
  }

  /// 역할 선택 확정 및 저장
  ///
  /// TODO: 로그인 연동 후 실제 API 호출로 대체
  Future<bool> confirmRole() async {
    final selectedRole = state.selectedRole;
    if (selectedRole == null) {
      state = state.copyWith(errorMessage: '역할을 선택해주세요');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // TODO: 실제 API 호출로 역할 저장
      // await ref.read(saveUserRoleUseCaseProvider)(role: selectedRole);

      // 임시: 성공 시뮬레이션
      await Future.delayed(const Duration(milliseconds: 300));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '역할 저장에 실패했습니다: $e',
      );
      return false;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
