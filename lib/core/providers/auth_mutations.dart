import 'package:flutter_riverpod/experimental/mutation.dart';

import '../domain/entity/auth_user_entity.dart';

/// Google 로그인 Mutation
///
/// 로그인 성공 시 AuthUserEntity 반환
final signInWithGoogleMutation = Mutation<AuthUserEntity>();

/// 로그아웃 Mutation
final signOutMutation = Mutation<void>();

/// 계정 전환 Mutation
///
/// 계정 전환 성공 시 새 AuthUserEntity 반환
final switchAccountMutation = Mutation<AuthUserEntity>();

/// 계정 삭제 Mutation
final deleteAccountMutation = Mutation<void>();
