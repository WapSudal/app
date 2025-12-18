import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/auth_data_providers.dart';
import '../usecases/check_registration_usecase.dart';
import '../usecases/clear_user_data_usecase.dart';
import '../usecases/get_current_user_usecase.dart';
import '../usecases/register_user_usecase.dart';

part 'auth_domain_providers.g.dart';

// ==================== UseCase Providers ====================

/// 사용자 가입 UseCase Provider
@Riverpod(keepAlive: true)
RegisterUserUseCase registerUserUseCase(Ref ref) {
  return RegisterUserUseCase(ref.watch(userRepositoryProvider));
}

/// 현재 사용자 조회 UseCase Provider
@Riverpod(keepAlive: true)
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.watch(userRepositoryProvider));
}

/// 가입 여부 확인 UseCase Provider
@Riverpod(keepAlive: true)
CheckRegistrationUseCase checkRegistrationUseCase(Ref ref) {
  return CheckRegistrationUseCase(ref.watch(userRepositoryProvider));
}

/// 사용자 데이터 초기화 UseCase Provider
@Riverpod(keepAlive: true)
ClearUserDataUseCase clearUserDataUseCase(Ref ref) {
  return ClearUserDataUseCase(ref.watch(userRepositoryProvider));
}
