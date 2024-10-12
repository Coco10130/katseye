part of 'check_out_bloc.dart';

@immutable
sealed class CheckOutEvent {}

final class FetchOrderSummaryEvent extends CheckOutEvent {
  final String token;

  FetchOrderSummaryEvent({required this.token});
}

final class CheckOutOrdersEvent extends CheckOutEvent {
  final String token;

  CheckOutOrdersEvent({required this.token});
}
