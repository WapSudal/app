import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/entities/user_entity.dart';
part 'caregiver_request_list_state.freezed.dart';

@freezed
abstract class CaregiverRequestListState with _$CaregiverRequestListState {
  const factory CaregiverRequestListState({
    @Default([]) List<UserEntity> pendingCaregivers,
  }) = _CaregiverRequestListState;
}
