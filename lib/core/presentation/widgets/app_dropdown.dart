import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import '../../theme/text_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.labelText,
    this.errorText,
    this.enabled = true,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16, // L1 Size
        fontWeight: FontWeight.w500,
        color: AppColorScheme.black100,
        letterSpacing: -0.32,
      ),
      icon: const Icon(
        Icons.arrow_drop_down_rounded,
        color: AppColorScheme.grey400,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        enabled: enabled,
        filled: true,
        fillColor: enabled ? AppColorScheme.white100 : AppColorScheme.grey100.withValues(alpha: 0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13), // Height 50px matching
        
        // Borders
        border: _buildBorder(AppColorScheme.grey500),
        enabledBorder: _buildBorder(AppColorScheme.grey500),
        focusedBorder: _buildBorder(AppColorScheme.primaryColor, width: 1.0), // Active State
        errorBorder: _buildBorder(AppColorScheme.danger),
        focusedErrorBorder: _buildBorder(AppColorScheme.danger),
        disabledBorder: _buildBorder(AppColorScheme.grey300),

        // Text Styles
        labelStyle: const TextStyle(
          color: AppColorScheme.grey400,
          fontSize: 14, // C2 Size check needed, but using standard label size
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: AppColorScheme.grey400,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      dropdownColor: AppColorScheme.white100,
      borderRadius: BorderRadius.circular(12), // Menu Radius
      elevation: 4, // Simple elevation, shadow is handled by Material
      isExpanded: true,
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
