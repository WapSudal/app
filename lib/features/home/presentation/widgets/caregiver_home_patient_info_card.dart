import 'package:flutter/material.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../health_record/domain/entities/health_record_entity.dart';

/// 환자 정보 요소 위젯
///
/// Figma: Home/PatientInfo/Element
/// 환자 이름, 위험도 점수, 혈압, 데이터 건수를 세로 카드 형태로 표시
class CaregiverHomePatientInfoElement extends StatelessWidget {
  const CaregiverHomePatientInfoElement({
    super.key,
    required this.patient,
    required this.record,
    this.isWarning = false,
  });

  final UserEntity patient;
  final HealthRecordEntity record;
  final bool isWarning; // true: 노란색 주의, false: 빨간색 경고

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        border: Border.all(color: AppColorScheme.white300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 + 아이콘
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                patient.displayName ?? '',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColorScheme.black100),
              ),
              _buildWarningIcon(),
            ],
          ),
          const SizedBox(height: 12),
          // 위험도
          _buildKeyValueRow(context, key: '위험도', value: '32점'),
          const SizedBox(height: 4),
          // 혈압
          _buildKeyValueRow(
            context,
            key: '혈압',
            value: '${record.systolicBP ?? '-'}/${record.diastolicBP ?? '-'}',
          ),
          const SizedBox(height: 4),
          // 데이터
          _buildKeyValueRow(context, key: '데이터', value: '3건'),
        ],
      ),
    );
  }

  Widget _buildWarningIcon() {
    // 경고 아이콘 (빨간색 삼각형 또는 노란색 삼각형)
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isWarning
            ? const Color(0xFFFFA500).withValues(alpha: 0.2)
            : const Color(0xFFFF4130).withValues(alpha: 0.2),
      ),
      child: Center(
        child: Text(
          '!',
          style: TextStyle(
            color: isWarning
                ? const Color(0xFFFFA500)
                : const Color(0xFFFF4130),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyValueRow(
    BuildContext context, {
    required String key,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColorScheme.black100.withValues(alpha: 0.5),
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppColorScheme.black100),
        ),
      ],
    );
  }
}

/// "주의가 필요한 환자" 섹션 카드
///
/// Figma: Home/Warning Patients Card
/// 2개의 환자 카드를 가로로 나란히 표시
class CaregiverHomeWarningPatientsCard extends StatelessWidget {
  const CaregiverHomeWarningPatientsCard({
    super.key,
    required this.patients,
    this.patientRecords,
  });

  /// 고위험 환자 목록
  final List<UserEntity> patients;

  /// 환자별 최근 건강 기록 맵 (patientEmail -> HealthRecordEntity)
  final Map<String, HealthRecordEntity>? patientRecords;

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return const SizedBox.shrink();
    }

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
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '주의가 필요한 환자',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Opacity(
                opacity: 0.2,
                child: Assets.icons.arrowRight.svg(width: 21, height: 21),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 환자 카드 가로로 배치 (실제 환자 수만큼만 표시, 1명이어도 1칸만 차지)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 첫 번째 환자 (경고 - 빨간색)
              Expanded(
                child: patients.isNotEmpty
                    ? _buildPatientCard(
                        context,
                        index: 0,
                        isWarning: false,
                        defaultSystolicBP: 999,
                        defaultDiastolicBP: 99,
                      )
                    : const SizedBox(),
              ),
              const SizedBox(width: 8),
              // 두 번째 환자 (주의 - 노란색)
              Expanded(
                child: patients.length > 1
                    ? _buildPatientCard(
                        context,
                        index: 1,
                        isWarning: true,
                        defaultSystolicBP: 145,
                        defaultDiastolicBP: 90,
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(
    BuildContext context, {
    required int index,
    required bool isWarning,
    required int defaultSystolicBP,
    required int defaultDiastolicBP,
  }) {
    final patient = patients[index];

    // 해당 환자의 건강 기록 사용, 없으면 더미 데이터
    final record = patientRecords?[patient.email];

    final systolicBP = record?.systolicBP ?? defaultSystolicBP;
    final diastolicBP = record?.diastolicBP ?? defaultDiastolicBP;

    return CaregiverHomePatientInfoElement(
      patient: patient,
      record: HealthRecordEntity(
        id: 'record-$index',
        patientEmail: patient.email,
        recordedAt: record?.recordedAt ?? DateTime.now(),
        systolicBP: systolicBP,
        diastolicBP: diastolicBP,
      ),
      isWarning: isWarning,
    );
  }
}
