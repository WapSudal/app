import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';

enum AppButtonType { filled, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.filled,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final Widget? icon;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final Widget button = SizedBox(
      height: 50,
      child: type == AppButtonType.filled
          ? _buildFilledButton(context)
          : _buildOutlineButton(context),
    );

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildFilledButton(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColorScheme.primaryColor,
        foregroundColor: AppColorScheme.white100,
        disabledBackgroundColor: AppColorScheme.primaryColor,
        disabledForegroundColor: AppColorScheme.white100.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: _buildContent(),
    );
  }

  Widget _buildOutlineButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorScheme.primaryColor,
        side: BorderSide(
          color: onPressed == null
              ? AppColorScheme.grey400
              : AppColorScheme.primaryColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: _buildContent(isOutline: true),
    );
  }

  Widget _buildContent({bool isOutline = false}) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutline ? AppColorScheme.primaryColor : AppColorScheme.white100,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon!, const SizedBox(width: 4), Text(text)],
      );
    }

    return Text(text);
  }
}
