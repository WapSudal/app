import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/user_role.dart';

part 'role_select_state.freezed.dart';

/// 역할 선택 화면 상태
///
/// Note: isLoading과 errorMessage는 confirmRoleMutation으로 분리됨
@freezed
abstract class RoleSelectState with _$RoleSelectState {
  const factory RoleSelectState({
    /// 현재 선택된 역할 (null이면 미선택)
    UserRole? selectedRole,
  }) = _RoleSelectState;
}
