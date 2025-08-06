import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_example_setup/stripe_constants.dart';
import 'package:stripe_example_setup/stripe_service.dart';

void main() async {
  await _setup();
  runApp(const MainApp());
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeConstants.stripePublishableKey;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Flutter Stripe Example Setup'),
              ElevatedButton(
                onPressed: () {
                  StripeService.I.makePayment();
                },
                child: Text("Press"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
