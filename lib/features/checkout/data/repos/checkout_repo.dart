import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/payment_intent_input_model.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel});
}
