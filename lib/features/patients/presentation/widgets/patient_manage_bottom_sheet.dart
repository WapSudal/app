import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/app_outlined_text_field.dart';
import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/presentation/widgets/no_data_paint.dart';

class PatientManageBottomSheet extends StatefulWidget {
  const PatientManageBottomSheet({super.key});

  static Future<void> show({required BuildContext context}) {
    return AppBottomSheet.show(
      context: context,
      title: '환자 연결 관리',
      heightRatio: 0.6,
      showCloseButton: true,
      child: PatientManageBottomSheet(),
    );
  }

  @override
  State<PatientManageBottomSheet> createState() =>
      _PatientManageBottomSheetState();
}

class _PatientManageBottomSheetState extends State<PatientManageBottomSheet> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 탭 바
        AppSegmentedTabBar(
          items: [
            const SegmentedTabItem(label: '수락 대기중', value: 0),
            const SegmentedTabItem(label: '새 환자 연결', value: 1),
          ],
          selectedIndex: _selectedTabIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
        ),
        const SizedBox(height: 16),
        Flexible(
          child: _selectedTabIndex == 0
              ? _buildRequestedList()
              : _buildCreateRequestList(),
        ),
      ],
    );
  }

  Widget _buildRequestedList() {
    return const NoDataPaint(title: '연결 신청이 없어요', subtitle: '환자에게 연결을 요청해주세요');
  }

  Widget _buildCreateRequestList() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('연결하려는 환자의 정보를 입력해주세요.', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        AppOutlinedTextField(label: '이름'),
        const SizedBox(height: 16),
        AppOutlinedTextField(label: '생년월일'),
        const SizedBox(height: 16),
        AppOutlinedTextField(label: '이메일'),
        const Spacer(),
        AppFlatButton(text: '연결 요청', isExpanded: true, onPressed: () => {}),
      ],
    );
  }
}
