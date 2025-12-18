import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/no_data_card.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/patients_notifier.dart';
import '../providers/patients_state.dart';
import '../widgets/patient_list_item.dart';

/// 환자 목록 화면 (보호자/주치의 전용)
///
/// Figma: Patients - Empty (환자 없음), Patients - List (환자 있음)
/// 보호자나 주치의가 관리하는 환자 목록을 표시합니다.
/// - 환자 없음: 빈 상태 카드 + "새로운 환자 연결하기" 버튼
/// - 환자 있음: 환자 리스트 + "새로운 환자 연결하기" 버튼
class PatientsView extends ConsumerWidget {
  const PatientsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsState = ref.watch(patientsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: const CustomAppBar(mode: AppBarMode.navigation, title: '환자 관리'),
      body: patientsState.when(
        data: (state) => _buildContent(context, ref, state),
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
    PatientsState state,
  ) {
    if (!state.hasPatients) {
      return _buildEmptyContent(context);
    }
    return _buildListContent(context, ref, state);
  }

  /// 환자 없음 상태
  Widget _buildEmptyContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 빈 상태 카드 (Expanded로 남은 공간 채우기)
          const Expanded(
            child: NoDataCard(title: '아직 환자가 없어요', subtitle: '환자를 연결하여 시작해주세요'),
          ),
          const SizedBox(height: 8),
          // 새로운 환자 연결하기 버튼
          AppFlatButton(
            text: '새로운 환자 연결하기',
            onPressed: () {
              // TODO: 환자 연결 화면으로 라우팅
            },
            isExpanded: true,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// 환자 목록 상태
  Widget _buildListContent(
    BuildContext context,
    WidgetRef ref,
    PatientsState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 환자 리스트
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: state.patients.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final patient = state.patients[index];
                return PatientListItem(
                  patient: patient,
                  onTap: () {
                    // TODO: 환자 상세 화면으로 라우팅
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // 새로운 환자 연결하기 버튼
          AppFlatButton(
            text: '새로운 환자 연결하기',
            onPressed: () {
              // TODO: 환자 연결 화면으로 라우팅
            },
            isExpanded: true,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
