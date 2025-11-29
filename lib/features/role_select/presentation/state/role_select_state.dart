import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_role.dart';

part 'role_select_state.freezed.dart';

/// 역할 선택 화면 상태
@freezed
abstract class RoleSelectState with _$RoleSelectState {
  const factory RoleSelectState({
    /// 현재 선택된 역할 (null이면 미선택)
    UserRole? selectedRole,

    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 에러 메시지
    String? errorMessage,
  }) = _RoleSelectState;
}
