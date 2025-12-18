import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/no_data_card.dart';
import '../../../connection/domain/entities/patient_summary_entity.dart';
import '../providers/caregiver_home_notifier.dart';
import '../providers/caregiver_home_state.dart';
import 'caregiver_fast_menu_card.dart';
import 'caregiver_home_patient_count_card.dart';
import 'caregiver_home_patient_info_card.dart';
import 'caregiver_home_recent_records_card.dart';
import 'home_splash_card.dart';
import 'home_welcome_card.dart';
import 'patient_detail_bottom_sheet.dart';

/// 보호자/주치의 홈 컨텐츠 (통합)
///
/// Guardian과 Doctor 역할이 공유하는 홈 화면 컨텐츠
/// Figma 디자인 기반으로 구현
class CaregiverHomeContent extends ConsumerWidget {
  const CaregiverHomeContent({super.key, this.displayName});

  final String? displayName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(caregiverHomeProvider);

    return Container(
      color: const Color(0xFFF7F6FB), // dashboard/bg
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.connectedPatients.isEmpty)
            // 첫 방문 스플래시 카드
            ...[
              HomeSplashCard(
                title: '만나서 반가워요!',
                description: '환자를 연결하여 관리를 시작해주세요.',
                emoji: '🔎',
                buttonText: '환자 연결하기',
                onButtonPressed: () => _navigateToPatientConnection(context),
              ),
              const SizedBox(height: 8),
            ],

            // 환영 메시지 카드 (재사용)
            HomeWelcomeCard(displayName: displayName),
            const SizedBox(height: 8),

            // 환자 수 통계 카드 (가로 2개)
            if (state.connectedPatients.isNotEmpty) ...[
              CaregiverHomePatientCountRow(
                totalPatientCount: state.connectedPatientCount,
                highRiskPatientCount: state.highRiskPatientCount,
              ),
              const SizedBox(height: 8),
            ],

            if (state.connectedPatients.isEmpty)
            // 환자 연결 안내 카드
            ...[
              const NoDataCard(
                title: '아직 연결하신 환자가 없네요',
                subtitle: '환자와 연결해주세요!',
              ),
              const SizedBox(height: 8),
            ],

            // 주의가 필요한 환자 섹션
            if (state.connectedPatients.isNotEmpty &&
                state.hasHighRiskPatients) ...[
              CaregiverHomeWarningPatientsCard(
                patients: state.highRiskPatients,
                onPatientTap: (patient) =>
                    _showPatientDetail(context, ref, patient),
              ),
              const SizedBox(height: 8),
            ],

            // 최근 작성된 기록 섹션
            if (state.connectedPatients.isNotEmpty) ...[
              CaregiverHomeRecentRecordsCard(
                records: state.recentRecords,
                onRecordTap: (record) {
                  // 기록 탭 시 해당 환자 상세 표시
                  final patient = state.connectedPatients
                      .where((p) => p.patientId == record.patientId)
                      .firstOrNull;
                  if (patient != null) {
                    _showPatientDetail(context, ref, patient);
                  }
                },
              ),
              const SizedBox(height: 8),
            ],

            // 빠른 메뉴 카드
            CaregiverFastMenuCard(
              onNewPatientConnection: () {
                // TODO: 새로운 환자 연결 페이지로 이동
                _navigateToPatientConnection(context);
              },
              onPatientList: () {
                // TODO: 환자 목록 페이지로 이동
                _navigateToPatientList(context);
              },
              onContentExplore: () {
                // TODO: 추천 콘텐츠 탐색 페이지로 이동
                _navigateToExplore(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 환자 상세 Bottom Sheet 표시
  void _showPatientDetail(
    BuildContext context,
    WidgetRef ref,
    PatientSummaryEntity patient,
  ) {
    ref.read(caregiverHomeProvider.notifier).selectPatient(patient.patientId);

    PatientDetailBottomSheet.show(
      context: context,
      patient: patient,
      onViewHealthRecords: () {
        Navigator.of(context).pop();
        // TODO: 환자 건강 기록 페이지로 이동
      },
      onViewRiskAnalysis: () {
        Navigator.of(context).pop();
        // TODO: 환자 위험도 분석 페이지로 이동
      },
    ).then((_) {
      // Bottom Sheet 닫힐 때 선택 해제
      ref.read(caregiverHomeProvider.notifier).clearSelectedPatient();
    });
  }

  void _navigateToPatientConnection(BuildContext context) {
    // TODO: 환자 연결 페이지로 이동
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('새로운 환자 연결 기능 (준비 중)')));
  }

  void _navigateToPatientList(BuildContext context) {
    // TODO: 환자 목록 페이지로 이동
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('환자 목록 기능 (준비 중)')));
  }

  void _navigateToExplore(BuildContext context) {
    // TODO: 탐색 페이지로 이동
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('추천 콘텐츠 탐색 기능 (준비 중)')));
  }
}
