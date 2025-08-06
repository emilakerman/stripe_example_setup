import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_example_setup/stripe_constants.dart';

class StripeService {
  StripeService._();

  static final StripeService I = StripeService._();

  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        100,
        "sek",
      );

      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Hackberry Bay",
        ),
      );

      await _processPayment();
    } catch (e) {
      debugPrint("$e");
    }
  }

  /// NOTE: This should be done in the backend.
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${StripeConstants.stripeSecretKey}",
            "Content-Type": "application/x-www-form-urlenconded",
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      // Test with card details:
      // 4242424242424242
      // mm/yy and cvc can be random.
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      debugPrint("$e");
    }
  }

  // Stripe accepts currencies in the smallest denomination.
  // e.g. ÖRE for SEK or CENTS for USD.
  // So a calculation needs to take place before its passed to Stripe.
  String _calculateAmount(int amount) {
    return "${amount * 100}";
  }
}
