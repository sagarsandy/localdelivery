import 'package:flutter/material.dart';
import '../theme/ld_colors.dart';

/// Full-screen or inline loading indicator.
class LDLoadingWidget extends StatelessWidget {
  const LDLoadingWidget({
    super.key,
    this.message,
    this.fullScreen = true,
  });

  final String? message;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: LDColors.primary),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: LDColors.textSecondary,
                ),
          ),
        ],
      ],
    );

    if (!fullScreen) return Center(child: content);

    return Scaffold(
      backgroundColor: LDColors.background,
      body: Center(child: content),
    );
  }
}

/// Shimmer-style skeleton placeholder.
class LDShimmerBox extends StatefulWidget {
  const LDShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<LDShimmerBox> createState() => _LDShimmerBoxState();
}

class _LDShimmerBoxState extends State<LDShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: LDColors.shimmer,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
    );
  }
}
