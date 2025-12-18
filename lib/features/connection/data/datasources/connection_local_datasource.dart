import '../models/connection_model.dart';
import '../../domain/entities/patient_search_info_entity.dart';
import '../../../../core/enums/connection_type.dart';
import '../../../../core/enums/connection_status.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../../../core/exceptions/app_exception.dart';

/// Connection LocalDataSource (Mock)
///
/// 인메모리 데이터로 연결 관리 기능을 시뮬레이션합니다
class ConnectionLocalDataSource {
  // 인메모리 연결 저장소
  final List<ConnectionModel> _connections = [];

  // 더미 사용자 데이터 (UID -> 사용자 정보)
  final Map<String, _MockUser> _mockUsers = {
    // 환자들
    'patient1_uid': _MockUser(
      uid: 'patient1_uid',
      name: '김환자',
      email: 'patient1@test.com',
      birthDate: DateTime(1980, 1, 1),
    ),
    'patient2_uid': _MockUser(
      uid: 'patient2_uid',
      name: '이환자',
      email: 'patient2@test.com',
      birthDate: DateTime(1975, 5, 15),
    ),
    'patient3_uid': _MockUser(
      uid: 'patient3_uid',
      name: '박환자',
      email: 'patient3@test.com',
      birthDate: DateTime(1990, 12, 30),
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

  ConnectionLocalDataSource() {
    // 초기 더미 연결 데이터 (선택사항)
    _initializeMockConnections();
  }

  /// 초기 더미 연결 생성
  void _initializeMockConnections() {
    // 필요시 초기 연결 데이터 추가
    // 예: 보호자1이 환자1에게 이미 연결 요청한 상태
    /*
    _connections.add(
      ConnectionModel(
        id: 'conn_1',
        patientId: 'patient1_uid',
        connectorId: 'guardian1_uid',
        type: ConnectionType.guardian,
        status: ConnectionStatus.pending,
        scope: SharingScope.full,
        requestedAt: DateTime.now().subtract(Duration(days: 1)),
        connectorName: '홍보호',
        connectorEmail: 'guardian1@test.com',
        patientName: '김환자',
        patientEmail: 'patient1@test.com',
      ),
    );
    */
  }

  /// 환자 검색 (이름 + 생년월일 + 이메일로 정확히 일치)
  String? _findPatientId(PatientSearchInfoEntity searchInfo) {
    final normalizedSearchEmail =
        searchInfo.email.trim().toLowerCase();
    final normalizedSearchName =
        searchInfo.name.trim().replaceAll(' ', '');

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
    await Future.delayed(Duration(milliseconds: 200));

    final connection =
        _connections.where((conn) => conn.id == connectionId).firstOrNull;

    if (connection == null) {
      throw NotFoundException('연결을 찾을 수 없습니다');
    }

    return connection;
  }
}

/// 더미 사용자 데이터 클래스
class _MockUser {
  final String uid;
  final String name;
  final String email;
  final DateTime birthDate;

  _MockUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.birthDate,
  });
}
