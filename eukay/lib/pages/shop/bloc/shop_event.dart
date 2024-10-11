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

  SendOTPRegistrationEvent({
    required this.email,
    required this.token,
  });
}

final class FetchSellerProfileEvent extends ShopEvent {
  final String token;

  FetchSellerProfileEvent({required this.token});
}

final class AddProductEvent extends ShopEvent {
  final List<XFile> images;
  final List<String> sizes, categories;
  final String productName, description, price, token;
  final Map<String, String> sizeQuantities;

  AddProductEvent({
    required this.images,
    required this.sizes,
    required this.categories,
    required this.price,
    required this.token,
    required this.productName,
    required this.description,
    required this.sizeQuantities,
  });
}

final class FetchLiveProductEvent extends ShopEvent {
  final String token, sellerId, status;

  FetchLiveProductEvent(
      {required this.token, required this.sellerId, required this.status});
}

final class FetchSalesProductEvent extends ShopEvent {
  final String token, sellerId, status;

  FetchSalesProductEvent({
    required this.token,
    required this.sellerId,
    required this.status,
  });
}

final class MarkAsNextStepProductEvent extends ShopEvent {
  final String token, orderId, sellerId, status;

  MarkAsNextStepProductEvent({
    required this.token,
    required this.orderId,
    required this.sellerId,
    required this.status,
  });
}

final class ChangeOrderStatusEvent extends ShopEvent {
  final String token, sellerId, status, nextStatus;

  ChangeOrderStatusEvent({
    required this.token,
    required this.sellerId,
    required this.status,
    required this.nextStatus,
  });
}

final class FetchUpdateProductEvent extends ShopEvent {
  final String token, productId;

  FetchUpdateProductEvent({required this.token, required this.productId});
}

final class UpdateProductEvent extends ShopEvent {
  final List<String> sizes;
  final String productName, description, price, token, productId;
  final Map<String, int> sizeQuantities;

  UpdateProductEvent({
    required this.sizes,
    required this.price,
    required this.token,
    required this.productId,
    required this.productName,
    required this.description,
    required this.sizeQuantities,
  });
}
