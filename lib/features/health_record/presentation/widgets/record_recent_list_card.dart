import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/health_record_entity.dart';
import 'record_item_widget.dart';

/// 최근 작성 내역 카드
///
/// Figma: Record - 2 (최근 작성 내역 카드)
/// 최근 기록 리스트를 표시하며, 헤더에 전체 보기 버튼이 있습니다.
class RecordRecentListCard extends StatelessWidget {
  const RecordRecentListCard({
    super.key,
    required this.records,
    this.onViewAll,
    this.onRecordTap,
    this.maxCount = 3,
  });

  /// 기록 목록
  final List<HealthRecordEntity> records;

  /// 전체 보기 콜백
  final VoidCallback? onViewAll;

  /// 기록 탭 콜백
  final ValueChanged<HealthRecordEntity>? onRecordTap;

  /// 표시할 최대 개수
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    // 최신순 정렬 후 maxCount만큼만 표시
    final displayRecords = List<HealthRecordEntity>.from(records)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    final limitedRecords = displayRecords.take(maxCount).toList();

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
          _buildHeader(context),
          const SizedBox(height: 12),
          // 기록 리스트
          _buildRecordList(context, limitedRecords),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '최근 작성 내역',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColorScheme.black100,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.45,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Opacity(
            opacity: 0.2,
            child: Assets.icons.arrowRight.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                AppColorScheme.black100,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordList(
    BuildContext context,
    List<HealthRecordEntity> displayRecords,
  ) {
    if (displayRecords.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            '기록이 없습니다',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColorScheme.grey400),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          for (int i = 0; i < displayRecords.length; i++) ...[
            RecordItemWidget(
              record: displayRecords[i],
              onTap: () => onRecordTap?.call(displayRecords[i]),
            ),
            if (i < displayRecords.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  color: AppColorScheme.white300,
                  height: 1,
                  thickness: 1,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
