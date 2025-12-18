import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../connection/domain/entities/patient_recent_record_entity.dart';

/// 최근 기록 요소 위젯
///
/// Figma: Home/Record Element
/// 환자별 최근 기록 아이템 (환자명, 측정값, 날짜)
class CaregiverHomeRecordElement extends StatelessWidget {
  const CaregiverHomeRecordElement({
    super.key,
    required this.record,
    this.onTap,
  });

  final PatientRecentRecordEntity record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // 프로필 이미지
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColorScheme.grey100,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Assets.icons.defaultProfile.svg(width: 40, height: 40),
              ),
            ),
            const SizedBox(width: 12),
            // 환자 이름 + 측정값
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.patientName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColorScheme.black100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.primaryValueDisplay,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColorScheme.grey200,
                    ),
                  ),
                ],
              ),
            ),
            // 날짜
            Text(
              record.getRelativeTimeDisplay(now),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey300),
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
}

/// "최근 작성된 기록" 섹션 카드
///
/// Figma: Home/Recent Records Card
class CaregiverHomeRecentRecordsCard extends StatelessWidget {
  const CaregiverHomeRecentRecordsCard({
    super.key,
    required this.records,
    this.onRecordTap,
    this.onViewAllTap,
    this.maxDisplay = 4,
  });

  /// 최근 기록 목록
  final List<PatientRecentRecordEntity> records;

  /// 기록 탭 콜백
  final void Function(PatientRecentRecordEntity record)? onRecordTap;

  /// "전체보기" 탭 콜백
  final VoidCallback? onViewAllTap;

  /// 최대 표시 개수
  final int maxDisplay;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return _buildEmptyState(context);
    }

    final displayRecords = records.take(maxDisplay).toList();

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
                '최근 작성된 기록',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColorScheme.black100,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onViewAllTap != null)
                GestureDetector(
                  onTap: onViewAllTap,
                  child: Text(
                    '전체보기',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColorScheme.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // 기록 목록
          ...displayRecords.asMap().entries.map((entry) {
            final index = entry.key;
            final record = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    color: AppColorScheme.black100.withValues(alpha: 0.1),
                  ),
                CaregiverHomeRecordElement(
                  record: record,
                  onTap: onRecordTap != null
                      ? () => onRecordTap!(record)
                      : null,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
          Text(
            '최근 작성된 기록',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColorScheme.black100,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Assets.icons.heartRate.svg(
                  width: 48,
                  height: 48,
                  colorFilter: ColorFilter.mode(
                    AppColorScheme.grey300,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '아직 작성된 기록이 없습니다',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColorScheme.grey300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
