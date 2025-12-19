import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/connection_type.dart';
import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/presentation/widgets/no_data_paint.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/caregiver_connected_list_notifier.dart';
import '../providers/caregiver_request_list_notifier.dart';
import 'account_request_tile.dart';
import 'linked_account_info_tile.dart';

/// 보호자/주치의 관리 Bottom Sheet
///
/// [ManageType]에 따라 보호자 또는 주치의 관리 모달을 표시합니다.
/// "내 보호자/주치의" 탭과 "수락 요청" 탭으로 구성됩니다.
class CaregiverManageBottomSheet extends ConsumerStatefulWidget {
  const CaregiverManageBottomSheet({super.key, required this.connectionType});

  /// 관리 타입 (보호자/주치의)
  final ConnectionType connectionType;

  /// Bottom Sheet를 표시합니다.
  static Future<void> show({
    required BuildContext context,
    required ConnectionType connectionType,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: connectionType == ConnectionType.guardian ? '보호자 관리' : '주치의 관리',
      heightRatio: 0.6,
      showCloseButton: true,
      child: CaregiverManageBottomSheet(connectionType: connectionType),
    );
  }

  @override
  ConsumerState<CaregiverManageBottomSheet> createState() =>
      _CaregiverManageBottomSheetState();
}

class _CaregiverManageBottomSheetState
    extends ConsumerState<CaregiverManageBottomSheet> {
  int _selectedTabIndex = 0;

  String get _myTabLabel =>
      widget.connectionType == ConnectionType.guardian ? '내 보호자' : '내 주치의';

  String get _emptyMainText => widget.connectionType == ConnectionType.guardian
      ? '아직 보호자가 없네요'
      : '아직 주치의가 없네요';

  String get _emptySubText => widget.connectionType == ConnectionType.guardian
      ? '보호자에게 연결 요청을 해주세요'
      : '주치의에게 연결 요청을 해주세요';

  String get _emptyRequestMainText =>
      widget.connectionType == ConnectionType.guardian
      ? '아직 수락 요청이 없네요'
      : '아직 수락 요청이 없네요';

  String get _emptyRequestSubText =>
      widget.connectionType == ConnectionType.guardian
      ? '보호자에게 연결 요청을 해주세요'
      : '주치의에게 연결 요청을 해주세요';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 탭 바
        AppSegmentedTabBar(
          items: [
            SegmentedTabItem(label: _myTabLabel, value: 0),
            const SegmentedTabItem(label: '수락 요청', value: 1),
          ],
          selectedIndex: _selectedTabIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
        ),
        const SizedBox(height: 16),
        // 탭 콘텐츠
        Flexible(
          child: _selectedTabIndex == 0
              ? _buildMyLinkedList()
              : _buildRequestList(),
        ),
      ],
    );
  }

  /// "내 보호자/주치의" 탭 콘텐츠
  Widget _buildMyLinkedList() {
    final state = ref.watch(
      caregiverConnectedListProvider(connectionType: widget.connectionType),
    );
    final notifier = ref.read(
      caregiverConnectedListProvider(
        connectionType: widget.connectionType,
      ).notifier,
    );

    return state.when(
      data: (state) {
        if (state.connectedCaregivers.isEmpty) {
          return NoDataPaint(title: _emptyMainText, subtitle: _emptySubText);
        }

        return SingleChildScrollView(
          child: Column(
            children: state.connectedCaregivers.map((caregiver) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LinkedAccountInfoTile(
                  name: caregiver.displayName ?? '',
                  email: caregiver.email,
                  profileImage: caregiver.photoUrl,
                  onRevoke: () {
                    _showRevokeDialog(
                      context,
                      caregiver.displayName ?? caregiver.email,
                      caregiver.email,
                      notifier,
                    );
                  },
                ),
              );
            }).toList(),
          ),
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

  /// "수락 요청" 탭 콘텐츠
  Widget _buildRequestList() {
    final state = ref.watch(
      caregiverRequestListProvider(connectionType: widget.connectionType),
    );
    final notifier = ref.read(
      caregiverRequestListProvider(
        connectionType: widget.connectionType,
      ).notifier,
    );

    return state.when(
      data: (state) {
        if (state.pendingCaregivers.isEmpty) {
          return NoDataPaint(
            title: _emptyRequestMainText,
            subtitle: _emptyRequestSubText,
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: state.pendingCaregivers.map((request) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AccountRequestTile(
                  name: request.displayName ?? '',
                  email: request.email,
                  profileImage: request.photoUrl,
                  onReject: () {
                    _showRejectDialog(
                      context,
                      request.displayName ?? request.email,
                      request.email,
                      notifier,
                    );
                  },
                  onAccept: () {
                    _showAcceptDialog(
                      context,
                      request.displayName ?? request.email,
                      request.email,
                      notifier,
                    );
                  },
                ),
              );
            }).toList(),
          ),
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

  /// 연결 해제 확인 다이얼로그
  void _showRevokeDialog(
    BuildContext context,
    String name,
    String email,
    dynamic notifier,
  ) {
    final roleLabel =
        widget.connectionType == ConnectionType.guardian ? '보호자' : '주치의';

    AppConfirmDialog.show(
      context: context,
      title: '$roleLabel 연결을 해제할까요?',
      description: '$name님과의 연결을 해제합니다.',
      buttons: [
        // 취소 버튼
        Expanded(
          child: AppFlatButton(
            text: '취소',
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.white300),
              foregroundColor: WidgetStateProperty.all(AppColorScheme.black100),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 해제 버튼
        Expanded(
          child: AppFlatButton(
            text: '해제',
            onPressed: () {
              Navigator.pop(context);
              notifier.revokeCaregiverConnection(email);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.danger),
            ),
          ),
        ),
      ],
    );
  }

  /// 요청 수락 확인 다이얼로그
  void _showAcceptDialog(
    BuildContext context,
    String name,
    String email,
    dynamic notifier,
  ) {
    final roleLabel =
        widget.connectionType == ConnectionType.guardian ? '보호자' : '주치의';

    AppConfirmDialog.show(
      context: context,
      title: '$roleLabel 요청을 수락할까요?',
      description: '$name님의 연결 요청을 수락합니다.',
      buttons: [
        // 취소 버튼
        Expanded(
          child: AppFlatButton(
            text: '취소',
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.white300),
              foregroundColor: WidgetStateProperty.all(AppColorScheme.black100),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 수락 버튼
        Expanded(
          child: AppFlatButton(
            text: '수락',
            onPressed: () {
              Navigator.pop(context);
              notifier.acceptCaregiverRequest(email);
            },
          ),
        ),
      ],
    );
  }

  /// 요청 거절 확인 다이얼로그
  void _showRejectDialog(
    BuildContext context,
    String name,
    String email,
    dynamic notifier,
  ) {
    final roleLabel =
        widget.connectionType == ConnectionType.guardian ? '보호자' : '주치의';

    AppConfirmDialog.show(
      context: context,
      title: '$roleLabel 요청을 거절할까요?',
      description: '$name님의 연결 요청을 거절합니다.',
      buttons: [
        // 취소 버튼
        Expanded(
          child: AppFlatButton(
            text: '취소',
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.white300),
              foregroundColor: WidgetStateProperty.all(AppColorScheme.black100),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 거절 버튼
        Expanded(
          child: AppFlatButton(
            text: '거절',
            onPressed: () {
              Navigator.pop(context);
              notifier.rejectCaregiverRequest(email);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.danger),
            ),
          ),
        ),
      ],
    );
  }
}
