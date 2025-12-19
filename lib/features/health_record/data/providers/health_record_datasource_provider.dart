import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../datasources/health_record_local_datasource_impl.dart';

part 'health_record_datasource_provider.g.dart';

@Riverpod(keepAlive: true)
HealthRecordLocalDataSourceImpl healthRecordLocalDataSource(Ref ref) {
  return HealthRecordLocalDataSourceImpl(
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
