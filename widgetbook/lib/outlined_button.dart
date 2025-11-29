import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_outlined_button.dart';
import 'package:stroke_spoiler/gen/assets.gen.dart';
import 'package:stroke_spoiler/core/presentation/widgets/app_icon.dart';

@widgetbook.UseCase(name: 'Outlined Button', type: AppOutlinedButton)
Widget buildAppOutlinedButtonUseCase(BuildContext context) {
  return AppOutlinedButton(
    text: context.knobs.string(label: 'Text', initialValue: 'Outlined Button'),
    icon: context.knobs.objectOrNull.dropdown<AppIcon>(
      label: 'Icon',
      labelBuilder: (value) => value.icon.path.split('/').last.split('.').first,
      options: Assets.icons.values
          .map((icon) => AppIcon(icon, size: 16, packageName: 'stroke_spoiler'))
          .toList(),
    ),
    isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
    isExpanded: context.knobs.boolean(label: 'Expanded', initialValue: false),
    onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
        ? () {}
        : null,
  );
}
