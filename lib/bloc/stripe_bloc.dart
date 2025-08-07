import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import "package:freezed_annotation/freezed_annotation.dart";
import 'package:stripe_example_setup/stripe_service.dart';

part 'stripe_bloc.freezed.dart';
part 'stripe_event.dart';
part 'stripe_state.dart';

class StripeBloc extends Bloc<StripeEvent, StripeState> {
  final stripeService = StripeService.I;
  StripeBloc() : super(const StripeState()) {
    on<MakePayment>(_makePayment);
  }

  Future<void> _makePayment(
    MakePayment event,
    Emitter<StripeState> emit,
  ) async {
    try {
      String? paymentIntentClientSecret = await stripeService
          .createPaymentIntent(100, "sek");

      if (paymentIntentClientSecret == null) {
        emit(
          state.copyWith(
            status: StripeStatus.error,
            errorMessage: "Error during processing the payment in the backend.",
          ),
        );
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Hackberry Bay",
        ),
      );

      try {
        await Stripe.instance.presentPaymentSheet();

        emit(state.copyWith(status: StripeStatus.success));
        debugPrint("Payment completed successfully!");
      } on StripeException catch (e) {
        emit(
          state.copyWith(
            status: StripeStatus.cancelled,
            errorMessage: "Payment cancelled by user.",
          ),
        );
        debugPrint("Payment was cancelled by user: $e");
      } catch (e) {
        emit(
          state.copyWith(
            status: StripeStatus.error,
            errorMessage:
                "Error occurred when trying to present payment sheet: $e",
          ),
        );
        debugPrint("Error occurred when trying to present payment sheet: $e");
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: StripeStatus.error,
          errorMessage: "Error occurred when trying to initialize payment: $e",
        ),
      );
      debugPrint("Error occurred when trying to initialize payment: $e");
    }
  }
}
