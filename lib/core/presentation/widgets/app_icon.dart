import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';
import '../../../gen/assets.gen.dart';

class AppIcon extends StatelessWidget {
  final SvgGenImage icon;
  final double size;
  final Color? color;

  const AppIcon(this.icon, {super.key, this.size = 24.0, this.color});

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(icon.path, packageName: "stroke_spoiler"),
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
