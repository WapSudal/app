import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';
import '../repositories/notification_repository_impl.dart';

part 'notification_data_providers.g.dart';

/// Notification Local DataSource Provider
@riverpod
NotificationLocalDataSource notificationLocalDataSource(Ref ref) {
  return NotificationLocalDataSourceImpl();
}

/// Notification Repository Provider
@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepositoryImpl(
    localDataSource: ref.watch(notificationLocalDataSourceProvider),
  );
}
