import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../models/connection_model.dart';
import 'connection_local_datasource.dart';

abstract class _ConnectionStorageKeys {
  static const String connections = 'connections';
}

class ConnectionLocalDataSourceImpl implements ConnectionLocalDataSource {
  final SharedPreferences _prefs;
  final String Function() _getCurrentUserEmail;

  ConnectionLocalDataSourceImpl({
    required SharedPreferences prefs,
    required String Function() getCurrentUserEmail,
  }) : _prefs = prefs,
       _getCurrentUserEmail = getCurrentUserEmail;

  @override
  Future<ConnectionModel> requestConnection({
    required String targetPatientEmail,
    required SharingScope scope,
  }) async {
    final email = _getCurrentUserEmail();

    final newConnection = ConnectionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientEmail: targetPatientEmail,
      connectorEmail: email,
      type: ConnectionType.guardian,
      status: ConnectionStatus.pending,
      scope: scope,
      requestedAt: DateTime.now(),
    );

    final connections = await getCurrentConnections();

    if (connections.any(
      (c) =>
          c.patientEmail == targetPatientEmail &&
          c.connectorEmail == email &&
          (c.status == ConnectionStatus.pending ||
              c.status == ConnectionStatus.accepted),
    )) {
      throw Exception('이미 연결 요청이 존재합니다.');
    }

    connections.add(newConnection);
    final jsonString = jsonEncode(connections.map((c) => c.toJson()).toList());
    await _prefs.setString(_ConnectionStorageKeys.connections, jsonString);

    return newConnection;
  }

  @override
  Future<List<ConnectionModel>> getCurrentConnections({
    ConnectionType? type,
    ConnectionStatus? status,
  }) async {
    final email = _getCurrentUserEmail();
    final jsonString = _prefs.getString(_ConnectionStorageKeys.connections);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final connections = jsonList
          .map((json) => ConnectionModel.fromJson(json as Map<String, dynamic>))
          .where(
            (connection) =>
                (connection.patientEmail == email ||
                    connection.connectorEmail == email) &&
                (type == null || connection.type == type) &&
                (status == null || connection.status == status),
          )
          .toList();
      return connections;
    } catch (e) {
      // 파싱 오류 - 빈 리스트 반환
      return [];
    }
  }

  @override
  Future<void> acceptConnection({required String connectionId}) async {
    final connections = await getCurrentConnections();
    final index = connections.indexWhere(
      (connection) => connection.id == connectionId,
    );

    if (index == -1) {
      throw Exception('연결 요청을 찾을 수 없습니다.');
    }

    final updatedConnection = connections[index].copyWith(
      status: ConnectionStatus.accepted,
    );
    connections[index] = updatedConnection;

    final jsonString = jsonEncode(connections.map((c) => c.toJson()).toList());
    await _prefs.setString(_ConnectionStorageKeys.connections, jsonString);
  }

  @override
  Future<void> rejectConnection({required String connectionId}) async {
    final connections = await getCurrentConnections();
    final index = connections.indexWhere(
      (connection) => connection.id == connectionId,
    );

    if (index == -1) {
      throw Exception('연결 요청을 찾을 수 없습니다.');
    }

    final updatedConnection = connections[index].copyWith(
      status: ConnectionStatus.rejected,
    );
    connections[index] = updatedConnection;

    final jsonString = jsonEncode(connections.map((c) => c.toJson()).toList());
    await _prefs.setString(_ConnectionStorageKeys.connections, jsonString);
  }

  @override
  Future<void> revokeConnection({required String connectionId}) async {
    final connections = await getCurrentConnections();
    final index = connections.indexWhere(
      (connection) => connection.id == connectionId,
    );

    if (index == -1) {
      throw Exception('연결 요청을 찾을 수 없습니다.');
    }

    final updatedConnection = connections[index].copyWith(
      status: ConnectionStatus.revoked,
    );
    connections[index] = updatedConnection;

    final jsonString = jsonEncode(connections.map((c) => c.toJson()).toList());
    await _prefs.setString(_ConnectionStorageKeys.connections, jsonString);
  }

  @override
  Future<bool> canAccessPatientData({
    required String patientEmail,
    required SharingScope requiredScope,
  }) async {
    final email = _getCurrentUserEmail();
    final connections = await getCurrentConnections(
      type: ConnectionType.guardian,
      status: ConnectionStatus.accepted,
    );

    return connections.any(
      (connection) =>
          connection.patientEmail == patientEmail &&
          connection.connectorEmail == email &&
          connection.scope.index >= requiredScope.index,
    );
  }
}
