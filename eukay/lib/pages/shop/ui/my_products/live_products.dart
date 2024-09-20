import 'package:eukay/components/product_cards/live_product_card.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LivePage extends StatefulWidget {
  final String sellerId, token;
  const LivePage({super.key, required this.sellerId, required this.token});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  void initState() {
    super.initState();
    fetchLiveProduct();
  }

  void fetchLiveProduct() {
    context.read<ShopBloc>().add(
        FetchLiveProductEvent(token: widget.token, sellerId: widget.sellerId));
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
                return LiveProductCard(
                  onPressed: () {},
                  name: product.productName,
                  image: product.productImage[0],
                  price: product.price,
                  rating: product.rating,
                  stocks: product.quantity,
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
