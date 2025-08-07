import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_example_setup/bloc/stripe_bloc.dart';
import 'package:stripe_example_setup/stripe_constants.dart';

void main() async {
  await _setup();
  runApp(
    BlocProvider(create: (context) => StripeBloc(), child: const MainApp()),
  );
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
      home: BlocListener<StripeBloc, StripeState>(
        listener: (context, state) {
          if (state.status == StripeStatus.success) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Payment successful!')));
          }
          if (state.status == StripeStatus.error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("${state.errorMessage}")));
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Flutter Stripe Example Setup'),
                ElevatedButton(
                  onPressed:
                      () => context.read<StripeBloc>().add(MakePayment()),
                  child: Text("Press"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
