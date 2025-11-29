import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';
import '../../../gen/assets.gen.dart';

class AppIcon extends StatelessWidget {
  final SvgGenImage icon;
  final double size;
  final Color? color;

  /// Widgetbook에서 사용 시 'stroke_spoiler'로 설정
  final String? packageName;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = 24.0,
    this.color,
    this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(icon.path, packageName: packageName),
      width: size,
      height: size,

      // 색상 적용 방식
      colorFilter: ColorFilter.mode(
        color ?? IconTheme.of(context).color!,
        BlendMode.srcIn,
      ),
    );
  }
}
