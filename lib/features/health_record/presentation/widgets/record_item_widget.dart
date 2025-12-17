import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/health_record_entity.dart';

/// 기록 아이템 위젯
///
/// Figma: Record/Record Element
/// 개별 기록 항목을 표시합니다.
class RecordItemWidget extends StatelessWidget {
  const RecordItemWidget({super.key, required this.record, this.onTap});

  final HealthRecordEntity record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            // 텍스트 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 날짜
                  Text(
                    _formatDate(record.recordedAt),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColorScheme.primaryColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 혈압/혈당
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          _formatBloodPressure(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColorScheme.grey300,
                                letterSpacing: -0.32,
                              ),
                        ),
                      ),
                      Text(
                        _formatBloodSugar(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColorScheme.grey300,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 화살표 아이콘
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

  String _formatDate(DateTime date) {
    final weekDay = ['월', '화', '수', '목', '금', '토', '일'];
    return '${date.month}월 ${date.day}일 (${weekDay[date.weekday - 1]})';
  }

  String _formatBloodPressure() {
    if (record.systolicBP != null && record.diastolicBP != null) {
      return '혈압 ${record.systolicBP}/${record.diastolicBP}';
    }
    return '혈압 -';
  }

  String _formatBloodSugar() {
    if (record.bloodSugar != null) {
      return '혈당 ${record.bloodSugar}';
    }
    return '혈당 -';
  }
}
