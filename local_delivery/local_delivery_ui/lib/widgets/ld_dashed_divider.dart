import 'package:flutter/material.dart';
import '../theme/ld_colors.dart';

/// Horizontal dashed divider.
class LDDashedDivider extends StatelessWidget {
  const LDDashedDivider({
    super.key,
    this.color = LDColors.divider,
    this.height = 1,
    this.dashWidth = 6,
    this.gapWidth = 4,
  });

  final Color color;
  final double height;
  final double dashWidth;
  final double gapWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final count = (totalWidth / (dashWidth + gapWidth)).floor();
        return Row(
          children: List.generate(count, (_) {
            return Padding(
              padding: EdgeInsets.only(right: gapWidth),
              child: SizedBox(
                width: dashWidth,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
