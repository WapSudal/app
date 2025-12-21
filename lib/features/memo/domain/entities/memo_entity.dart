import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo_entity.freezed.dart';

@freezed
abstract class MemoEntity with _$MemoEntity {
  const factory MemoEntity({
    required String id,
    required String patientEmail,
    required String content,
    required DateTime createdAt,
  }) = _MemoEntity;
}
