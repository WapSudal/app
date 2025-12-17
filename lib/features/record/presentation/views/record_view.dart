import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/record_notifier.dart';
import '../providers/record_state.dart';
import 'widgets/record_detail_modal.dart';
import 'widgets/record_empty_card.dart';
import 'widgets/record_recent_list_card.dart';
import 'widgets/record_stats_card.dart';
import 'widgets/record_status_card.dart';

/// 기록 화면
///
/// Figma: Record - 1, Record - 2
/// 건강 기록 데이터 유무에 따라 빈 상태 또는 데이터 상태를 표시합니다.
class RecordView extends ConsumerWidget {
  const RecordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(recordProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
      appBar: const CustomAppBar(
        mode: AppBarMode.navigation,
        title: '기록',
      ),
      body: recordAsync.when(
        data: (recordState) => _buildContent(context, ref, recordState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '데이터를 불러오는 중 오류가 발생했습니다.\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColorScheme.grey400),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    RecordState recordState,
  ) {
    if (!recordState.hasData) {
      return _buildEmptyContent(context);
    }
    return _buildDataContent(context, ref, recordState);
  }

  /// 데이터 없음 상태
  Widget _buildEmptyContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 빈 상태 카드 (Expanded로 남은 공간 채우기)
          const Expanded(child: RecordEmptyCard()),
          const SizedBox(height: 8),
          // 기록 입력하기 버튼
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.push('/record/input'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorScheme.primaryColor,
                foregroundColor: AppColorScheme.white100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                '기록 입력하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// 데이터 있음 상태
  Widget _buildDataContent(
    BuildContext context,
    WidgetRef ref,
    RecordState recordState,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 상태 카드
          RecordStatusCard(healthStatus: recordState.healthStatus),
          const SizedBox(height: 8),
          // 통계 카드
          RecordStatsCard(
            recordState: recordState,
            onPeriodChanged: (filter) {
              ref.read(recordProvider.notifier).updatePeriodFilter(filter);
            },
          ),
          const SizedBox(height: 8),
          // 최근 작성 내역 카드
          RecordRecentListCard(
            records: recordState.healthRecords,
            onViewAll: () => context.push('/record/all'),
            onRecordTap: (record) {
              RecordDetailModal.show(
                context,
                record: record,
                onDelete: () {
                  ref.read(recordProvider.notifier).deleteRecord(record.id);
                },
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
