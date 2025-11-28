import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_flat_button.dart';
import 'package:stroke_spoiler/gen/assets.gen.dart';
import 'package:stroke_spoiler/core/presentation/widgets/app_icon.dart';

@widgetbook.UseCase(name: 'Flat Button', type: AppFlatButton)
Widget buildAppFlatButtonUseCase(BuildContext context) {
  return AppFlatButton(
    text: 'Button',
    icon: context.knobs.objectOrNull.dropdown<AppIcon>(
      label: 'Icon',
      labelBuilder: (value) => value.icon.path.split('/').last.split('.').first,
      options: Assets.icons.values
          .map((icon) => AppIcon(icon, size: 16))
          .toList(),
    ),
    isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
    isExpanded: context.knobs.boolean(label: 'Expanded', initialValue: false),
    onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
        ? () {}
        : null,
  );
}
