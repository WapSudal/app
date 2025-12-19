import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_record_model.dart';
import 'health_record_datasource.dart';

abstract class _HealthRecordStorageKeys {
  static const String recordsList = 'health_records_list';

  /// userId별 건강 기록 키 생성
  static String recordsListByUserId(String userId) =>
      'health_records_list_$userId';
}

class HealthRecordLocalDataSource implements HealthRecordDataSource {
  final SharedPreferences _prefs;
  final String Function() _getCurrentUserId;

  HealthRecordLocalDataSource({
    required SharedPreferences prefs,
    required String Function() getCurrentUserId,
  })  : _prefs = prefs,
        _getCurrentUserId = getCurrentUserId;

  /// 새로운 건강 기록 저장 (현재 사용자)
  @override
  Future<void> saveHealthRecord(HealthRecordModel record) async {
    final userId = _getCurrentUserId();
    final records = await getHealthRecords();
    records.add(record);

    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs.setString(
      _HealthRecordStorageKeys.recordsListByUserId(userId),
      jsonEncode(jsonList),
    );
  }

  /// 모든 건강 기록 조회 (현재 사용자, 날짜 내림차순)
  @override
  Future<List<HealthRecordModel>> getHealthRecords() async {
    final userId = _getCurrentUserId();
    final jsonString = _prefs.getString(
      _HealthRecordStorageKeys.recordsListByUserId(userId),
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
    final userId = _getCurrentUserId();
    await _prefs.remove(
      _HealthRecordStorageKeys.recordsListByUserId(userId),
    );
  }

  /// 특정 기록 삭제 (현재 사용자)
  @override
  Future<void> deleteHealthRecord(String id) async {
    final userId = _getCurrentUserId();
    final records = await getHealthRecords();
    final filteredRecords = records.where((r) => r.id != id).toList();

    final jsonList = filteredRecords.map((r) => r.toJson()).toList();
    await _prefs.setString(
      _HealthRecordStorageKeys.recordsListByUserId(userId),
      jsonEncode(jsonList),
    );
  }

  /// 특정 사용자의 건강 기록 조회 (보호자/주치의용)
  @override
  Future<List<HealthRecordModel>> getHealthRecordsByUserId(
    String userId,
  ) async {
    final jsonString = _prefs.getString(
      _HealthRecordStorageKeys.recordsListByUserId(userId),
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
  Future<HealthRecordModel?> getLatestHealthRecordByUserId(
    String userId,
  ) async {
    final records = await getHealthRecordsByUserId(userId);
    return records.isNotEmpty ? records.first : null;
  }
}
