import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment_thrwat_samy/features/checkout/data/models/amount_model/amount_model.dart';
import 'package:payment_thrwat_samy/features/checkout/data/models/amount_model/details.dart';
import 'package:payment_thrwat_samy/features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:payment_thrwat_samy/features/checkout/data/models/payment_intent_input_model.dart';
import 'package:payment_thrwat_samy/features/checkout/manger/payment_cubit.dart';
import 'package:payment_thrwat_samy/features/checkout/presentation/views/widgets/card_info_item.dart';

import '../../../../../core/utils/api_keys.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../data/models/item_list_model/item.dart';
import '../thank_you_view.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ThankYouView()));
        }
        if (state is PaymentFailure) {
          SnackBar snackBar = SnackBar(
            content: Text(state.errorMessage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
            onTap: () {
              // Navigator.pop(context);
              // PaymentIntentInputModel paymentIntentInputModel =
              //     PaymentIntentInputModel(
              //         amount: '100',
              //         currency: 'USD',
              //         customerId:
              //             'cus_Rm3vH5hxjkmIdr'); //note  cusId came after payment done but here came from postman
              // BlocProvider.of<PaymentCubit>(context).makePayment(
              //     paymentIntentInputModel: paymentIntentInputModel);

              var transactionData = getTransactionData();
              executePaypalPayment(context, transactionData);
            },
            isLoading: state is PaymentLoading ? true : false,
            text: 'Continue');
      },
    );
  }

  void executePaypalPayment(BuildContext context,
      ({AmountModel amount, ItemListModel itemList}) transactionData) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: ApiKeys.clientId,
        secretKey: ApiKeys.paypalSecretKey,
        transactions: [
          {
            "amount": transactionData.amount.toJson(),
            "description": "The payment transaction description.",
            "item_list": transactionData.itemList.toJson()
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          print("onSuccess: $params");
        },
        onError: (error) {
          print("onError: $error");
          Navigator.pop(context);
        },
        onCancel: () {
          print('cancelled:');
        },
      ),
    ));
  }

  ({AmountModel amount, ItemListModel itemList}) getTransactionData() {
    var amount = AmountModel(
        total: "100",
        currency: 'USD',
        details: Details(shipping: "0", shippingDiscount: 0, subtotal: '100'));
    List<OrderItemModel> orders = [
      OrderItemModel(currency: 'USD', name: 'Apple', price: "4", quantity: 10),
      OrderItemModel(currency: 'USD', name: 'Apple', price: "5", quantity: 12),
    ];
    var itemList = ItemListModel(orders: orders);

    return (amount: amount, itemList: itemList);
  }
}
