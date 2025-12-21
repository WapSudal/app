import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/app_icon.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_outlined_textarea.dart';
import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/presentation/widgets/no_data_paint.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../providers/memo_notifier.dart';

class MemoBottomSheet extends ConsumerStatefulWidget {
  const MemoBottomSheet({super.key, required this.patientEmail});

  final String patientEmail;

  static Future<void> show({
    required BuildContext context,
    required String patientEmail,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: '메모 관리',
      heightRatio: 0.6,
      showCloseButton: true,
      child: MemoBottomSheet(patientEmail: patientEmail),
    );
  }

  @override
  ConsumerState<MemoBottomSheet> createState() => _MemoBottomSheetState();
}

class _MemoBottomSheetState extends ConsumerState<MemoBottomSheet> {
  int _selectedTabIndex = 0;
  final _memoContentController = TextEditingController();

  @override
  void dispose() {
    _memoContentController.dispose();
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
            const SegmentedTabItem(label: '작성했던 메모', value: 0),
            const SegmentedTabItem(label: '새 메모', value: 1),
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
          child: _selectedTabIndex == 0 ? _buildMemoList() : _buildCreateMemo(),
        ),
      ],
    );
  }

  Widget _buildMemoList() {
    final state = ref.watch(memoProvider(patientEmail: widget.patientEmail));

    return state.when(
      data: (state) {
        if (state.memos.isEmpty) {
          return const NoDataPaint(title: '메모가 없어요', subtitle: '새 메모를 작성해주세요');
        }

        return ListView.separated(
          itemCount: state.memos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final memo = state.memos[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColorScheme.white100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColorScheme.white400),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memo.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '작성일: ${DateFormat('yyyy년 MM월 dd일').format(memo.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColorScheme.grey400),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: AppIcon(
                      Assets.icons.bin,
                      size: 21,
                      color: AppColorScheme.danger,
                    ),
                    onPressed: () {
                      // TODO: 메모 삭제 기능 구현
                    },
                  ),
                ],
              ),
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

  Widget _buildCreateMemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppOutlinedTextArea(
            placeholder: '메모 작성',
            controller: _memoContentController,
            keyboardType: TextInputType.multiline,
            isExpanded: true,
            maxLines: null,
          ),
        ),
        const SizedBox(height: 16),
        AppFlatButton(
          text: '메모 저장',
          isExpanded: true,
          onPressed: _handleCreateMemo,
        ),
      ],
    );
  }

  Future<void> _handleCreateMemo() async {
    final memoContent = _memoContentController.text.trim();

    if (memoContent.isEmpty) {
      _showErrorDialog('메모 내용을 입력해주세요');
      return;
    }

    try {
      final notifier = ref.read(
        memoProvider(patientEmail: widget.patientEmail).notifier,
      );

      await notifier.createMemo(
        patientEmail: widget.patientEmail,
        content: memoContent,
      );

      if (mounted) {
        // 메모 탭으로 전환
        setState(() {
          _selectedTabIndex = 0;
        });
        // 부모 화면의 ScaffoldMessenger에 메시지 표시
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('메모를 저장했습니다')));
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
