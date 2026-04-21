import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class ResendCodeWidget extends StatefulWidget {
  const ResendCodeWidget({
    super.key,
    required this.onResend,
    this.initialSeconds = 60,
  });

  final VoidCallback onResend;
  final int initialSeconds;

  @override
  State<ResendCodeWidget> createState() => _ResendCodeWidgetState();
}

class _ResendCodeWidgetState extends State<ResendCodeWidget> {
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds == 0) {
        _timer?.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _handleResend() {
    setState(() => _seconds = widget.initialSeconds);
    _timer?.cancel();
    _startTimer();
    widget.onResend();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't receive the code? ",
          style: TextStyle(color: LDColors.textSecondary, fontSize: 13),
        ),
        GestureDetector(
          onTap: _seconds == 0 ? _handleResend : null,
          child: Text(
            'Resend Code',
            style: TextStyle(
              color: _seconds == 0 ? LDColors.accent : LDColors.textDisabled,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (_seconds > 0) ...[
          const Text('  |  ', style: TextStyle(color: LDColors.textDisabled, fontSize: 13)),
          Text(
            _formattedTime,
            style: const TextStyle(
              color: LDColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
