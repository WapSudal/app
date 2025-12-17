import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/health_record_entity.dart';

/// 기록 상세 Bottom Sheet
///
/// Figma: Record Modal (node-id=489:4396)
/// 기록의 상세 정보를 표시하고 삭제 기능을 제공합니다.
class RecordDetailModal extends StatelessWidget {
  const RecordDetailModal({
    super.key,
    required this.record,
    this.onDelete,
    this.onClose,
  });

  final HealthRecordEntity record;
  final VoidCallback? onDelete;
  final VoidCallback? onClose;

  /// Bottom Sheet를 표시합니다.
  static Future<void> show(
    BuildContext context, {
    required HealthRecordEntity record,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.15),
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => RecordDetailModal(
        record: record,
        onDelete: onDelete,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animationValue = animation.value;
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3 * animationValue,
            sigmaY: 3 * animationValue,
          ),
          child: child!,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColorScheme.white100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00274C).withValues(alpha: 0.07),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    // 날짜 및 시간
                    _buildDateTime(context),
                    const SizedBox(height: 16),
                    // 구분선
                    const Divider(color: AppColorScheme.white500),
                    const SizedBox(height: 16),
                    // 정보 리스트
                    _buildInfoList(context),
                    const SizedBox(height: 16),
                    // 삭제 버튼
                    _buildDeleteButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '건강 데이터 상세',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColorScheme.black100,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: Opacity(
            opacity: 0.2,
            child: Assets.icons.close.svg(
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

  Widget _buildDateTime(BuildContext context) {
    final dateFormat = DateFormat('yyyy년 M월 d일');
    final weekDays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    final timeFormat = DateFormat('H시 m분 s초');

    return Center(
      child: Column(
        children: [
          Text(
            dateFormat.format(record.recordedAt),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColorScheme.primaryColor,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.65,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${weekDays[record.recordedAt.weekday - 1]} ${timeFormat.format(record.recordedAt)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorScheme.black100,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoList(BuildContext context) {
    return Column(
      children: [
        // 수축기/이완기 혈압
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                context,
                label: '수축기 혈압',
                value: record.systolicBP != null
                    ? '${record.systolicBP} mmHg'
                    : '-',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoItem(
                context,
                label: '이완기 혈압',
                value: record.diastolicBP != null
                    ? '${record.diastolicBP} mmHg'
                    : '-',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 혈당/BMI
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                context,
                label: '혈당',
                value: record.bloodSugar != null
                    ? '${record.bloodSugar} mg/dL'
                    : '-',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoItem(
                context,
                label: 'BMI',
                value: record.bmi != null
                    ? record.bmi!.toStringAsFixed(1)
                    : '-',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 체중/신장
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                context,
                label: '체중',
                value: record.weight != null ? '${record.weight} kg' : '-',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoItem(
                context,
                label: '신장',
                value: record.height != null ? '${record.height} cm' : '-',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 흡연/음주
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                context,
                label: '흡연',
                value: record.smokingStatus?.label ?? '-',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoItem(
                context,
                label: '음주',
                value: record.drinkingLevel?.label ?? '-',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 운동 시간
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                context,
                label: '운동 시간',
                value: record.exerciseHours != null
                    ? '${record.exerciseHours!.toStringAsFixed(0)}시간'
                    : '-',
              ),
            ),
            const SizedBox(width: 8),
            // 빈 공간 (디자인과 일치)
            Expanded(child: const SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColorScheme.white200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColorScheme.grey300,
              letterSpacing: -0.325,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColorScheme.black100,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        onPressed: () {
          // 삭제 확인 다이얼로그
          _showDeleteConfirmDialog(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColorScheme.danger.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Text(
          '기록 삭제',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColorScheme.danger,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.32,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('기록 삭제'),
        content: const Text('이 기록을 삭제하시겠습니까?\n삭제된 기록은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 확인 다이얼로그 닫기
              Navigator.of(context).pop(); // 상세 모달 닫기
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: AppColorScheme.danger),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
