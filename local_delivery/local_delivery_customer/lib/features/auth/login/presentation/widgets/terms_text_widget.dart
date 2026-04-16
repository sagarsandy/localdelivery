import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class TermsTextWidget extends StatelessWidget {
  const TermsTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: context.bodySmall.copyWith(color: LDColors.textSecondary),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: context.bodySmall.copyWith(color: LDColors.accent),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: context.bodySmall.copyWith(color: LDColors.accent),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
