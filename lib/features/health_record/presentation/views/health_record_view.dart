import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/no_data_card.dart';
import '../../../../core/presentation/widgets/no_data_paint.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/health_record_notifier.dart';
import '../providers/health_record_state.dart';
import '../widgets/health_record_detail_bottom_sheet_content.dart';
import '../widgets/health_record_recent_list_card.dart';
import '../widgets/health_record_stats_card.dart';
import '../widgets/health_record_status_card.dart';

/// 기록 화면
///
/// Figma: Record - 1, Record - 2
/// 건강 기록 데이터 유무에 따라 빈 상태 또는 데이터 상태를 표시합니다.
class HealthRecordView extends ConsumerWidget {
  const HealthRecordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(healthRecordProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
      appBar: const CustomAppBar(mode: AppBarMode.navigation, title: '기록'),
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
    HealthRecordState recordState,
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
          const Expanded(
            child: NoDataCard(
              title: '아직 데이터가 없네요',
              subtitle: '꾸준히 건강 데이터를 입력해주세요!',
            ),
          ),
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
    HealthRecordState recordState,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 상태 카드
          HealthRecordStatusCard(healthStatus: recordState.healthStatus),
          const SizedBox(height: 8),
          // 통계 카드
          HealthRecordStatsCard(
            recordState: recordState,
            onPeriodChanged: (filter) {
              ref
                  .read(healthRecordProvider.notifier)
                  .updatePeriodFilter(filter);
            },
          ),
          const SizedBox(height: 8),
          // 최근 작성 내역 카드
          HealthRecordRecentListCard(
            records: recordState.healthRecords,
            onViewAll: () => context.push('/record/all'),
            onRecordTap: (record) {
              AppBottomSheet.show(
                context: context,
                title: '건강 데이터 상세',
                maxHeightRatio: 0.8,
                showDragHandle: false,
                child: HealthRecordDetailBottomSheetContent(
                  record: record,
                  onDelete: () {
                    ref
                        .read(healthRecordProvider.notifier)
                        .deleteRecord(record.id);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
