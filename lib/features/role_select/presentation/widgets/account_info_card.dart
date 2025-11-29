import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

/// 계정 정보 카드 위젯
///
/// 프로필 이미지, 이름, 이메일, 계정 전환 버튼을 표시하는 카드
class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({
    super.key,
    required this.name,
    required this.email,
    this.onSwitchAccount,
  });

  /// 사용자 이름
  final String name;

  /// 사용자 이메일
  final String email;

  /// 계정 전환 버튼 콜백 (null이면 버튼 비활성화)
  final VoidCallback? onSwitchAccount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: AppColorScheme.white200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColorScheme.white100,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.hardEdge,
            child: Center(
              child: Assets.icons.defaultProfile.svg(width: 50, height: 50),
            ),
          ),
          const SizedBox(width: 12),
          // 이름 및 이메일
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColorScheme.black100,
                  ),
                ),
                Text(
                  email,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColorScheme.grey300,
                  ),
                ),
              ],
            ),
          ),
          // 계정 전환 버튼
          TextButton(
            onPressed: onSwitchAccount,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              minimumSize: const Size(66, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '계정 전환',
              style: textTheme.labelSmall?.copyWith(
                color: onSwitchAccount != null
                    ? AppColorScheme.black100
                    : AppColorScheme.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
