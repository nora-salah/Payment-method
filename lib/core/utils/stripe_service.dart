import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_thrwat_samy/core/utils/api_keys.dart';
import 'package:payment_thrwat_samy/core/utils/api_service.dart';
import 'package:payment_thrwat_samy/features/checkout/data/models/emphemeral_key_model/emphemeral_key_model.dart';
import 'package:payment_thrwat_samy/features/checkout/data/models/payment_intent_input_model.dart';

import '../../features/checkout/data/models/init_payment_sheet_input_model .dart';
import '../../features/checkout/data/models/payments_intent_model/payments_intent_model.dart';

class StripeService {
  final ApiService apiService = ApiService();

  Future<PaymentsIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      body: paymentIntentInputModel.toJson(),
      url: 'https://api.stripe.com/v1/payment_intents',
      token: ApiKeys.secretKey,
    );
    var paymentIntentModel = PaymentsIntentModel.fromJson(response.data);
    return paymentIntentModel;
  }

  Future initPaymentSheet(
      {required InitPaymentSheetInputModel initPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initPaymentSheetInputModel.clientSecret,
        customerEphemeralKeySecret:
            initPaymentSheetInputModel.ephemeralKeySecret,
        customerId: initPaymentSheetInputModel.customerId,
        merchantDisplayName: 'Nora',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentsIntentModel =
        await createPaymentIntent(paymentIntentInputModel);
    var ephemeralKeyModel = await createEphemeralKey(
        customerId: paymentIntentInputModel.customerId);
    var initPaymentSheetInputModel = InitPaymentSheetInputModel(
        clientSecret: paymentsIntentModel.clientSecret!,
        customerId: paymentIntentInputModel.customerId,
        ephemeralKeySecret: ephemeralKeyModel.secret!);

    await initPaymentSheet(
        initPaymentSheetInputModel: initPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemeralKey(
      {required String customerId}) async {
    var response = await apiService.post(
      body: {'customer': customerId},
      headers: {
        'Authorization': 'Bearer ${ApiKeys.secretKey}',
        'Stripe-Version': '2025-01-27.acacia',
      },
      url: 'https://api.stripe.com/v1/ephemeral_keys',
      token: ApiKeys.secretKey,
    );
    var ephemeralKey = EphemeralKeyModel.fromJson(response.data);
    return ephemeralKey;
  }
}

//same code using try() catch
/*
class StripeService {
  final ApiService apiService = ApiService();

  Future<PaymentsIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    try {
      var response = await apiService.post(
        body: paymentIntentInputModel.toJson(),
        url: 'https://api.stripe.com/v1/payment_intents',
        token: ApiKeys.secretKey,
      );
      var paymentIntentModel = PaymentsIntentModel.fromJson(response.data);
      return paymentIntentModel;
    } catch (e) {
      print('Error in createPaymentIntent: $e');
      rethrow; // Optionally rethrow the error if you want it to be handled further up the call stack
    }
  }

  Future initPaymentSheet(
      {required InitPaymentSheetInputModel initPaymentSheetInputModel}) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: initPaymentSheetInputModel.clientSecret,
          customerEphemeralKeySecret:
          initPaymentSheetInputModel.ephemeralKeySecret,
          customerId: initPaymentSheetInputModel.customerId,
          merchantDisplayName: 'Nora',
        ),
      );
    } catch (e) {
      print('Error in initPaymentSheet: $e');
      rethrow;
    }
  }

  Future displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print('Error in displayPaymentSheet: $e');
      rethrow;
    }
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      var paymentsIntentModel =
      await createPaymentIntent(paymentIntentInputModel);
      var ephemeralKeyModel = await createEphemeralKey(
          customerId: paymentIntentInputModel.customerId);
      var initPaymentSheetInputModel = InitPaymentSheetInputModel(
          clientSecret: paymentsIntentModel.clientSecret!,
          customerId: paymentIntentInputModel.customerId,
          ephemeralKeySecret: ephemeralKeyModel.secret!);

      await initPaymentSheet(
          initPaymentSheetInputModel: initPaymentSheetInputModel);
      await displayPaymentSheet();
    } catch (e) {
      print('Error in makePayment: $e');
      rethrow;
    }
  }

  Future<EphemeralKeyModel> createEphemeralKey(
      {required String customerId}) async {
    try {
      var response = await apiService.post(
        body: {'customer': customerId},
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Stripe-Version': '2025-01-27.acacia',
        },
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        token: ApiKeys.secretKey,
      );
      var ephemeralKey = EphemeralKeyModel.fromJson(response.data);
      return ephemeralKey;
    } catch (e) {
      print('Error in createEphemeralKey: $e');
      rethrow;
    }
  }
}*/

//
// class StripeService {
//   final ApiService apiService = ApiService();
//
//   Future<PaymentsIntentModel?> createPaymentIntent(
//       PaymentIntentInputModel paymentIntentInputModel) async {
//     try {
//       var response = await apiService.post(
//         body: paymentIntentInputModel.toJson(),
//         url: 'https://api.stripe.com/v1/payment_intents',
//         token: ApiKeys.secretKey,
//         contentType: Headers.formUrlEncodedContentType,
//       );
//
//       if (response.data != null) {
//         return PaymentsIntentModel.fromJson(response.data);
//       } else {
//         // Handle the case where response.data is null
//         print('Response data is null');
//         return null;
//       }
//     } catch (e) {
//       // Handle any exceptions or errors and return null
//       print('An error occurred: $e');
//       return null;
//     }
//   }
//
//   Future initPaymentSheet({required String paymentIntentClientSecret}) async {
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentIntentClientSecret,
//         merchantDisplayName: 'Nora',
//       ),
//     );
//   }
//
//   Future displayPaymentSheet() async {
//     await Stripe.instance.presentPaymentSheet();
//   }
//
//   Future makePayment(
//       {required PaymentIntentInputModel paymentIntentInputModel}) async {
//     var paymentsIntentModel =
//         await createPaymentIntent(paymentIntentInputModel);
//     await initPaymentSheet(
//         paymentIntentClientSecret: paymentsIntentModel!.clientSecret!);
//     await displayPaymentSheet();
//   }
// }
