import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';

/// 알림 필터 타입
enum NotificationFilterType {
  all('전체'),
  unread('읽지 않음');

  const NotificationFilterType(this.label);
  final String label;
}

/// 알림 필터 버튼 그룹
///
/// "전체" / "읽지 않음" 두 가지 필터를 제공합니다.
class NotificationFilter extends StatelessWidget {
  const NotificationFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final NotificationFilterType selectedFilter;
  final ValueChanged<NotificationFilterType> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: NotificationFilterType.values.map((filter) {
        final isSelected = filter == selectedFilter;
        return Padding(
          padding: EdgeInsets.only(
            right: filter != NotificationFilterType.values.last ? 4 : 0,
          ),
          child: _FilterButton(
            label: filter.label,
            isSelected: isSelected,
            onTap: () => onFilterChanged(filter),
          ),
        );
      }).toList(),
    );
  }
}

/// 필터 버튼 (개별)
class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColorScheme.black100
                : AppColorScheme.white200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Pretendard Variable',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 18 / 13,
                letterSpacing: -0.32,
                color: isSelected
                    ? AppColorScheme.white100
                    : AppColorScheme.black100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
