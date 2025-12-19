import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/connection_local_datasource.dart';
import '../repositories/connection_repository_impl.dart';
import '../../domain/repositories/connection_repository.dart';

import '../../../../core/providers/shared_preferences_provider.dart';

part 'connection_providers.g.dart';

@Riverpod(keepAlive: true)
ConnectionLocalDataSource connectionLocalDataSource(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ConnectionLocalDataSource(prefs);
}

@Riverpod(keepAlive: true)
ConnectionRepository connectionRepository(Ref ref) {
  final localDataSource = ref.watch(connectionLocalDataSourceProvider);

  return ConnectionRepositoryImpl(
    localDataSource: localDataSource,
    // TODO: 현재 사용자 id를 전역 provider 에서 가져오도록 수정 필요
    getCurrentUserId: () {
      // Firebase Auth에서 현재 사용자 ID 가져오기
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      return user.uid;
    },
  );
}
