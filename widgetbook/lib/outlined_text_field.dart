import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_outlined_text_field.dart';

@widgetbook.UseCase(name: 'Outlined Textfield', type: AppOutlinedTextField)
Widget buildAppOutlinedTextFieldUseCase(BuildContext context) {
  final hasError = context.knobs.boolean(
    label: 'Show Error',
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isExpanded = context.knobs.boolean(
    label: 'Expanded',
    initialValue: false,
  );
  final obscureText = context.knobs.boolean(
    label: 'Obscure Text (Password)',
    initialValue: false,
  );
  final showClearButton = context.knobs.boolean(
    label: 'Show Clear Button',
    initialValue: true,
  );
  final readOnly = context.knobs.boolean(
    label: 'Read Only',
    initialValue: false,
  );

  return _OutlinedTextFieldDemo(
    hasError: hasError,
    isEnabled: isEnabled,
    isExpanded: isExpanded,
    obscureText: obscureText,
    showClearButton: showClearButton,
    readOnly: readOnly,
  );
}

class _OutlinedTextFieldDemo extends StatefulWidget {
  const _OutlinedTextFieldDemo({
    required this.hasError,
    required this.isEnabled,
    required this.isExpanded,
    required this.obscureText,
    required this.showClearButton,
    required this.readOnly,
  });

  final bool hasError;
  final bool isEnabled;
  final bool isExpanded;
  final bool obscureText;
  final bool showClearButton;
  final bool readOnly;

  @override
  State<_OutlinedTextFieldDemo> createState() => _OutlinedTextFieldDemoState();
}

class _OutlinedTextFieldDemoState extends State<_OutlinedTextFieldDemo> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppOutlinedTextField(
      label: 'Label',
      controller: _controller,
      enabled: widget.isEnabled,
      errorText: widget.hasError ? 'Error message' : null,
      isExpanded: widget.isExpanded,
      obscureText: widget.obscureText,
      showClearButton: widget.showClearButton,
      readOnly: widget.readOnly,
    );
  }
}
