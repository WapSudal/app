import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../health_record/domain/entities/health_record_entity.dart';
import '../providers/record_notifier.dart';
import '../providers/record_state.dart';
import 'widgets/record_detail_modal.dart';
import 'widgets/record_item_widget.dart';

/// 전체 기록 화면
///
/// Figma: Record - 7, Record - 8
/// 월별로 그룹화된 전체 기록을 표시합니다.
class RecordAllView extends ConsumerWidget {
  const RecordAllView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(recordProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
      appBar: const CustomAppBar(
        mode: AppBarMode.subpage,
        title: '전체 기록',
      ),
      body: recordAsync.when(
        data: (recordState) {
          final groupedRecords = recordState.recordsByMonth;
          return _buildContent(context, ref, groupedRecords);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '데이터를 불러오는 중 오류가 발생했습니다.',
            style: const TextStyle(color: AppColorScheme.grey400),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Map<String, List<HealthRecordEntity>> groupedRecords,
  ) {
    if (groupedRecords.isEmpty) {
      return const Center(
        child: Text(
          '기록이 없습니다',
          style: TextStyle(color: AppColorScheme.grey400),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          for (final entry in groupedRecords.entries) ...[
            _buildMonthCard(context, ref, entry.key, entry.value),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMonthCard(
    BuildContext context,
    WidgetRef ref,
    String monthTitle,
    List<HealthRecordEntity> records,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 월 헤더
          Text(
            monthTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColorScheme.black100,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(height: 12),
          // 기록 리스트
          if (records.isEmpty)
            _buildEmptyMonth(context)
          else
            _buildRecordList(context, ref, records),
        ],
      ),
    );
  }

  Widget _buildEmptyMonth(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColorScheme.white500,
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            '이 달은 데이터를 입력하지 않았어요',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColorScheme.grey300,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '꾸준히 건강 데이터를 입력해주세요!',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordList(
    BuildContext context,
    WidgetRef ref,
    List<HealthRecordEntity> records,
  ) {
    // 날짜 내림차순 정렬
    final sortedRecords = List<HealthRecordEntity>.from(records)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          for (int i = 0; i < sortedRecords.length; i++) ...[
            RecordItemWidget(
              record: sortedRecords[i],
              onTap: () {
                RecordDetailModal.show(
                  context,
                  record: sortedRecords[i],
                  onDelete: () {
                    ref
                        .read(recordProvider.notifier)
                        .deleteRecord(sortedRecords[i].id);
                  },
                );
              },
            ),
            if (i < sortedRecords.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  color: AppColorScheme.white300,
                  height: 1,
                  thickness: 1,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
