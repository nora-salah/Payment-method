import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_thrwat_samy/core/utils/api_keys.dart';

import 'features/checkout/presentation/views/my_card_view.dart';

void main() {
  Stripe.publishableKey = ApiKeys.publishableKey;

  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCartView(),
    );
  }
}

//// here i want to handle continue btn to execute 2 different operaion 1 with paypal 2 with stripe know it execute stripe scuccess
// in 69 i have error with Map< Sting, String> take String do not Know where
// from here git test account https://developer.paypal.com/dashboard/dashboard/sandbox
