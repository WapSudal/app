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

  /// 필터링 없이 모든 연결을 가져옵니다 (내부 사용)
  Future<List<ConnectionModel>> _getAllConnections() async {
    final jsonString = _prefs.getString(_ConnectionStorageKeys.connections);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => ConnectionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // 파싱 오류 - 빈 리스트 반환
      return [];
    }
  }

  @override
  Future<List<ConnectionModel>> getCurrentConnections({
    ConnectionType? type,
    ConnectionStatus? status,
  }) async {
    final email = _getCurrentUserEmail();
    final allConnections = await _getAllConnections();

    return allConnections
        .where(
          (connection) =>
              (connection.patientEmail == email ||
                  connection.connectorEmail == email) &&
              (type == null || connection.type == type) &&
              (status == null || connection.status == status),
        )
        .toList();
  }

  @override
  Future<void> acceptConnection({required String connectorEmail}) async {
    final email = _getCurrentUserEmail();
    final allConnections = await _getAllConnections();
    final index = allConnections.indexWhere(
      (connection) =>
          connection.patientEmail == email &&
          connection.connectorEmail == connectorEmail &&
          connection.status == ConnectionStatus.pending,
    );

    if (index == -1) {
      throw Exception('연결 요청을 찾을 수 없습니다.');
    }

    final updatedConnection = allConnections[index].copyWith(
      status: ConnectionStatus.accepted,
    );
    allConnections[index] = updatedConnection;

    final jsonString = jsonEncode(
      allConnections.map((c) => c.toJson()).toList(),
    );
    await _prefs.setString(_ConnectionStorageKeys.connections, jsonString);
  }

  @override
  Future<void> rejectConnection({required String connectorEmail}) async {
    final email = _getCurrentUserEmail();
    final allConnections = await _getAllConnections();
    final index = allConnections.indexWhere(
      (connection) =>
          connection.patientEmail == email &&
          connection.connectorEmail == connectorEmail &&
          connection.status == ConnectionStatus.pending,
    );

    if (index == -1) {
      throw Exception('연결 요청을 찾을 수 없습니다.');
    }

    final updatedConnection = allConnections[index].copyWith(
      status: ConnectionStatus.rejected,
    );
    allConnections[index] = updatedConnection;

    final jsonString = jsonEncode(
      allConnections.map((c) => c.toJson()).toList(),
    );
    await _prefs.setString(_ConnectionStorageKeys.connections, jsonString);
  }

  @override
  Future<void> revokeConnection({required String connectorEmail}) async {
    final email = _getCurrentUserEmail();
    final allConnections = await _getAllConnections();
    final index = allConnections.indexWhere(
      (connection) =>
          connection.connectorEmail == connectorEmail &&
          connection.patientEmail == email &&
          connection.status == ConnectionStatus.accepted,
    );

    if (index == -1) {
      throw Exception('연결 요청을 찾을 수 없습니다.');
    }

    final updatedConnection = allConnections[index].copyWith(
      status: ConnectionStatus.revoked,
    );
    allConnections[index] = updatedConnection;

    final jsonString = jsonEncode(
      allConnections.map((c) => c.toJson()).toList(),
    );
    await _prefs.setString(_ConnectionStorageKeys.connections, jsonString);
  }

  @override
  Future<bool> canAccessPatientData({
    required String patientEmail,
    required SharingScope requiredScope,
  }) async {
    final email = _getCurrentUserEmail();
    final connections = await getCurrentConnections(
      status: ConnectionStatus.accepted,
    );

    print(
      'patientEmail: $patientEmail, email: $email, requiredScope: $requiredScope',
    );
    print(connections);

    return connections.any(
      (connection) =>
          connection.patientEmail == patientEmail &&
          connection.connectorEmail == email,
    );
  }
}
