import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:stroke_spoiler/core/presentation/widgets/app_button.dart';

@widgetbook.UseCase(name: 'Default', type: AppButton)
Widget buildAppButtonUseCase(BuildContext context) {
  return AppButton(text: 'Button', onPressed: () {});
}
