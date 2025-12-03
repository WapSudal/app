import 'package:cached_network_image/cached_network_image.dart';
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
    this.photoUrl,
    this.onSwitchAccount,
    this.isLoading = false,
  });

  /// 사용자 이름
  final String name;

  /// 사용자 이메일
  final String email;

  /// 프로필 이미지 URL (nullable)
  final String? photoUrl;

  /// 계정 전환 버튼 콜백 (null이면 버튼 비활성화)
  final VoidCallback? onSwitchAccount;

  /// 로딩 중 여부 (계정 전환 중)
  final bool isLoading;

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
          _buildProfileImage(),
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
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
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

  /// 프로필 이미지 빌드
  Widget _buildProfileImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: AppColorScheme.white100,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: photoUrl != null && photoUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: photoUrl!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: Assets.icons.defaultProfile.svg(width: 50, height: 50),
              ),
              errorWidget: (context, url, error) => Center(
                child: Assets.icons.defaultProfile.svg(width: 50, height: 50),
              ),
            )
          : Center(
              child: Assets.icons.defaultProfile.svg(width: 50, height: 50),
            ),
    );
  }
}
