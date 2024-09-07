part of 'shop_bloc.dart';

@immutable
sealed class ShopEvent {}

final class RegisterShopEvent extends ShopEvent {
  final String token, shopName, shopEmail, shopContact, otpHash, otpCode;

  RegisterShopEvent({
    required this.token,
    required this.shopName,
    required this.shopEmail,
    required this.shopContact,
    required this.otpHash,
    required this.otpCode,
  });
}

final class SendOTPRegistrationEvent extends ShopEvent {
  final String email, token;

  SendOTPRegistrationEvent({required this.email, required this.token});
}

final class FetchSellerProfileEvent extends ShopEvent {
  final String token;

  FetchSellerProfileEvent({required this.token});
}

final class AddProductEvent extends ShopEvent {
  final List<XFile> images;
  final List<String> sizes, categories;
  final String productName, description, quantity, price, token;

  AddProductEvent(
      {required this.images,
      required this.sizes,
      required this.categories,
      required this.price,
      required this.token,
      required this.quantity,
      required this.productName,
      required this.description});
}
