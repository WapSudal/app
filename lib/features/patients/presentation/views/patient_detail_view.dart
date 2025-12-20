import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/health_record_period_filter.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/presentation/widgets/no_data_paint.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../analysis/presentation/widgets/risk_assessment_content.dart';
import '../../../analysis/presentation/widgets/what_if_simulation_content.dart';
import '../../../auth/applications/registered_user_notifier.dart';
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
      appBar: const CustomAppBar(mode: AppBarMode.subpage, title: '환자 정보'),
      body: SafeArea(
        child: patientDetailState.when(
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
      ),
    );
  }

  Widget _buildContent(PatientDetailState state) {
    final periodIndex = PatientDetailTab.values.indexOf(state.selectedTab);
    final currentRole = ref
        .read(registeredUserProvider)
        .user!
        .role; // 가입된 사용자이므로 null 아님 보장

    return Container(
      height: double.infinity,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state.selectedTab == PatientDetailTab.summary)
                    state.healthRecords.isEmpty
                        ? NoDataPaint(
                            title: '아직 데이터가 없네요',
                            subtitle: '환자가 건강 기록을 더 작성하면\n상태와 통계 정보를 확인할 수 있어요',
                          )
                        : _buildSummaryTabContent(state),
                  if (state.selectedTab == PatientDetailTab.riskAssessment)
                    state.analysisAvailability.canAnalyze
                        ? RiskAssessmentContent(
                            riskAssessment: state.riskAssessment!,
                          )
                        : NoDataPaint(
                            title: '아직 데이터가 없네요',
                            subtitle: '환자가 건강 기록을 더 작성하면\n분석 결과를 확인할 수 있어요',
                          ),
                  if (state.selectedTab == PatientDetailTab.whatIfSimulation)
                    state.analysisAvailability.canAnalyze
                        ? WhatIfSimulationContent(
                            simulation: state.whatIfSimulation!,
                          )
                        : NoDataPaint(
                            title: '아직 데이터가 없네요',
                            subtitle: '환자가 건강 기록을 더 작성하면\n분석 결과를 확인할 수 있어요',
                          ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: AppFlatButton(
                  text: '연결 끊기',
                  onPressed: () => _showDisconnectConfirmDialog(context),
                  isExpanded: true,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColorScheme.danger.withValues(alpha: 0.2),
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      AppColorScheme.danger,
                    ),
                  ),
                ),
              ),
              if (currentRole == UserRole.doctor)
                Expanded(
                  child: AppFlatButton(
                    text: '메모 작성',
                    onPressed: () {
                      // 새로운 건강 기록 추가 로직 추가
                    },
                    isExpanded: true,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppColorScheme.primaryColor.withValues(alpha: 0.2),
                      ),
                      foregroundColor: WidgetStateProperty.all(
                        AppColorScheme.primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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

  /// 연결 끊기 확인 다이얼로그
  Future<void> _showDisconnectConfirmDialog(BuildContext context) async {
    await AppConfirmDialog.show<bool>(
      context: context,
      title: '이 환자와 연결을 해제할까요?',
      description: '해제 후 다시 연결해야 합니다.',
      buttons: [
        Expanded(
          child: AppFlatButton(
            text: '취소',
            onPressed: () => Navigator.of(context).pop(false),
            isExpanded: true,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.white300),
              foregroundColor: WidgetStateProperty.all(AppColorScheme.black100),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppFlatButton(
            text: '연결 해제',
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            isExpanded: true,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.danger),
            ),
          ),
        ),
      ],
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        _disconnectPatient(context);
      }
    });
  }

  /// 환자와의 연결 끊기 실행
  Future<void> _disconnectPatient(BuildContext context) async {
    try {
      await ref
          .read(
            patientDetailProvider(patientEmail: widget.patientEmail).notifier,
          )
          .revokePatientConnection();

      if (context.mounted) {
        // 성공 시 이전 화면으로 돌아가기
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('연결이 해제되었습니다.'),
            backgroundColor: AppColorScheme.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('연결 끊기에 실패했습니다: $e'),
            backgroundColor: AppColorScheme.danger,
          ),
        );
      }
    }
  }
}
