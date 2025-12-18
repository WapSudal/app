import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../connection/domain/entities/patient_summary_entity.dart';

/// 환자 상세 정보 Bottom Sheet
///
/// Guardian/Doctor 홈 화면에서 환자를 탭했을 때 표시되는 상세 정보 시트
class PatientDetailBottomSheet extends StatelessWidget {
  const PatientDetailBottomSheet({
    super.key,
    required this.patient,
    this.onViewHealthRecords,
    this.onViewRiskAnalysis,
    this.onManageConnection,
  });

  final PatientSummaryEntity patient;
  final VoidCallback? onViewHealthRecords;
  final VoidCallback? onViewRiskAnalysis;
  final VoidCallback? onManageConnection;

  /// Bottom Sheet 표시
  static Future<void> show({
    required BuildContext context,
    required PatientSummaryEntity patient,
    VoidCallback? onViewHealthRecords,
    VoidCallback? onViewRiskAnalysis,
    VoidCallback? onManageConnection,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: '환자 상세',
      heightRatio: 0.6,
      showCloseButton: true,
      child: PatientDetailBottomSheet(
        patient: patient,
        onViewHealthRecords: onViewHealthRecords,
        onViewRiskAnalysis: onViewRiskAnalysis,
        onManageConnection: onManageConnection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 환자 프로필 섹션
          _buildProfileSection(context),
          const SizedBox(height: 24),

          // 건강 상태 요약 섹션
          _buildHealthSummarySection(context),
          const SizedBox(height: 24),

          // 액션 버튼들
          _buildActionButtons(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Row(
      children: [
        // 프로필 이미지
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _getRiskColor().withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: _getRiskColor(), width: 2),
          ),
          child: ClipOval(
            child: Assets.icons.defaultProfile.svg(width: 64, height: 64),
          ),
        ),
        const SizedBox(width: 16),
        // 이름 + 위험도 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColorScheme.black100,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildRiskBadge(context),
                  const SizedBox(width: 8),
                  Text(
                    patient.riskScoreDisplay,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getRiskColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRiskBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getRiskColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        patient.riskLevel.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: _getRiskColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHealthSummarySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '건강 상태 요약',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColorScheme.black100,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // 혈압
          _buildSummaryRow(
            context,
            icon: Assets.icons.heartRate,
            label: '최근 혈압',
            value: patient.bloodPressureDisplay ?? '데이터 없음',
            valueColor: patient.bloodPressureDisplay != null
                ? AppColorScheme.black100
                : AppColorScheme.grey300,
          ),
          const SizedBox(height: 8),
          // 데이터 건수
          _buildSummaryRow(
            context,
            icon: Assets.icons.data,
            label: '총 기록 수',
            value: patient.dataCountDisplay,
          ),
          const SizedBox(height: 8),
          // 마지막 기록 시간
          _buildSummaryRow(
            context,
            icon: Assets.icons.alarm,
            label: '마지막 기록',
            value: _formatLastRecordedAt(),
            valueColor: patient.lastRecordedAt != null
                ? AppColorScheme.black100
                : AppColorScheme.grey300,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required SvgGenImage icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        icon.svg(
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            AppColorScheme.grey300,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColorScheme.grey200),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: valueColor ?? AppColorScheme.black100,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 건강 기록 보기
        AppFlatButton(onPressed: onViewHealthRecords, text: '건강 기록 보기'),
        const SizedBox(height: 8),
        // 위험도 분석 보기
        AppFlatButton(onPressed: onViewRiskAnalysis, text: '위험도 분석 보기'),
      ],
    );
  }

  Color _getRiskColor() {
    return Color(patient.riskLevel.colorValue);
  }

  String _formatLastRecordedAt() {
    if (patient.lastRecordedAt == null) return '기록 없음';

    final now = DateTime.now();
    final diff = now.difference(patient.lastRecordedAt!);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else {
      final date = patient.lastRecordedAt!;
      return '${date.month}월 ${date.day}일';
    }
  }
}
