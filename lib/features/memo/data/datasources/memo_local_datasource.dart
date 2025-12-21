import '../models/memo_model.dart';

abstract class MemoLocalDataSource {
  /// 새로운 메모 저장
  Future<void> saveMemo(MemoModel memo);

  /// 특정 환자의 모든 메모 조회
  Future<List<MemoModel>> getMemosByPatientEmail(String patientEmail);

  /// 특정 메모 삭제
  Future<void> deleteMemo({
    required String patientEmail,
    required String memoId,
  });

  /// 특정 환자의 모든 메모 삭제
  Future<void> clearMemos(String patientEmail);
}
