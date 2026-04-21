import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class OtpAppBarWidget extends StatelessWidget {
  const OtpAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.only(right: 12, top: 4, bottom: 4),
            child: Icon(Icons.arrow_back_ios_new, size: 18),
          ),
        ),
        const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco_rounded, color: LDColors.primary, size: 20),
              SizedBox(width: 6),
              Text(
                'Local Market',
                style: TextStyle(
                  color: LDColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }
}
