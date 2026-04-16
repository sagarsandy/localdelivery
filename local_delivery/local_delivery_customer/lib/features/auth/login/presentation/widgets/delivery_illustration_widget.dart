import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_image.dart';

class DeliveryIllustrationWidget extends StatelessWidget {
  const DeliveryIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AppImage('brand_logo.png', fit: BoxFit.contain),
    );
  }
}
