import 'package:myminipod_client/myminipod_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Class that communicates directly with the Serverpod backend.
/// The serverpod backend in turn communicates with the Stripe API.
class StripeService {
  StripeService._();

  static final StripeService I = StripeService._();

  var client = Client("http://$localhost:8080/")
    ..connectivityMonitor = FlutterConnectivityMonitor();

  Future<String?> createPaymentIntent(int amount, String currency) async {
    try {
      final result = await client.payment.createPaymentIntent(amount, currency);
      return result;
    } catch (e) {
      print("not successful call!");
      return null;
    }
  }
}
