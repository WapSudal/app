import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_record_model.dart';

abstract class _HealthRecordStorageKeys {
  static const String recordsList = 'health_records_list';
}

class HealthRecordLocalDataSource {
  final SharedPreferences _prefs;

  HealthRecordLocalDataSource({required SharedPreferences prefs})
    : _prefs = prefs;

  /// 새로운 건강 기록 저장
  Future<void> saveRecord(HealthRecordModel record) async {
    final records = await getRecords();
    records.add(record);

    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs.setString(
      _HealthRecordStorageKeys.recordsList,
      jsonEncode(jsonList),
    );
  }

  /// 모든 건강 기록 조회 (날짜 내림차순)
  Future<List<HealthRecordModel>> getRecords() async {
    final jsonString = _prefs.getString(_HealthRecordStorageKeys.recordsList);
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
      // 파싱 오류 - 손상된 데이터 삭제
      await clearRecords();
      return [];
    }
  }

  /// 최신 건강 기록 조회
  Future<HealthRecordModel?> getLatestRecord() async {
    final records = await getRecords();
    return records.isNotEmpty ? records.first : null;
  }

  /// 모든 기록 삭제
  Future<void> clearRecords() async {
    await _prefs.remove(_HealthRecordStorageKeys.recordsList);
  }

  /// 특정 기록 삭제
  Future<void> deleteRecord(String id) async {
    final records = await getRecords();
    final filteredRecords = records.where((r) => r.id != id).toList();

    final jsonList = filteredRecords.map((r) => r.toJson()).toList();
    await _prefs.setString(
      _HealthRecordStorageKeys.recordsList,
      jsonEncode(jsonList),
    );
  }
}
