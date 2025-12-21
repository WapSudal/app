import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/no_data_card.dart';
import '../../../health_record/domain/entities/health_record_entity.dart';
import '../../../patients/presentation/widgets/patient_manage_bottom_sheet.dart';
import '../providers/caregiver_home_notifier.dart';
import '../providers/caregiver_home_state.dart';
import 'caregiver_fast_menu_card.dart';
import 'caregiver_home_patient_count_card.dart';
import 'caregiver_home_patient_info_card.dart';
import 'caregiver_home_recent_records_card.dart';
import 'home_splash_card.dart';
import 'home_welcome_card.dart';

/// 보호자/주치의 홈 컨텐츠 (통합)
///
/// Guardian과 Doctor 역할이 공유하는 홈 화면 컨텐츠
/// Figma 디자인 기반으로 구현
class CaregiverHomeContent extends ConsumerWidget {
  const CaregiverHomeContent({super.key, this.displayName});

  final String? displayName;

  /// 환자별 최근 건강 기록 맵 생성
  Map<String, HealthRecordEntity> _buildPatientRecordsMap(
    CaregiverHomeState state,
  ) {
    final Map<String, HealthRecordEntity> patientRecords = {};

    // 각 고위험 환자에 대해 최근 기록 찾기
    for (final patient in state.highRiskPatients) {
      // recentRecords에서 해당 환자의 가장 최근 기록 찾기
      final patientRecord = state.recentRecords
          .where((record) => record.patientEmail == patient.email)
          .firstOrNull;

      if (patientRecord != null) {
        patientRecords[patient.email] = patientRecord;
      }
    }

    return patientRecords;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(caregiverHomeProvider);

    return homeState.when(
      data: (state) => Container(
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
                  onButtonPressed: () {
                    PatientManageBottomSheet.show(context: context);
                  },
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
                  patientRecords: _buildPatientRecordsMap(state),
                ),
                const SizedBox(height: 8),
              ],

              // 최근 작성된 기록 섹션
              if (state.connectedPatients.isNotEmpty) ...[
                CaregiverHomeRecentRecordsCard(
                  records: state.recentRecords,
                  patientNames: {
                    for (final patient in state.connectedPatients)
                      patient.email: patient.displayName ?? '이름 없음',
                  },
                  onRecordTap: (record) {
                    // 기록 탭 시 해당 데이터 상세 표시
                  },
                ),
                const SizedBox(height: 8),
              ],

              // 빠른 메뉴 카드
              CaregiverFastMenuCard(
                onNewPatientConnection: () {
                  PatientManageBottomSheet.show(context: context);
                },
                onPatientList: () {
                  context.go('/patients');
                },
                onContentExplore: () {
                  context.go('/explore');
                },
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          '데이터를 불러오는 중 오류가 발생했습니다.\n$error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
