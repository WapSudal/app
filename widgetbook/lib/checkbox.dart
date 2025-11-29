import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_checkbox.dart';

@widgetbook.UseCase(name: 'Checkbox', type: AppCheckbox)
Widget buildAppCheckboxUseCase(BuildContext context) {
  return _CheckboxUseCase(
    initialValue: context.knobs.boolean(label: 'Checked', initialValue: false),
    label: context.knobs.stringOrNull(label: 'Label', initialValue: 'Label'),
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
  );
}

class _CheckboxUseCase extends StatefulWidget {
  const _CheckboxUseCase({
    required this.initialValue,
    this.label,
    this.enabled = true,
  });

  final bool initialValue;
  final String? label;
  final bool enabled;

  @override
  State<_CheckboxUseCase> createState() => _CheckboxUseCaseState();
}

class _CheckboxUseCaseState extends State<_CheckboxUseCase> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(_CheckboxUseCase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCheckbox(
      value: _value,
      label: widget.label,
      enabled: widget.enabled,
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _value = value;
              });
            }
          : null,
    );
  }
}
