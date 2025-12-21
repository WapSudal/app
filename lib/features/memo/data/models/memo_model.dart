import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/memo_entity.dart';

part 'memo_model.freezed.dart';
part 'memo_model.g.dart';

@freezed
abstract class MemoModel with _$MemoModel {
  const factory MemoModel({
    required String id,
    required String patientEmail,
    required String content,
    required String createdAt,
  }) = _MemoModel;

  factory MemoModel.fromJson(Map<String, dynamic> json) =>
      _$MemoModelFromJson(json);
}

// ==================== Extensions ====================
extension MemoModelX on MemoModel {
  MemoEntity toEntity() {
    return MemoEntity(
      id: id,
      patientEmail: patientEmail,
      content: content,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
