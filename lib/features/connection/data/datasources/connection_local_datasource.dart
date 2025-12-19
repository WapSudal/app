import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/connection_model.dart';
import '../models/patient_summary_model.dart';
import '../models/patient_recent_record_model.dart';
import '../../domain/entities/patient_search_info_entity.dart';
import '../../domain/entities/patient_summary_entity.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../../../core/exceptions/app_exception.dart';

/// Connection LocalDataSource (Mock with Persistence)
///
/// 인메모리 데이터로 연결 관리 기능을 시뮬레이션하며,
/// SharedPreferences를 통해 영속성을 제공합니다
class ConnectionLocalDataSource {
  final SharedPreferences _prefs;

  static const _connectionsKey = 'connections_list';

  // 인메모리 연결 저장소
  List<ConnectionModel> _connections = [];

  // 더미 사용자 데이터 (UID -> 사용자 정보)
  final Map<String, _MockUser> _mockUsers = {
    // 환자들
    'patient1_uid': _MockUser(
      uid: 'patient1_uid',
      name: '김환자',
      email: 'patient1@test.com',
      birthDate: DateTime(1980, 1, 1),
      riskScore: 54,
      riskLevel: PatientRiskLevel.warning,
      systolicBP: 145,
      diastolicBP: 92,
      dataCount: 12,
    ),
    'patient2_uid': _MockUser(
      uid: 'patient2_uid',
      name: '이환자',
      email: 'patient2@test.com',
      birthDate: DateTime(1975, 5, 15),
      riskScore: 32,
      riskLevel: PatientRiskLevel.danger,
      systolicBP: 168,
      diastolicBP: 105,
      dataCount: 8,
    ),
    'patient3_uid': _MockUser(
      uid: 'patient3_uid',
      name: '박환자',
      email: 'patient3@test.com',
      birthDate: DateTime(1990, 12, 30),
      riskScore: 15,
      riskLevel: PatientRiskLevel.safe,
      systolicBP: 118,
      diastolicBP: 78,
      dataCount: 25,
    ),
    // 보호자
    'guardian1_uid': _MockUser(
      uid: 'guardian1_uid',
      name: '홍보호',
      email: 'guardian1@test.com',
      birthDate: DateTime(1978, 3, 20),
    ),
    // 주치의
    'doctor1_uid': _MockUser(
      uid: 'doctor1_uid',
      name: '최의사',
      email: 'doctor1@test.com',
      birthDate: DateTime(1970, 7, 10),
    ),
  };

  // 환자별 최근 기록 (Mock)
  final List<PatientRecentRecordModel> _mockRecentRecords = [];

  ConnectionLocalDataSource(this._prefs);

  /// 앱 시작 시 저장된 데이터를 로드합니다
  ///
  /// main.dart에서 호출되어야 합니다
  Future<void> initialize() async {
    // SharedPreferences에서 연결 데이터 로드
    final savedData = _prefs.getString(_connectionsKey);

    if (savedData != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(savedData);
        _connections = jsonList
            .map((json) => ConnectionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // 파싱 실패 시 초기 Mock 데이터로 시작
        _connections = [];
        await _prefs.remove(_connectionsKey);
      }
    }

    // 첫 실행이거나 데이터가 없으면 초기 Mock 데이터 생성
    if (_connections.isEmpty) {
      _initializeMockConnections();
      await _persistConnections();
    }

    // Mock 최근 기록은 항상 초기화 (영속성 불필요)
    _initializeMockRecentRecords();
  }

