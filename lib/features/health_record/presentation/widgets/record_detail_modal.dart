import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../domain/entities/health_record_entity.dart';
import 'record_detail_bottom_sheet_content.dart';

/// 기록 상세 Bottom Sheet
///
/// Figma: Record Modal (node-id=489:4396)
/// 기록의 상세 정보를 표시하고 삭제 기능을 제공합니다.
///
/// [AppBottomSheet]를 사용하는 래퍼 클래스입니다.
/// 기존 코드와의 호환성을 위해 유지되며, 내부적으로 [AppBottomSheet.show]를 호출합니다.
class RecordDetailModal {
  /// Bottom Sheet를 표시합니다.
  ///
  /// [record]: 표시할 건강 기록
  /// [onDelete]: 삭제 버튼 클릭 시 호출될 콜백
  static Future<void> show(
    BuildContext context, {
    required HealthRecordEntity record,
    VoidCallback? onDelete,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: '건강 데이터 상세',
      maxHeightRatio: 0.8,
      showDragHandle: false,
      child: RecordDetailBottomSheetContent(
        record: record,
        onDelete: onDelete,
      ),
    );
  }
}
