import 'package:flutter/material.dart';

import '../../theme/color_scheme.dart';
import 'no_data_paint.dart';

class NoDataCard extends StatelessWidget {
  const NoDataCard({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: NoDataPaint(title: title, subtitle: subtitle),
    );
  }
}
