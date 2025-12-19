import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/sharing_scope.dart';
import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_outlined_text_field.dart';
import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/presentation/widgets/no_data_paint.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/patients_manage_notifier.dart';

class PatientManageBottomSheet extends ConsumerStatefulWidget {
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
  ConsumerState<PatientManageBottomSheet> createState() =>
      _PatientManageBottomSheetState();
}

class _PatientManageBottomSheetState
    extends ConsumerState<PatientManageBottomSheet> {
  int _selectedTabIndex = 0;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
    final state = ref.watch(patientsManageProvider);

    return state.when(
      data: (state) {
        if (state.pendingPatients.isEmpty) {
          return const NoDataPaint(
            title: '연결 신청이 없어요',
            subtitle: '환자에게 연결을 요청해주세요',
          );
        }

        return ListView.separated(
          itemCount: state.pendingPatients.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final patient = state.pendingPatients[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColorScheme.white300,
                backgroundImage: patient.photoUrl != null
                    ? NetworkImage(patient.photoUrl!)
                    : null,
                child: patient.photoUrl == null
                    ? const Icon(Icons.person, color: AppColorScheme.grey400)
                    : null,
              ),
              title: Text(patient.displayName ?? ''),
              subtitle: Text(patient.email),
            );
          },
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [AppLoadingIndicator(), Text('불러오는 중')],
        ),
      ),
      error: (error, stack) => Center(
        child: Text(
          '데이터를 불러오는 중 오류가 발생했습니다.',
          style: const TextStyle(color: AppColorScheme.grey400),
        ),
      ),
    );
  }

  Widget _buildCreateRequestList() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('연결하려는 환자의 정보를 입력해주세요.', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        AppOutlinedTextField(
          label: '이메일',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const Spacer(),
        AppFlatButton(
          text: '연결 요청',
          isExpanded: true,
          onPressed: _handleCreateConnectionRequest,
        ),
      ],
    );
  }

  Future<void> _handleCreateConnectionRequest() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog('이메일을 입력해주세요');
      return;
    }

    try {
      await ref
          .read(patientsManageProvider.notifier)
          .createConnectionRequest(
            patientEmail: email,
            scope: SharingScope.full,
          );

      if (mounted) {
        // 상태 새로고침 (Bottom Sheet 닫기 전에 수행)
        ref.invalidate(patientsManageProvider);

        // Bottom Sheet 닫고 성공 메시지 전달
        Navigator.pop(context);
        // 부모 화면의 ScaffoldMessenger에 메시지 표시
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('연결 요청을 보냈습니다')));
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _showErrorDialog(String message) {
    AppConfirmDialog.show(
      context: context,
      title: '알림',
      description: message,
      buttons: [
        Expanded(
          child: AppFlatButton(
            text: '확인',
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
