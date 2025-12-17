import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

/// 계정 요청 타일
///
/// 보호자/주치의 수락 요청 목록에서 각 항목을 표시하는 위젯입니다.
/// 프로필 이미지, 이름, 이메일, 요청일, 거절/수락 버튼을 포함합니다.
class AccountRequestTile extends StatelessWidget {
  const AccountRequestTile({
    super.key,
    required this.name,
    required this.email,
    this.profileImage,
    this.requestedAt,
    this.onReject,
    this.onAccept,
  });

  /// 이름
  final String name;

  /// 이메일
  final String email;

  /// 프로필 이미지 URL (null이면 기본 이미지 사용)
  final String? profileImage;

  /// 요청일 (예: "4일 전")
  final String? requestedAt;

  /// 거절 버튼 콜백
  final VoidCallback? onReject;

  /// 수락 버튼 콜백
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColorScheme.white200, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단: 프로필 정보 + 요청일
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 이미지
              _buildProfileImage(),
              const SizedBox(width: 12),
              // 이름 & 이메일
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColorScheme.black100,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColorScheme.grey300,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // 요청일
              if (requestedAt != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    requestedAt!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColorScheme.grey300,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // 하단: 거절/수락 버튼
          Row(
            children: [
              // 거절 버튼
              Expanded(child: _buildRejectButton(context)),
              const SizedBox(width: 4),
              // 수락 버튼
              Expanded(child: _buildAcceptButton(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 44,
      height: 44,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: AppColorScheme.white100,
        shape: BoxShape.circle,
      ),
      child: profileImage != null
          ? Image.network(
              profileImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Assets.icons.defaultProfile.svg(width: 44, height: 44);
              },
            )
          : Assets.icons.defaultProfile.svg(width: 44, height: 44),
    );
  }

  Widget _buildRejectButton(BuildContext context) {
    return GestureDetector(
      onTap: onReject,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: AppColorScheme.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '거절',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColorScheme.danger),
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return GestureDetector(
      onTap: onAccept,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: AppColorScheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '수락',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColorScheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
