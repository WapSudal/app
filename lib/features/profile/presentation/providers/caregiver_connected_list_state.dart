import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
part 'caregiver_connected_list_state.freezed.dart';

@freezed
abstract class CaregiverConnectedListState with _$CaregiverConnectedListState {
  const factory CaregiverConnectedListState({
    @Default([]) List<UserEntity> connectedCaregivers,
  }) = _CaregiverConnectedListState;
}
