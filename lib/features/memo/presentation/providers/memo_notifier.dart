import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/memo_data_providers.dart';
import 'memo_state.dart';

part 'memo_notifier.g.dart';

/// 환자 목록 화면 상태 관리 Provider
///
/// Guardian/Doctor가 관리하는 환자 목록을 로드하고 관리합니다.
@riverpod
class MemoNotifier extends _$MemoNotifier {
  @override
  Future<MemoState> build({required String patientEmail}) async {
    final memoRepository = ref.read(memoRepositoryProvider);

    final memos = await memoRepository.getMemosByPatientEmail(patientEmail);

    return MemoState(memos: memos);
  }

  /// 새로운 메모 생성
  Future<void> createMemo({
    required String patientEmail,
    required String content,
  }) async {
    final memoRepository = ref.read(memoRepositoryProvider);

    // 메모 저장
    await memoRepository.saveMemo(
      patientEmail: patientEmail,
      content: content,
    );

    // 상태 업데이트 (최신 메모 목록 다시 가져오기)
    final updatedMemos = await memoRepository.getMemosByPatientEmail(
      patientEmail,
    );

    state = AsyncData(MemoState(memos: updatedMemos));
  }
}
