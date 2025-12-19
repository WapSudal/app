import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../domain/repositories/connection_repository.dart';
import '../datasources/connection_local_datasource.dart';
import '../datasources/connection_local_datasource_impl.dart';
import '../repositories/connection_repository_impl.dart';

part 'connection_data_providers.g.dart';

@Riverpod(keepAlive: true)
ConnectionLocalDataSource connectionLocalDataSource(Ref ref) {
  return ConnectionLocalDataSourceImpl(
    prefs: ref.watch(sharedPreferencesProvider),
    getCurrentUserEmail: () {
      // Firebase Auth에서 현재 사용자 ID 가져오기
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      return user.email!;
    },
  );
}

@Riverpod(keepAlive: true)
ConnectionRepository connectionRepository(Ref ref) {
  return ConnectionRepositoryImpl(
    localDataSource: ref.watch(connectionLocalDataSourceProvider),
  );
}
