import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../connection/domain/entities/patient_summary_entity.dart';

/// 환자 정보 요소 위젯
///
/// Figma: Home/PatientInfo/Element
/// 환자 이름, 위험도 점수, 혈압, 데이터 건수를 표시
class CaregiverHomePatientInfoElement extends StatelessWidget {
  const CaregiverHomePatientInfoElement({
    super.key,
    required this.patient,
    this.onTap,
  });

  final PatientSummaryEntity patient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // 프로필 이미지
            _buildProfileImage(),
            const SizedBox(width: 12),
            // 이름 + 위험도 점수
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColorScheme.black100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _buildRiskBadge(context),
                ],
              ),
            ),
            // 혈압
            _buildInfoColumn(
              context,
              label: '혈압',
              value: patient.bloodPressureDisplay ?? '-',
            ),
            const SizedBox(width: 16),
            // 데이터 건수
            _buildInfoColumn(
              context,
              label: '데이터',
              value: patient.dataCountDisplay,
            ),
            const SizedBox(width: 8),
            // 화살표
            Assets.icons.right.svg(
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                AppColorScheme.grey400,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _getRiskBackgroundColor().withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: _getRiskBackgroundColor(), width: 2),
      ),
      child: ClipOval(
        child: Assets.icons.defaultProfile.svg(width: 44, height: 44),
      ),
    );
  }

  Widget _buildRiskBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getRiskBackgroundColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        patient.riskScoreDisplay,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: _getRiskBackgroundColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey300),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColorScheme.black100,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getRiskBackgroundColor() {
    return Color(patient.riskLevel.colorValue);
  }
}

/// "주의가 필요한 환자" 섹션 카드
///
/// Figma: Home/Warning Patients Card
class CaregiverHomeWarningPatientsCard extends StatelessWidget {
  const CaregiverHomeWarningPatientsCard({
    super.key,
    required this.patients,
    this.onPatientTap,
    this.maxDisplay = 2,
  });

  /// 고위험 환자 목록
  final List<PatientSummaryEntity> patients;

  /// 환자 탭 콜백
  final void Function(PatientSummaryEntity patient)? onPatientTap;

  /// 최대 표시 개수
  final int maxDisplay;

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayPatients = patients.take(maxDisplay).toList();

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
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColorScheme.warning,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '주의가 필요한 환자',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColorScheme.black100,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 환자 목록
          ...displayPatients.asMap().entries.map((entry) {
            final index = entry.key;
            final patient = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    color: AppColorScheme.black100.withValues(alpha: 0.1),
                  ),
                CaregiverHomePatientInfoElement(
                  patient: patient,
                  onTap: onPatientTap != null
                      ? () => onPatientTap!(patient)
                      : null,
                ),
              ],
            );
          }),
          // 더 많은 환자가 있으면 표시
          if (patients.length > maxDisplay)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '외 ${patients.length - maxDisplay}명',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColorScheme.grey300),
              ),
            ),
        ],
      ),
    );
  }
}
