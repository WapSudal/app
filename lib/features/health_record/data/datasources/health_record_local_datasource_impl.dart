import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_record_model.dart';
import 'health_record_local_datasource.dart';

abstract class _HealthRecordStorageKeys {
  /// email별 건강 기록 키 생성
  static String recordsListByEmail(String email) =>
      'health_records_list_$email';
}

class HealthRecordLocalDataSourceImpl implements HealthRecordLocalDataSource {
  final SharedPreferences _prefs;
  final String Function() _getCurrentUserEmail;

  HealthRecordLocalDataSourceImpl({
    required SharedPreferences prefs,
    required String Function() getCurrentUserEmail,
  }) : _prefs = prefs,
       _getCurrentUserEmail = getCurrentUserEmail;

  /// 새로운 건강 기록 저장 (현재 사용자)
  @override
  Future<void> saveHealthRecord(HealthRecordModel record) async {
    final userEmail = _getCurrentUserEmail();
    final records = await getHealthRecords();
    records.add(record);

    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs.setString(
      _HealthRecordStorageKeys.recordsListByEmail(userEmail),
      jsonEncode(jsonList),
    );
  }

  /// 모든 건강 기록 조회 (현재 사용자, 날짜 내림차순)
  @override
  Future<List<HealthRecordModel>> getHealthRecords() async {
    final email = _getCurrentUserEmail();
    final jsonString = _prefs.getString(
      _HealthRecordStorageKeys.recordsListByEmail(email),
    );
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final records = jsonList
          .map(
            (json) => HealthRecordModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      // 날짜 내림차순 정렬
      records.sort(
        (a, b) => DateTime.parse(
          b.recordedAt,
        ).compareTo(DateTime.parse(a.recordedAt)),
      );
      return records;
    } catch (e) {
      // 파싱 오류 - 빈 리스트 반환
      return [];
    }
  }

  /// 최신 건강 기록 조회
  @override
  Future<HealthRecordModel?> getLatestHealthRecord() async {
    final records = await getHealthRecords();
    return records.isNotEmpty ? records.first : null;
  }

  /// 모든 기록 삭제 (현재 사용자)
  @override
  Future<void> clearRecords() async {
    final email = _getCurrentUserEmail();
    await _prefs.remove(_HealthRecordStorageKeys.recordsListByEmail(email));
  }

  /// 특정 기록 삭제 (현재 사용자)
  @override
  Future<void> deleteHealthRecord(String recordId) async {
    final email = _getCurrentUserEmail();
    final records = await getHealthRecords();
    final filteredRecords = records.where((r) => r.id != recordId).toList();

    final jsonList = filteredRecords.map((r) => r.toJson()).toList();
    await _prefs.setString(
      _HealthRecordStorageKeys.recordsListByEmail(email),
      jsonEncode(jsonList),
    );
  }

  /// 특정 사용자의 건강 기록 조회 (보호자/주치의용)
  @override
  Future<List<HealthRecordModel>> getHealthRecordsByEmail(
    String patientEmail,
  ) async {
    final jsonString = _prefs.getString(
      _HealthRecordStorageKeys.recordsListByEmail(patientEmail),
    );
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final records = jsonList
          .map(
            (json) => HealthRecordModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      // 날짜 내림차순 정렬
      records.sort(
        (a, b) => DateTime.parse(
          b.recordedAt,
        ).compareTo(DateTime.parse(a.recordedAt)),
      );
      return records;
    } catch (e) {
      // 파싱 오류 - 빈 리스트 반환
      return [];
    }
  }

  /// 특정 사용자의 최신 건강 기록 조회 (보호자/주치의용)
  @override
  Future<HealthRecordModel?> getLatestHealthRecordByEmail(
    String patientEmail,
  ) async {
    final records = await getHealthRecordsByEmail(patientEmail);
    return records.isNotEmpty ? records.first : null;
  }
}
