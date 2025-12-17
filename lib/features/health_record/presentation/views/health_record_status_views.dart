import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/theme/color_scheme.dart';

class HealthRecordSavingView extends StatelessWidget {
  const HealthRecordSavingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColorScheme.white100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🚀',
              style: TextStyle(fontFamily: 'TossFace', fontSize: 72),
            ),
            const SizedBox(height: 24),
            Text(
              '정보 저장중...',
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColorScheme.black100,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '사용자님의 정보를 안전하게 보관하고 있어요',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColorScheme.grey300,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class HealthRecordSuccessView extends StatelessWidget {
  const HealthRecordSuccessView({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColorScheme.white100,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🎉',
                  style: TextStyle(fontFamily: 'TossFace', fontSize: 72),
                ),
                const SizedBox(height: 24),
                Text(
                  '정보 저장 완료!',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppColorScheme.black100,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '사용자님의 건강 정보를 다시 분석할게요',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColorScheme.grey300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 34),
                child: AppFlatButton(
                  text: '닫기',
                  onPressed: onClose,
                  isExpanded: true,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
