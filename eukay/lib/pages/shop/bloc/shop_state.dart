part of 'shop_bloc.dart';

@immutable
sealed class ShopState {}

final class ShopInitial extends ShopState {}

final class RegisterShopSuccessState extends ShopState {
  final String successMessage, token;

  RegisterShopSuccessState({required this.successMessage, required this.token});
}

final class RegisterShopFailedState extends ShopState {
  final String errorMessage;

  RegisterShopFailedState({required this.errorMessage});
}

final class OtpSentSuccessState extends ShopState {
  final String otpHash, successMessage;

  OtpSentSuccessState({
    required this.otpHash,
    required this.successMessage,
  });
}

final class OtpSentFailedState extends ShopState {
  final String errorMessage;

  OtpSentFailedState({required this.errorMessage});
}

final class FetchSellerSuccessState extends ShopState {
  final SellerModel seller;

  FetchSellerSuccessState({required this.seller});
}

final class FetchSellerFailedState extends ShopState {
  final String errorMessage;

  FetchSellerFailedState({required this.errorMessage});
}

final class AddProductSuccessState extends ShopState {
  final String successMessage;

  AddProductSuccessState({required this.successMessage});
}

final class AddProductFailedState extends ShopState {
  final String errorMessage;

  AddProductFailedState({required this.errorMessage});
}

final class ShopLoadingState extends ShopState {}
