import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/app_icon.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../auth/data/providers/auth_data_providers.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../auth/presentation/providers/auth_mutations.dart';

/// 계정 관리 화면
///
/// 로그아웃, 계정 삭제 기능 제공
class AccountManageView extends ConsumerWidget {
  const AccountManageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: const CustomAppBar(mode: AppBarMode.subpage, title: '계정 관리'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: [_buildManageListCard(context, ref)]),
        ),
      ),
    );
  }

  /// 로그아웃/계정 삭제 버튼 카드
  Widget _buildManageListCard(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 로그아웃 버튼
          _buildManageButton(
            context,
            icon: Assets.icons.logout,
            iconColor: AppColorScheme.primaryColor,
            title: '로그아웃',
            onTap: () => _showLogoutDialog(context, ref),
          ),
          // 구분선
          Container(
            height: 1,
            color: AppColorScheme.black100.withValues(alpha: 0.1),
          ),
          // 계정 삭제 버튼
          _buildManageButton(
            context,
            icon: Assets.icons.backspace,
            iconColor: AppColorScheme.danger,
            title: '계정 삭제',
            onTap: () => _showDeleteAccountDialog(context, ref),
          ),
        ],
      ),
    );
  }

  /// 관리 버튼 위젯
  Widget _buildManageButton(
    BuildContext context, {
    required SvgGenImage icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // 아이콘 배경
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppIcon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            // 타이틀
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColorScheme.black100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 로그아웃 확인 다이얼로그
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    AppConfirmDialog.show(
      context: context,
      title: '로그아웃할까요?',
      description: '현재 로그인된 계정을 로그아웃할게요',
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
        // 로그아웃 버튼
        Expanded(
          child: AppFlatButton(
            text: '로그아웃',
            onPressed: () async {
              Navigator.pop(context); // 확인 다이얼로그 닫기

              // 로그아웃 실행
              signOutMutation.run(ref, (tsx) async {
                final repository = tsx.get(authRepositoryProvider);
                await repository.signOut();

                tsx.get(authProvider.notifier).clearUser();
              });
            },
          ),
        ),
      ],
    );
  }

  /// 계정 삭제 확인 다이얼로그
  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    AppConfirmDialog.show(
      context: context,
      title: '정말로 계정을 삭제하시겠어요?',
      description: '삭제 후 데이터 복구는 불가능합니다.',
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
        // 삭제 버튼
        Expanded(
          child: AppFlatButton(
            text: '삭제',
            onPressed: () {
              Navigator.pop(context); // 확인 다이얼로그 닫기

              // 계정 삭제 실행
              deleteAccountMutation
                  .run(ref, (tsx) async {
                    final repository = tsx.get(authRepositoryProvider);
                    await repository.deleteAccount();
                    tsx.get(authProvider.notifier).clearUser();
                  })
                  .then((_) {
                    if (context.mounted) {
                      _showDeleteCompleteDialog(context);
                    }
                  })
                  .catchError((e) {
                    if (context.mounted) {
                      if (e.toString().contains('requires-recent-login')) {
                        _showReauthRequiredDialog(context, ref);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('계정 삭제 실패: ${e.toString()}'),
                            backgroundColor: AppColorScheme.danger,
                          ),
                        );
                      }
                    }
                  });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColorScheme.danger),
            ),
          ),
        ),
      ],
    );
  }

  /// 계정 삭제 완료 다이얼로그
  void _showDeleteCompleteDialog(BuildContext context) {
    AppConfirmDialog.show(
      context: context,
      title: '계정을 삭제했어요',
      description: '다시 돌아와주시길 기다리고 있을게요!',
      barrierDismissible: false,
      buttons: [
        Expanded(
          child: AppFlatButton(
            text: '첫 화면으로 이동',
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              context.go('/onboarding'); // 온보딩으로 이동
            },
          ),
        ),
      ],
    );
  }

  /// 재인증 필요 다이얼로그
  void _showReauthRequiredDialog(BuildContext context, WidgetRef ref) {
    AppConfirmDialog.show(
      context: context,
      title: '재로그인이 필요합니다',
      description: '보안을 위해 계정 삭제 전 다시 로그인해주세요.',
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
        // 재로그인 버튼
        Expanded(
          child: AppFlatButton(
            text: '재로그인',
            onPressed: () {
              Navigator.pop(context);

              // 재인증 후 계정 삭제 진행
              deleteAccountMutation
                  .run(ref, (tsx) async {
                    final repository = tsx.get(authRepositoryProvider);
                    await repository.reauthenticateAndDelete();
                    tsx.get(authProvider.notifier).clearUser();
                  })
                  .then((_) {
                    if (context.mounted) {
                      _showDeleteCompleteDialog(context);
                    }
                  })
                  .catchError((e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('계정 삭제 실패: ${e.toString()}'),
                          backgroundColor: AppColorScheme.danger,
                        ),
                      );
                    }
                  });
            },
          ),
        ),
      ],
    );
  }
}
