import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
part 'patients_manage_state.freezed.dart';

@freezed
abstract class PatientsManageState with _$PatientsManageState {
  const factory PatientsManageState({
    @Default([]) List<UserEntity> pendingPatients,
  }) = _PatientsManageState;
}
