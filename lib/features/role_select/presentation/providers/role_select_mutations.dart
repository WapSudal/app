import 'package:flutter_riverpod/experimental/mutation.dart';

import '../../../../core/domain/entity/user_entity.dart';

/// 역할 선택 및 가입 완료 Mutation
///
/// 가입 성공 시 UserEntity 반환
final confirmRoleMutation = Mutation<UserEntity>();
