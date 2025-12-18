import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_icon.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../connection/domain/entities/patient_summary_entity.dart';

/// 환자 리스트 아이템 위젯
///
/// Figma: Patients - List (환자 목록 아이템)
/// 프로필 이미지, 이름, 상태 칩(건강/위험), 혈압 정보, 화살표 아이콘을 포함합니다.
class PatientListItem extends StatelessWidget {
  const PatientListItem({super.key, required this.patient, this.onTap});

  final PatientSummaryEntity patient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColorScheme.white100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 프로필 이미지
            _buildProfileImage(),
            const SizedBox(width: 12),
            // 정보 영역
            Expanded(child: _buildInfoSection(context)),
            // 화살표 아이콘
            AppIcon(
              Assets.icons.right,
              color: AppColorScheme.grey500,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  /// 프로필 이미지 (48x48 원형)
  Widget _buildProfileImage() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorScheme.white300,
        image: patient.profileImageUrl != null
            ? DecorationImage(
                image: NetworkImage(patient.profileImageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: patient.profileImageUrl == null
          ? const Icon(Icons.person, size: 24, color: AppColorScheme.grey400)
          : null,
    );
  }

  /// 정보 섹션
  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이름 + 상태 칩
        Row(
          children: [
            Text(
              patient.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColorScheme.black100,
              ),
            ),
            const SizedBox(width: 8),
            _buildStatusChip(context),
          ],
        ),
        const SizedBox(height: 4),
        // 혈압 정보
        _buildHealthInfo(context),
      ],
    );
  }

  /// 상태 칩 (건강/주의/위험)
  Widget _buildStatusChip(BuildContext context) {
    final chipColor = Color(patient.riskLevel.colorValue);
    final chipBackgroundColor = chipColor.withValues(alpha: 0.15);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        patient.riskLevel.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 건강 정보 (혈압)
  Widget _buildHealthInfo(BuildContext context) {
    final infoItems = <String>[];

    // 혈압 정보
    if (patient.bloodPressureDisplay != null) {
      infoItems.add('혈압 ${patient.bloodPressureDisplay}');
    }

    // 데이터 건수
    infoItems.add('기록 ${patient.dataCountDisplay}');

    return Text(
      infoItems.join(' · '),
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColorScheme.grey400),
    );
  }
}
