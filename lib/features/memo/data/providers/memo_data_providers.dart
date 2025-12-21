import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../connection/data/providers/connection_data_providers.dart';
import '../../domain/repositories/memo_repository.dart';
import '../datasources/memo_local_datasource.dart';
import '../datasources/memo_local_datasource_impl.dart';
import '../repositories/memo_repository_impl.dart';

part 'memo_data_providers.g.dart';

@Riverpod(keepAlive: true)
MemoLocalDataSource memoLocalDataSource(Ref ref) {
  return MemoLocalDataSourceImpl(prefs: ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
MemoRepository memoRepository(Ref ref) {
  return MemoRepositoryImpl(
    dataSource: ref.watch(memoLocalDataSourceProvider),
    connectionRepository: ref.watch(connectionRepositoryProvider),
  );
}
