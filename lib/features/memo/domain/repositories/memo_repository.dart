import '../entities/memo_entity.dart';

abstract class MemoRepository {
  /// 새로운 메모 저장
  Future<void> saveMemo({
    required String patientEmail,
    required String content,
  });

  /// 특정 환자의 모든 메모 조회 (최신순)
  Future<List<MemoEntity>> getMemosByPatientEmail(String patientEmail);

  /// 특정 메모 삭제
  Future<void> deleteMemo({
    required String patientEmail,
    required String memoId,
  });

  /// 특정 환자의 모든 메모 삭제
  Future<void> clearMemos(String patientEmail);
}
