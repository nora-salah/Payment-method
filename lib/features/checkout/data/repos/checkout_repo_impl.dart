import 'package:dartz/dartz.dart';

import 'package:payment_thrwat_samy/core/errors/failures.dart';
import 'package:payment_thrwat_samy/core/utils/stripe_service.dart';

import 'package:payment_thrwat_samy/features/checkout/data/models/payment_intent_input_model.dart';

import 'checkout_repo.dart';

class CheckoutRepoImpl implements CheckoutRepo {
  final StripeService stripeService = StripeService();

  @override
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await stripeService.makePayment(
          paymentIntentInputModel: paymentIntentInputModel);
      return right(null);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
