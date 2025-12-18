import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../datasources/health_record_local_datasource.dart';

part 'health_record_datasource_provider.g.dart';

@Riverpod(keepAlive: true)
HealthRecordLocalDataSource healthRecordLocalDataSource(Ref ref) {
  return HealthRecordLocalDataSource(
    prefs: ref.watch(sharedPreferencesProvider),
  );
}
