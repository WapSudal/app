import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/memo_entity.dart';
part 'memo_state.freezed.dart';

@freezed
abstract class MemoState with _$MemoState {
  const factory MemoState({@Default([]) List<MemoEntity> memos}) = _MemoState;
}
