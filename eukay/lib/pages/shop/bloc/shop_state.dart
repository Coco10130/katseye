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

final class FetchLiveProductsSuccessState extends ShopState {
  final List<ProductModel> products;

  FetchLiveProductsSuccessState({required this.products});
}

final class FetchLiveProductsFailedState extends ShopState {
  final String errorMessage;

  FetchLiveProductsFailedState({required this.errorMessage});
}

final class FetchSalesProductsState extends ShopState {
  final List<SalesProductModel> products;

  FetchSalesProductsState({required this.products});
}

final class FetchProductFailedState extends ShopState {
  final String errorMessage;

  FetchProductFailedState({required this.errorMessage});
}

final class MarkSalesProductFailedState extends ShopState {
  final String errorMessage;

  MarkSalesProductFailedState({required this.errorMessage});
}

final class MarkSalesProductSuccessState extends ShopState {
  final String successMessage;

  MarkSalesProductSuccessState({required this.successMessage});
}

final class ChangeStatusSuccessState extends ShopState {
  final String successMessage;

  ChangeStatusSuccessState({required this.successMessage});
}

final class ChangeStatusFailedState extends ShopState {
  final String errorMessage;

  ChangeStatusFailedState({required this.errorMessage});
}

final class UpdateProductFailedState extends ShopState {
  final String errorMessage;

  UpdateProductFailedState({required this.errorMessage});
}

final class UpdateProductSuccessState extends ShopState {
  final String successMessage;

  UpdateProductSuccessState({required this.successMessage});
}

final class FetchUpdateProductState extends ShopState {
  final ProductModel product;

  FetchUpdateProductState({required this.product});
}

final class DeleteProductSuccessState extends ShopState {
  final String successMessage;

  DeleteProductSuccessState({required this.successMessage});
}

final class DeleteProductFailedState extends ShopState {
  final String errorMessage;

  DeleteProductFailedState({required this.errorMessage});
}

final class ShopLoadingState extends ShopState {}
