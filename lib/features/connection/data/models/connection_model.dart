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
    required String patientId,
    required String connectorId,
    required ConnectionType type,
    required ConnectionStatus status,
    required SharingScope scope,
    required DateTime requestedAt,
    DateTime? respondedAt,
    DateTime? revokedAt,
    required String connectorName,
    String? connectorEmail,
    required String patientName,
    String? patientEmail,
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
      patientId: patientId,
      connectorId: connectorId,
      type: type,
      status: status,
      scope: scope,
      requestedAt: requestedAt,
      respondedAt: respondedAt,
      revokedAt: revokedAt,
      connectorName: connectorName,
      connectorEmail: connectorEmail,
      patientName: patientName,
      patientEmail: patientEmail,
    );
  }

  /// Entity를 Model로 변환 (정적 메서드)
  static ConnectionModel fromEntity(ConnectionEntity entity) {
    return ConnectionModel(
      id: entity.id,
      patientId: entity.patientId,
      connectorId: entity.connectorId,
      type: entity.type,
      status: entity.status,
      scope: entity.scope,
      requestedAt: entity.requestedAt,
      respondedAt: entity.respondedAt,
      revokedAt: entity.revokedAt,
      connectorName: entity.connectorName,
      connectorEmail: entity.connectorEmail,
      patientName: entity.patientName,
      patientEmail: entity.patientEmail,
    );
  }
}
