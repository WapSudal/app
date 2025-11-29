import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_lined_dropdown.dart';
import 'package:stroke_spoiler/core/presentation/widgets/dropdown_menu.dart';

@widgetbook.UseCase(name: 'Lined Dropdown', type: AppLinedDropdown)
Widget buildAppLinedDropdownUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Label');
  final items = [
    const DropdownItem(value: 'option1', label: 'Menu Element 1'),
    const DropdownItem(value: 'option2', label: 'Menu Element 2'),
    const DropdownItem(value: 'option3', label: 'Menu Element 3'),
    const DropdownItem(value: 'option4', label: 'Menu Element 4'),
  ];

  final hasError = context.knobs.boolean(
    label: 'Show Error',
    initialValue: false,
  );
  final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  final isExpanded = context.knobs.boolean(
    label: 'Expanded',
    initialValue: false,
  );

  return _LinedDropdownDemo(
    label: label,
    items: items,
    hasError: hasError,
    isEnabled: isEnabled,
    isExpanded: isExpanded,
  );
}

class _LinedDropdownDemo extends StatefulWidget {
  const _LinedDropdownDemo({
    required this.label,
    required this.items,
    required this.hasError,
    required this.isEnabled,
    required this.isExpanded,
  });

  final String label;
  final List<DropdownItem<String>> items;
  final bool hasError;
  final bool isEnabled;
  final bool isExpanded;

  @override
  State<_LinedDropdownDemo> createState() => _LinedDropdownDemoState();
}

class _LinedDropdownDemoState extends State<_LinedDropdownDemo> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return AppLinedDropdown<String>(
      items: widget.items,
      value: selectedValue,
      onChanged: widget.isEnabled
          ? (value) => setState(() => selectedValue = value)
          : null,
      label: widget.label,
      errorText: widget.hasError ? 'Selection Required' : null,
      isEnabled: widget.isEnabled,
      isExpanded: widget.isExpanded,
    );
  }
}
