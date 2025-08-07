part of 'stripe_bloc.dart';

@freezed
sealed class StripeState with _$StripeState {
  const factory StripeState({
    @Default(StripeStatus.initial) StripeStatus status,
    String? errorMessage,
  }) = _StripeState;
}

enum StripeStatus { initial, error, success, cancelled }
