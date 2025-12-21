import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/memo_model.dart';
import 'memo_local_datasource.dart';

abstract class _MemoStorageKeys {
  /// 환자 이메일별 메모 키 생성
  static String memosListByPatientEmail(String patientEmail) =>
      'memo_list_$patientEmail';
}

class MemoLocalDataSourceImpl implements MemoLocalDataSource {
  final SharedPreferences _prefs;

  MemoLocalDataSourceImpl({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  /// 새로운 메모 저장
  @override
  Future<void> saveMemo(MemoModel memo) async {
    final memos = await getMemosByPatientEmail(memo.patientEmail);
    memos.add(memo);

    final jsonList = memos.map((m) => m.toJson()).toList();
    await _prefs.setString(
      _MemoStorageKeys.memosListByPatientEmail(memo.patientEmail),
      jsonEncode(jsonList),
    );
  }

  /// 특정 환자의 모든 메모 조회 (최신순)
  @override
  Future<List<MemoModel>> getMemosByPatientEmail(String patientEmail) async {
    final jsonString = _prefs.getString(
      _MemoStorageKeys.memosListByPatientEmail(patientEmail),
    );
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final memos = jsonList
          .map(
            (json) => MemoModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      // 최신순 정렬 (날짜 내림차순)
      memos.sort(
        (a, b) => DateTime.parse(b.createdAt).compareTo(
          DateTime.parse(a.createdAt),
        ),
      );
      return memos;
    } catch (e) {
      // 파싱 오류 - 빈 리스트 반환
      return [];
    }
  }

  /// 특정 메모 삭제
  @override
  Future<void> deleteMemo({
    required String patientEmail,
    required String memoId,
  }) async {
    final memos = await getMemosByPatientEmail(patientEmail);
    final filteredMemos = memos.where((m) => m.id != memoId).toList();

    final jsonList = filteredMemos.map((m) => m.toJson()).toList();
    await _prefs.setString(
      _MemoStorageKeys.memosListByPatientEmail(patientEmail),
      jsonEncode(jsonList),
    );
  }

  /// 특정 환자의 모든 메모 삭제
  @override
  Future<void> clearMemos(String patientEmail) async {
    await _prefs.remove(
      _MemoStorageKeys.memosListByPatientEmail(patientEmail),
    );
  }
}
