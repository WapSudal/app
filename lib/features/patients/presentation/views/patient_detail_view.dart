import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/health_record_period_filter.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../health_record/presentation/widgets/health_record_detail_bottom_sheet_content.dart';
import '../../../health_record/presentation/widgets/health_record_recent_list_card.dart';
import '../../../health_record/presentation/widgets/health_record_stats_card.dart';
import '../../../health_record/presentation/widgets/health_record_status_card.dart';
import '../providers/patient_detail_notifier.dart';
import '../providers/patient_detail_state.dart';

class PatientDetailView extends ConsumerStatefulWidget {
  const PatientDetailView({super.key, required this.patientEmail});

  final String patientEmail;

  @override
  ConsumerState<PatientDetailView> createState() => _PatientDetailViewState();
}

class _PatientDetailViewState extends ConsumerState<PatientDetailView> {
  @override
  Widget build(BuildContext context) {
    final patientDetailState = ref.watch(
      patientDetailProvider(patientEmail: widget.patientEmail),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: const CustomAppBar(mode: AppBarMode.subpage, title: '환자 정보'),
      body: patientDetailState.when(
        data: (state) => _buildContent(state),
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [AppLoadingIndicator(), Text('불러오는 중')],
          ),
        ),
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

  Widget _buildContent(PatientDetailState state) {
    final periodIndex = PatientDetailTab.values.indexOf(state.selectedTab);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          AppSegmentedTabBar(
            items: PatientDetailTab.values
                .map((f) => SegmentedTabItem(label: f.label, value: f))
                .toList(),
            selectedIndex: periodIndex,
            onItemSelected: (index) {
              ref
                  .read(
                    patientDetailProvider(
                      patientEmail: widget.patientEmail,
                    ).notifier,
                  )
                  .changeTab(PatientDetailTab.values[index]);
            },
          ),
          const SizedBox(height: 12),
          // 여기에 실제 환자 상세 정보를 표시하는 위젯들을 추가하세요.
          if (state.selectedTab == PatientDetailTab.summary)
            _buildSummaryTabContent(state),
        ],
      ),
    );
  }

  Widget _buildSummaryTabContent(PatientDetailState patientDetailState) {
    return Column(
      children: [
        // 상태 카드
        HealthRecordStatusCard(healthStatus: patientDetailState.healthStatus),
        const SizedBox(height: 8),
        // 통계 카드
        HealthRecordStatsCard(
          selectedPeriodIndex: HealthRecordPeriodFilter.values.indexOf(
            patientDetailState.periodFilter,
          ),
          filteredRecordCount: patientDetailState.filteredRecordCount,
          averageBPString: patientDetailState.averageBPString ?? '-',
          averageBloodSugar: patientDetailState.averageBloodSugar,
          filteredRecords: patientDetailState.filteredRecords,
          onPeriodChanged: (filter) {
            ref
                .read(
                  patientDetailProvider(
                    patientEmail: widget.patientEmail,
                  ).notifier,
                )
                .updatePeriodFilter(filter);
          },
        ),
        const SizedBox(height: 8),
        // 최근 작성 내역 카드
        HealthRecordRecentListCard(
          records: patientDetailState.healthRecords,
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
                      .read(
                        patientDetailProvider(
                          patientEmail: widget.patientEmail,
                        ).notifier,
                      )
                      .deleteRecord(record.id);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
