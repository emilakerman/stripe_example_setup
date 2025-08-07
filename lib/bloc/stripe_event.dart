part of 'stripe_bloc.dart';

@freezed
sealed class StripeEvent with _$StripeEvent {
  const factory StripeEvent.makePayment() = MakePayment;
}