  /// 연결 데이터를 SharedPreferences에 저장합니다
  Future<void> _persistConnections() async {
    try {
      final jsonList = _connections.map((conn) => conn.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(_connectionsKey, jsonString);
    } catch (e) {
      // 저장 실패는 무시 (인메모리 데이터는 유지됨)
      // 프로덕션에서는 로깅 필요
    }
  }

  /// 초기 더미 연결 생성
  void _initializeMockConnections() {
    // 보호자1이 환자 3명과 연결된 상태 (Guardian 홈 테스트용)
    _connections.addAll([
      ConnectionModel(
        id: 'conn_1',
        patientId: 'patient1_uid',
        connectorId: 'guardian1_uid',
        type: ConnectionType.guardian,
        status: ConnectionStatus.accepted,
        scope: SharingScope.full,
        requestedAt: DateTime.now().subtract(const Duration(days: 30)),
        respondedAt: DateTime.now().subtract(const Duration(days: 29)),
        connectorName: '홍보호',
        connectorEmail: 'guardian1@test.com',
        patientName: '김환자',
        patientEmail: 'patient1@test.com',
      ),
      ConnectionModel(
        id: 'conn_2',
        patientId: 'patient2_uid',
        connectorId: 'guardian1_uid',
        type: ConnectionType.guardian,
        status: ConnectionStatus.accepted,
        scope: SharingScope.full,
        requestedAt: DateTime.now().subtract(const Duration(days: 20)),
        respondedAt: DateTime.now().subtract(const Duration(days: 19)),
        connectorName: '홍보호',
        connectorEmail: 'guardian1@test.com',
        patientName: '이환자',
        patientEmail: 'patient2@test.com',
      ),
      ConnectionModel(
        id: 'conn_3',
        patientId: 'patient3_uid',
        connectorId: 'guardian1_uid',
        type: ConnectionType.guardian,
        status: ConnectionStatus.accepted,
        scope: SharingScope.summary,
        requestedAt: DateTime.now().subtract(const Duration(days: 10)),
        respondedAt: DateTime.now().subtract(const Duration(days: 9)),
        connectorName: '홍보호',
        connectorEmail: 'guardian1@test.com',
        patientName: '박환자',
        patientEmail: 'patient3@test.com',
      ),
      // 주치의1도 환자 2명과 연결 (Doctor 홈 테스트용)
      ConnectionModel(
        id: 'conn_4',
        patientId: 'patient1_uid',
        connectorId: 'doctor1_uid',
        type: ConnectionType.doctor,
        status: ConnectionStatus.accepted,
        scope: SharingScope.full,
        requestedAt: DateTime.now().subtract(const Duration(days: 60)),
        respondedAt: DateTime.now().subtract(const Duration(days: 59)),
        connectorName: '최의사',
        connectorEmail: 'doctor1@test.com',
        patientName: '김환자',
        patientEmail: 'patient1@test.com',
      ),
      ConnectionModel(
        id: 'conn_5',
        patientId: 'patient2_uid',
        connectorId: 'doctor1_uid',
        type: ConnectionType.doctor,
        status: ConnectionStatus.accepted,
        scope: SharingScope.full,
        requestedAt: DateTime.now().subtract(const Duration(days: 45)),
        respondedAt: DateTime.now().subtract(const Duration(days: 44)),
        connectorName: '최의사',
        connectorEmail: 'doctor1@test.com',
        patientName: '이환자',
        patientEmail: 'patient2@test.com',
      ),
    ]);
  }

  /// 초기 더미 최근 기록 생성
  void _initializeMockRecentRecords() {
    final now = DateTime.now();
    _mockRecentRecords.addAll([
      PatientRecentRecordModel(
        recordId: 'record_1',
        patientId: 'patient1_uid',
        patientName: '김환자',
        recordedAt: now.subtract(const Duration(hours: 2)),
        systolicBP: 145,
        diastolicBP: 92,
      ),
      PatientRecentRecordModel(
        recordId: 'record_2',
        patientId: 'patient2_uid',
        patientName: '이환자',
        recordedAt: now.subtract(const Duration(hours: 5)),
        systolicBP: 168,
        diastolicBP: 105,
        bloodSugar: 142,
      ),
      PatientRecentRecordModel(
        recordId: 'record_3',
        patientId: 'patient3_uid',
        patientName: '박환자',
        recordedAt: now.subtract(const Duration(days: 1)),
        systolicBP: 118,
        diastolicBP: 78,
        bloodSugar: 95,
      ),
      PatientRecentRecordModel(
        recordId: 'record_4',
        patientId: 'patient1_uid',
        patientName: '김환자',
        recordedAt: now.subtract(const Duration(days: 2)),
        bloodSugar: 128,
      ),
    ]);
  }

  /// 환자 검색 (이름 + 생년월일 + 이메일로 정확히 일치)
  String? _findPatientId(PatientSearchInfoEntity searchInfo) {
    final normalizedSearchEmail = searchInfo.email.trim().toLowerCase();
    final normalizedSearchName = searchInfo.name.trim().replaceAll(' ', '');

    for (final entry in _mockUsers.entries) {
      final user = entry.value;
      final normalizedEmail = user.email.trim().toLowerCase();
      final normalizedName = user.name.trim().replaceAll(' ', '');

      if (normalizedName == normalizedSearchName &&
          normalizedEmail == normalizedSearchEmail &&
          _isSameDate(user.birthDate, searchInfo.birthDate)) {
        return entry.key;
      }
    }
    return null;
  }

  /// 날짜 비교 (YYYY-MM-DD만 비교)
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// 연결 요청 전송
  Future<ConnectionModel> sendConnectionRequest({
    required String currentUserId,
    required PatientSearchInfoEntity patientInfo,
    required ConnectionType type,
    required SharingScope scope,
  }) async {
    // 네트워크 지연 시뮬레이션
    await Future.delayed(Duration(milliseconds: 500));

    // 1. 환자 찾기
    final patientId = _findPatientId(patientInfo);
    if (patientId == null) {
      throw NotFoundException('환자를 찾을 수 없습니다');
    }

    // 2. 본인에게 연결 요청 방지
    if (patientId == currentUserId) {
      throw BadRequestException('본인에게 연결 요청을 할 수 없습니다');
    }

    // 3. 이미 존재하는 연결 확인 (pending 또는 accepted)
    final existing = _connections.where((conn) {
      return conn.patientId == patientId &&
          conn.connectorId == currentUserId &&
          (conn.status == ConnectionStatus.pending ||
              conn.status == ConnectionStatus.accepted);
    }).toList();

    if (existing.isNotEmpty) {
      throw ConflictException('이미 연결 요청이 존재합니다');
    }

    // 4. 연결 생성
    final connector = _mockUsers[currentUserId]!;
    final patient = _mockUsers[patientId]!;

    final connection = ConnectionModel(
      id: 'conn_${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      connectorId: currentUserId,
      type: type,
      status: ConnectionStatus.pending,
      scope: scope,
      requestedAt: DateTime.now(),
      connectorName: connector.name,
      connectorEmail: connector.email,
      patientName: patient.name,
      patientEmail: patient.email,
    );

    _connections.add(connection);
    await _persistConnections();
    return connection;
  }

  /// 대기중인 연결 요청 조회
  Future<List<ConnectionModel>> getPendingRequests({
    required String currentUserId,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    return _connections.where((conn) {
      return conn.patientId == currentUserId &&
          conn.status == ConnectionStatus.pending;
    }).toList();
  }

  /// 연결 요청 수락
  Future<ConnectionModel> acceptConnection({
    required String currentUserId,
    required String connectionId,
  }) async {
    await Future.delayed(Duration(milliseconds: 400));

    final index = _connections.indexWhere((conn) => conn.id == connectionId);
    if (index == -1) {
      throw NotFoundException('연결을 찾을 수 없습니다');
    }

    final connection = _connections[index];

    // 권한 확인 (환자만 수락 가능)
    if (connection.patientId != currentUserId) {
      throw UnauthorizedException('연결을 수락할 권한이 없습니다');
    }

    // 상태 확인 (pending만 수락 가능)
    if (connection.status != ConnectionStatus.pending) {
      throw BadRequestException('이미 처리된 요청입니다');
    }

    // 상태 업데이트
    final updated = connection.copyWith(
      status: ConnectionStatus.accepted,
      respondedAt: DateTime.now(),
    );

    _connections[index] = updated;
    await _persistConnections();
    return updated;
  }

  /// 연결 요청 거절
  Future<ConnectionModel> rejectConnection({
    required String currentUserId,
    required String connectionId,
  }) async {
    await Future.delayed(Duration(milliseconds: 400));

    final index = _connections.indexWhere((conn) => conn.id == connectionId);
    if (index == -1) {
      throw NotFoundException('연결을 찾을 수 없습니다');
    }

    final connection = _connections[index];

    // 권한 확인 (환자만 거절 가능)
    if (connection.patientId != currentUserId) {
      throw UnauthorizedException('연결을 거절할 권한이 없습니다');
    }

    // 상태 확인 (pending만 거절 가능)
    if (connection.status != ConnectionStatus.pending) {
      throw BadRequestException('이미 처리된 요청입니다');
    }

    // 상태 업데이트
    final updated = connection.copyWith(
      status: ConnectionStatus.rejected,
      respondedAt: DateTime.now(),
    );

    _connections[index] = updated;
    await _persistConnections();
    return updated;
  }

  /// 내 연결 목록 조회
  Future<List<ConnectionModel>> getMyConnections({
    required String currentUserId,
    ConnectionType? type,
    ConnectionStatus? status,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    return _connections.where((conn) {
      // 사용자가 환자 또는 연결자인 경우
      final isMyConnection =
          conn.patientId == currentUserId || conn.connectorId == currentUserId;

      if (!isMyConnection) return false;

      // 타입 필터
      if (type != null && conn.type != type) return false;

      // 상태 필터
      if (status != null && conn.status != status) return false;

      return true;
    }).toList();
  }

  /// 연결 해제
  Future<void> revokeConnection({
    required String currentUserId,
    required String connectionId,
  }) async {
    await Future.delayed(Duration(milliseconds: 400));

    final index = _connections.indexWhere((conn) => conn.id == connectionId);
    if (index == -1) {
      throw NotFoundException('연결을 찾을 수 없습니다');
    }

    final connection = _connections[index];

    // 권한 확인 (환자 또는 연결자만 해제 가능)
    if (connection.patientId != currentUserId &&
        connection.connectorId != currentUserId) {
      throw UnauthorizedException('연결을 해제할 권한이 없습니다');
    }

    // 상태 확인 (이미 종료된 연결은 해제 불가)
    if (connection.status == ConnectionStatus.rejected ||
        connection.status == ConnectionStatus.revoked) {
      throw BadRequestException('이미 종료된 연결입니다');
    }

    // 상태 업데이트
    final updated = connection.copyWith(
      status: ConnectionStatus.revoked,
      revokedAt: DateTime.now(),
    );

    _connections[index] = updated;
    await _persistConnections();
  }

  /// 환자 데이터 접근 권한 확인
  Future<bool> canAccessPatientData({
    required String currentUserId,
    required String patientId,
    required SharingScope requiredScope,
  }) async {
    await Future.delayed(Duration(milliseconds: 200));

    // 본인 데이터는 항상 접근 가능
    if (currentUserId == patientId) {
      return true;
    }

    // 연결 찾기
    final connection = _connections.where((conn) {
      return conn.patientId == patientId &&
          conn.connectorId == currentUserId &&
          conn.status == ConnectionStatus.accepted;
    }).firstOrNull;

    if (connection == null) {
      return false;
    }

    // Scope 확인
    return connection.scope.isAtLeast(requiredScope);
  }

  /// 연결 상세 조회
  Future<ConnectionModel> getConnectionById({
    required String connectionId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final connection = _connections
        .where((conn) => conn.id == connectionId)
        .firstOrNull;

    if (connection == null) {
      throw NotFoundException('연결을 찾을 수 없습니다');
    }

    return connection;
  }

  // ==================== Guardian/Doctor 홈 전용 API ====================

  /// 연결된 환자 요약 목록 조회 (Guardian/Doctor 홈용)
  ///
  /// [currentUserId]: 현재 로그인한 보호자/주치의 ID
  /// [type]: 연결 유형 필터 (null이면 모든 유형)
  Future<List<PatientSummaryModel>> getConnectedPatientsSummary({
    required String currentUserId,
    ConnectionType? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // 현재 사용자가 연결자(보호자/주치의)인 활성 연결만 필터링
    final activeConnections = _connections.where((conn) {
      final isConnector = conn.connectorId == currentUserId;
      final isAccepted = conn.status == ConnectionStatus.accepted;
      final matchesType = type == null || conn.type == type;
      return isConnector && isAccepted && matchesType;
    }).toList();

    // 연결된 환자들의 요약 정보 생성
    return activeConnections.map((conn) {
      final patient = _mockUsers[conn.patientId];
      if (patient == null) {
        throw NotFoundException('환자 정보를 찾을 수 없습니다: ${conn.patientId}');
      }

      return PatientSummaryModel(
        patientId: conn.patientId,
        name: patient.name,
        profileImageUrl: null,
        riskLevel: patient.riskLevel ?? PatientRiskLevel.unknown,
        riskScore: patient.riskScore ?? 0,
        systolicBP: patient.systolicBP,
        diastolicBP: patient.diastolicBP,
        dataCount: patient.dataCount ?? 0,
        lastRecordedAt: _getLastRecordedAt(conn.patientId),
        scope: conn.scope,
        connectionId: conn.id,
      );
    }).toList();
  }

  /// 고위험 환자 목록 조회 (Guardian/Doctor 홈의 "주의가 필요한 환자" 섹션)
  Future<List<PatientSummaryModel>> getHighRiskPatients({
    required String currentUserId,
    ConnectionType? type,
  }) async {
    final allPatients = await getConnectedPatientsSummary(
      currentUserId: currentUserId,
      type: type,
    );

    // Warning 또는 Danger 상태인 환자만 필터링
    return allPatients.where((p) {
      return p.riskLevel == PatientRiskLevel.warning ||
          p.riskLevel == PatientRiskLevel.danger;
    }).toList();
  }

  /// 최근 환자 기록 목록 조회 (Guardian/Doctor 홈의 "최근 작성된 기록" 섹션)
  ///
  /// 연결된 환자들의 기록만 반환하며, 시간순으로 정렬됨
  Future<List<PatientRecentRecordModel>> getRecentPatientRecords({
    required String currentUserId,
    ConnectionType? type,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // 연결된 환자 ID 목록
    final connectedPatientIds = _connections
        .where((conn) {
          final isConnector = conn.connectorId == currentUserId;
          final isAccepted = conn.status == ConnectionStatus.accepted;
          final matchesType = type == null || conn.type == type;
          return isConnector && isAccepted && matchesType;
        })
        .map((conn) => conn.patientId)
        .toSet();

    // 연결된 환자들의 기록만 필터링 후 시간순 정렬
    final filteredRecords =
        _mockRecentRecords
            .where((record) => connectedPatientIds.contains(record.patientId))
            .toList()
          ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return filteredRecords.take(limit).toList();
  }

  /// 환자별 마지막 기록 시간 조회
  DateTime? _getLastRecordedAt(String patientId) {
    final records =
        _mockRecentRecords.where((r) => r.patientId == patientId).toList()
          ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return records.isNotEmpty ? records.first.recordedAt : null;
  }
}

/// 더미 사용자 데이터 클래스
class _MockUser {
  final String uid;
  final String name;
  final String email;
  final DateTime birthDate;

  // 환자 전용 필드 (보호자/주치의는 null)
  final int? riskScore;
  final PatientRiskLevel? riskLevel;
  final int? systolicBP;
  final int? diastolicBP;
  final int? dataCount;

  _MockUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.birthDate,
    this.riskScore,
    this.riskLevel,
    this.systolicBP,
    this.diastolicBP,
    this.dataCount,
  });
}
