import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String name;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/$name',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
