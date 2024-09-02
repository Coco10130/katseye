part of 'shop_bloc.dart';

@immutable
sealed class ShopState {}

final class ShopInitial extends ShopState {}

final class RegisterShopSuccessState extends ShopState {
  final String successMessage;

  RegisterShopSuccessState({required this.successMessage});
}

final class RegisterShopFailedState extends ShopState {
  final String errorMessage;

  RegisterShopFailedState({required this.errorMessage});
}

final class RegistrationLoadingState extends ShopState {}
