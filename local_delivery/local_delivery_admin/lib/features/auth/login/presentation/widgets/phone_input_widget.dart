import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class PhoneInputWidget extends StatelessWidget {
  const PhoneInputWidget({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MOBILE NUMBER',
          style: context.labelMedium.copyWith(
            color: LDColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: LDColors.inputFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: LDColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: LDColors.border),
                  ),
                ),
                child: Text(
                  '+91',
                  style: context.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onSubmitted?.call(),
                  style: context.bodyLarge,
                  decoration: InputDecoration(
                    hintText: '000-000-0000',
                    hintStyle: context.bodyLarge.copyWith(color: LDColors.textDisabled),
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
