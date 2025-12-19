import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/enums/sharing_scope.dart';
import 'patients_state.dart';

part 'patients_notifier.g.dart';

/// 환자 목록 화면 상태 관리 Provider
///
/// Guardian/Doctor가 관리하는 환자 목록을 로드하고 관리합니다.
@riverpod
class PatientsNotifier extends _$PatientsNotifier {
  @override
  Future<PatientsState> build() async {
    final patients = <UserEntity>[];
    return PatientsState(patients: patients);
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
