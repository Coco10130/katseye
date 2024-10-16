import 'package:eukay/components/product_cards/live_product_card.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DelistedPage extends StatefulWidget {
  final String token, sellerId;
  const DelistedPage({super.key, required this.token, required this.sellerId});

  @override
  State<DelistedPage> createState() => _DelistedPageState();
}

class _DelistedPageState extends State<DelistedPage> {
  @override
  void initState() {
    super.initState();
    fetchLiveProduct();
  }

  void fetchLiveProduct() {
    context.read<ShopBloc>().add(FetchLiveProductEvent(
        token: widget.token, sellerId: widget.sellerId, status: "delisted"));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridItemWidth = screenWidth > 1200 ? 300 : screenWidth * 0.4;

    final int crossAxisCount = (screenWidth / gridItemWidth).floor();
    final double productSpacing = screenWidth > 1200 ? 50 : 10;
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is FetchLiveProductsFailedState) {
          return Center(
              child: Text(
            state.errorMessage,
            style: const TextStyle(color: Colors.black),
          ));
        }
        if (state is FetchLiveProductsSuccessState) {
          final products = state.products;

          if (products.isEmpty) {
            return Center(
              child: Text(
                'No delisted products were found',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: productSpacing,
                mainAxisSpacing: productSpacing,
                childAspectRatio: screenWidth > 1200 ? 0.81 : 0.74,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final totalQuantity = product.sizeQuantities.fold<int>(
                  0,
                  (sum, size) => sum + size.quantity,
                );
                return LiveProductCard(
                  onPressed: () {},
                  name: product.productName,
                  image: product.productImage[0],
                  price: product.price,
                  rating: product.rating,
                  stocks: totalQuantity,
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                );
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
