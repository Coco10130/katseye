part of 'check_out_bloc.dart';

@immutable
sealed class CheckOutState {}

final class CheckOutInitial extends CheckOutState {}

final class FetchCheckOutSuccessState extends CheckOutState {
  final List<OrderModel> products;

  FetchCheckOutSuccessState({required this.products});
}

final class FetchCheckOutFailedState extends CheckOutState {
  final String errorMessage;

  FetchCheckOutFailedState({required this.errorMessage});
}

final class CheckOutFailedState extends CheckOutState {
  final String errorMessage;

  CheckOutFailedState({required this.errorMessage});
}

final class CheckOutSuccessState extends CheckOutState {
  final String successMessage, newToken;

  CheckOutSuccessState({required this.successMessage, required this.newToken});
}

final class CheckOutLoadingState extends CheckOutState {}
