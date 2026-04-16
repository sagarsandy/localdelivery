import 'package:flutter/material.dart';

/// Central widget for displaying local asset images.
///
/// Pass only the file name (e.g. `'brand_logo.png'`) — the path prefix
/// `assets/` is applied here automatically. To change how images are
/// displayed across the entire app (e.g. add a fade-in, error placeholder,
/// or swap to a cached-network image), update this single file.
///
/// Usage:
/// ```dart
/// AppImage('brand_logo.png')
/// AppImage('brand_logo.png', width: 200, fit: BoxFit.contain)
/// ```
class AppImage extends StatelessWidget {
  const AppImage(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  /// File name inside the `assets/` folder (e.g. `'brand_logo.png'`).
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
