import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_button.dart';
import 'package:stroke_spoiler/gen/assets.gen.dart';
import 'package:stroke_spoiler/core/presentation/widgets/app_icon.dart';

@widgetbook.UseCase(name: 'Default', type: AppButton)
Widget buildAppButtonUseCase(BuildContext context) {
  return AppButton(
    text: 'Button',
    type: context.knobs.object.segmented<AppButtonType>(
      label: 'Button Type',
      labelBuilder: (value) =>
          value == AppButtonType.filled ? 'Filled' : 'Outline',
      options: const [AppButtonType.filled, AppButtonType.outline],
    ),
    icon: context.knobs.objectOrNull.dropdown<AppIcon>(
      label: 'Icon',
      labelBuilder: (value) => value.icon.path.split('/').last.split('.').first,
      options: Assets.icons.values
          .map((icon) => AppIcon(icon, size: 16))
          .toList(),
    ),
    onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
        ? () {}
        : null,
  );
}
