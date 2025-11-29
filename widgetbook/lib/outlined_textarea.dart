import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_outlined_textarea.dart';

@widgetbook.UseCase(name: 'Outlined Textarea', type: AppOutlinedTextArea)
Widget buildAppOutlinedTextAreaUseCase(BuildContext context) {
  final placeholder = context.knobs.string(
    label: 'Placeholder',
    initialValue: 'Placeholder',
  );
  final hasError = context.knobs.boolean(
    label: 'Show Error',
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isExpanded = context.knobs.boolean(
    label: 'Expanded',
    initialValue: false,
  );
  final readOnly = context.knobs.boolean(
    label: 'Read Only',
    initialValue: false,
  );
  final minLines = context.knobs.int.input(label: 'Min Lines', initialValue: 3);
  final maxLines = context.knobs.intOrNull.input(
    label: 'Max Lines (null = unlimited)',
    initialValue: null,
  );

  return _OutlinedTextAreaDemo(
    placeholder: placeholder,
    hasError: hasError,
    isEnabled: isEnabled,
    isExpanded: isExpanded,
    readOnly: readOnly,
    minLines: minLines,
    maxLines: maxLines,
  );
}

class _OutlinedTextAreaDemo extends StatefulWidget {
  const _OutlinedTextAreaDemo({
    required this.placeholder,
    required this.hasError,
    required this.isEnabled,
    required this.isExpanded,
    required this.readOnly,
    required this.minLines,
    this.maxLines,
  });

  final String placeholder;
  final bool hasError;
  final bool isEnabled;
  final bool isExpanded;
  final bool readOnly;
  final int minLines;
  final int? maxLines;

  @override
  State<_OutlinedTextAreaDemo> createState() => _OutlinedTextAreaDemoState();
}

class _OutlinedTextAreaDemoState extends State<_OutlinedTextAreaDemo> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppOutlinedTextArea(
      placeholder: widget.placeholder,
      controller: _controller,
      enabled: widget.isEnabled,
      errorText: widget.hasError ? 'Error message' : null,
      isExpanded: widget.isExpanded,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
    );
  }
}
