import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/connection_local_datasource.dart';
import '../repositories/connection_repository_impl.dart';
import '../../domain/repositories/connection_repository.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import '../../domain/usecases/get_pending_requests_usecase.dart';
import '../../domain/usecases/accept_connection_usecase.dart';
import '../../domain/usecases/reject_connection_usecase.dart';
import '../../domain/usecases/get_my_connections_usecase.dart';
import '../../domain/usecases/revoke_connection_usecase.dart';
import '../../../../core/providers/shared_preferences_provider.dart';

part 'connection_providers.g.dart';

// ==================== DataSource ====================

/// Connection LocalDataSource Provider (Singleton)
@Riverpod(keepAlive: true)
ConnectionLocalDataSource connectionLocalDataSource(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ConnectionLocalDataSource(prefs);
}

// ==================== Repository ====================

/// Connection Repository Provider
@riverpod
ConnectionRepository connectionRepository(Ref ref) {
  final localDataSource = ref.watch(connectionLocalDataSourceProvider);

  return ConnectionRepositoryImpl(
    localDataSource: localDataSource,
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

// ==================== UseCases ====================

/// Send Connection Request UseCase Provider
@riverpod
SendConnectionRequestUseCase sendConnectionRequestUseCase(Ref ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  return SendConnectionRequestUseCase(repository);
}

/// Get Pending Requests UseCase Provider
@riverpod
GetPendingRequestsUseCase getPendingRequestsUseCase(Ref ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  return GetPendingRequestsUseCase(repository);
}

/// Accept Connection UseCase Provider
@riverpod
AcceptConnectionUseCase acceptConnectionUseCase(Ref ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  return AcceptConnectionUseCase(repository);
}

/// Reject Connection UseCase Provider
@riverpod
RejectConnectionUseCase rejectConnectionUseCase(Ref ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  return RejectConnectionUseCase(repository);
}

/// Get My Connections UseCase Provider
@riverpod
GetMyConnectionsUseCase getMyConnectionsUseCase(Ref ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  return GetMyConnectionsUseCase(repository);
}

/// Revoke Connection UseCase Provider
@riverpod
RevokeConnectionUseCase revokeConnectionUseCase(Ref ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  return RevokeConnectionUseCase(repository);
}
