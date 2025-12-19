import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';

/// 연결된 계정 정보 타일
///
/// 보호자/주치의 목록에서 각 항목을 표시하는 위젯입니다.
/// 프로필 이미지, 이름, 이메일, 삭제 버튼을 포함합니다.
class LinkedAccountInfoTile extends StatelessWidget {
  const LinkedAccountInfoTile({
    super.key,
    required this.name,
    required this.email,
    this.profileImage,
    this.onRevoke,
  });

  /// 이름
  final String name;

  /// 이메일
  final String email;

  /// 프로필 이미지 URL (null이면 기본 이미지 사용)
  final String? profileImage;

  /// 삭제 버튼 콜백
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColorScheme.white200, width: 1.5),
      ),
      child: Row(
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
          // 삭제 버튼
          _buildDeleteButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 40,
      height: 40,
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
                return Assets.icons.defaultProfile.svg(width: 40, height: 40);
              },
            )
          : Assets.icons.defaultProfile.svg(width: 40, height: 40),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return GestureDetector(
      onTap: onRevoke,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColorScheme.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '삭제',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColorScheme.danger),
          ),
        ),
      ),
    );
  }
}
