part of 'shop_bloc.dart';

@immutable
sealed class ShopEvent {}

final class RegisterShopEvent extends ShopEvent {
  final String token, shopName, shopEmail, shopContact;

  RegisterShopEvent({
    required this.token,
    required this.shopName,
    required this.shopEmail,
    required this.shopContact,
  });
}
