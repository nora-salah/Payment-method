import 'package:flutter/material.dart';
import 'package:payment_thrwat_samy/features/checkout/presentation/views/widgets/thank_you_view_body.dart';

import '../../../../core/widgets/custom_app_bar.dart';

class ThankYouView extends StatelessWidget {
  const ThankYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Transform.translate(
          offset: const Offset(0, -16), child: const ThankYouViewBody()),
    );
  }
}
