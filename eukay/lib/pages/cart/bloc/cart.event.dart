part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class InitialCartFetchEvent extends CartEvent {
  final String token;

  InitialCartFetchEvent({required this.token});
}
