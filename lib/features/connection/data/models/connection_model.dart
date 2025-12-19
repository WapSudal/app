import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/connection_entity.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/sharing_scope.dart';

part 'connection_model.freezed.dart';
part 'connection_model.g.dart';

/// 연결 Model (API 응답용)
@freezed
abstract class ConnectionModel with _$ConnectionModel {
  const factory ConnectionModel({
    required String id,
    required String patientEmail,
    required String connectorEmail,
    required ConnectionType type,
    required ConnectionStatus status,
    required SharingScope scope,
    required DateTime requestedAt,
  }) = _ConnectionModel;

  factory ConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectionModelFromJson(json);
}

/// ConnectionModel 확장 메서드
extension ConnectionModelX on ConnectionModel {
  /// Model을 Entity로 변환
  ConnectionEntity toEntity() {
    return ConnectionEntity(
      id: id,
      patientEmail: patientEmail,
      connectorEmail: connectorEmail,
      type: type,
      status: status,
      scope: scope,
      requestedAt: requestedAt,
    );
  }
}
