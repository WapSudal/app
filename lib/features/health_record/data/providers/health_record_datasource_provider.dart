import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../datasources/health_record_local_datasource.dart';
import '../../../user/data/providers/user_data_providers.dart';

part 'health_record_datasource_provider.g.dart';

@Riverpod(keepAlive: true)
HealthRecordLocalDataSource healthRecordLocalDataSource(Ref ref) {
  return HealthRecordLocalDataSource(
    prefs: ref.watch(sharedPreferencesProvider),
  );
}
