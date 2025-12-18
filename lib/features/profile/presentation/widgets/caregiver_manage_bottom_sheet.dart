import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/presentation/widgets/no_data_paint.dart';
import 'account_request_tile.dart';
import 'linked_account_info_tile.dart';

/// 관리 타입 (보호자/주치의)
enum ManageType { guardian, physician }

/// 더미 연결 계정 데이터
class _LinkedAccount {
  final String name;
  final String email;
  final String? profileImage;

  const _LinkedAccount({
    required this.name,
    required this.email,
    this.profileImage,
  });
}

/// 더미 요청 데이터
class _AccountRequest {
  final String name;
  final String email;
  final String? profileImage;
  final String requestedAt;

  const _AccountRequest({
    required this.name,
    required this.email,
    this.profileImage,
    required this.requestedAt,
  });
}

/// 보호자/주치의 관리 Bottom Sheet
///
/// [ManageType]에 따라 보호자 또는 주치의 관리 모달을 표시합니다.
/// "내 보호자/주치의" 탭과 "수락 요청" 탭으로 구성됩니다.
class CaregiverManageBottomSheet extends StatefulWidget {
  const CaregiverManageBottomSheet({super.key, required this.type});

  /// 관리 타입 (보호자/주치의)
  final ManageType type;

  /// Bottom Sheet를 표시합니다.
  static Future<void> show({
    required BuildContext context,
    required ManageType type,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: type == ManageType.guardian ? '보호자 관리' : '주치의 관리',
      heightRatio: 0.6,
      showCloseButton: true,
      child: CaregiverManageBottomSheet(type: type),
    );
  }

  @override
  State<CaregiverManageBottomSheet> createState() =>
      _CaregiverManageBottomSheetState();
}

class _CaregiverManageBottomSheetState
    extends State<CaregiverManageBottomSheet> {
  int _selectedTabIndex = 0;

  // 더미 데이터: 연결된 계정 목록
  final List<_LinkedAccount> _linkedAccounts = const [
    _LinkedAccount(name: '홍길동', email: 'example@gmail.com'),
    _LinkedAccount(name: '김철수', email: 'chulsoo@gmail.com'),
    _LinkedAccount(name: '이영희', email: 'younghee@gmail.com'),
  ];

  // 더미 데이터: 수락 요청 목록
  final List<_AccountRequest> _accountRequests = const [
    _AccountRequest(name: '박민수', email: 'minsu@gmail.com', requestedAt: '4일 전'),
  ];

  String get _myTabLabel =>
      widget.type == ManageType.guardian ? '내 보호자' : '내 주치의';

  String get _emptyMainText =>
      widget.type == ManageType.guardian ? '아직 보호자가 없네요' : '아직 주치의가 없네요';

  String get _emptySubText => widget.type == ManageType.guardian
      ? '보호자에게 연결 요청을 해주세요'
      : '주치의에게 연결 요청을 해주세요';

  String get _emptyRequestMainText =>
      widget.type == ManageType.guardian ? '아직 수락 요청이 없네요' : '아직 수락 요청이 없네요';

  String get _emptyRequestSubText => widget.type == ManageType.guardian
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
    if (_linkedAccounts.isEmpty) {
      return NoDataPaint(title: _emptyMainText, subtitle: _emptySubText);
    }

    return SingleChildScrollView(
      child: Column(
        children: _linkedAccounts.map((account) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LinkedAccountInfoTile(
              name: account.name,
              email: account.email,
              profileImage: account.profileImage,
              onDelete: () {
                // TODO: 삭제 로직 구현
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  /// "수락 요청" 탭 콘텐츠
  Widget _buildRequestList() {
    if (_accountRequests.isEmpty) {
      return NoDataPaint(
        title: _emptyRequestMainText,
        subtitle: _emptyRequestSubText,
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: _accountRequests.map((request) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AccountRequestTile(
              name: request.name,
              email: request.email,
              profileImage: request.profileImage,
              requestedAt: request.requestedAt,
              onReject: () {
                // TODO: 거절 로직 구현
              },
              onAccept: () {
                // TODO: 수락 로직 구현
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
