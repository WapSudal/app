import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/user_role.dart';
import '../state/role_select_state.dart';

part 'role_select_notifier.g.dart';

/// 역할 선택 화면 상태 관리 Provider
///
/// Note: 역할 확정(가입) 작업은 confirmRoleMutation으로 분리됨
/// - UI에서 confirmRoleMutation의 상태를 watch하여 로딩/에러 처리
@riverpod
class RoleSelectNotifier extends _$RoleSelectNotifier {
  @override
  RoleSelectState build() => const RoleSelectState();

  /// 역할 선택
  void selectRole(UserRole role) {
    state = state.copyWith(selectedRole: role);
  }
}
