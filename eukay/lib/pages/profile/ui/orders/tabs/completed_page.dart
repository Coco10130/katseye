import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/product_cards/sales_product_card.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/mappers/seller_group_model.dart';
import 'package:eukay/pages/profile/ui/profile_pages/rate_product_page.dart';
import 'package:eukay/pages/shop/mappers/sales_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  String? token;
  late SharedPreferences pref;

  Future<void> _initPreferences() async {
    try {
      pref = await SharedPreferences.getInstance();
      setState(() {
        token = pref.getString('token');
      });
    } catch (e) {
      throw Exception("Failed to load preferences: $e");
    }
  }

  Future<void> _fetchProducts() async {
    context
        .read<ProfileBloc>()
        .add(FetchOrdersEvent(status: "delivered", token: token!));
  }

  @override
  void initState() {
    super.initState();
    _initPreferences().then((_) {
      _fetchProducts();
    });
  }

  Map<String, SellerGroup> _groupProductsBySeller(
      List<SalesProductModel> orders) {
    final Map<String, SellerGroup> groupedProducts = {};

    for (var item in orders) {
      if (item.id.isNotEmpty) {
        if (groupedProducts.containsKey(item.id)) {
          groupedProducts[item.id]!.products.add(item);
        } else {
          groupedProducts[item.id] = SellerGroup(
            id: item.id,
            sellerId: item.sellerId,
            totalPrice: item.totalPrice,
            sellerName: item.shopName,
            products: [item],
          );
        }
      } else {
        throw Exception("Item with null or empty buyerName: ${item.buyerName}");
      }
    }

    return groupedProducts;
  }

  Future<void> _markOrder(String orderId, String sellerId) async {}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is FetchOrdersProductsFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
          _fetchProducts();
        }
      },
      builder: (context, state) {
        if (state is FetchOrdersProductsSuccessState) {
          final orderProducts = state.products;
          final groupedProducts = _groupProductsBySeller(orderProducts);

          return Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 20,
              bottom: 50,
            ),
            child: ListView.builder(
              itemCount: groupedProducts.length,
              itemBuilder: (context, index) {
                final buyerName = groupedProducts.keys.elementAt(index);
                final productGroup = groupedProducts[buyerName]!;

                return _buildSellerGroup(productGroup, _fetchProducts, token!);
              },
            ),
          );
        }

        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }

  Widget _buildSellerGroup(
      SellerGroup productGroup, VoidCallback onFetch, String token) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSellerInfo(
              productGroup,
              () => _markOrder(
                productGroup.id,
                productGroup.sellerId,
              ),
            ),
            const SizedBox(height: 10),
            _buildProductList(
                productGroup.products, onFetch, token),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerInfo(SellerGroup productGroup, VoidCallback onCheck) {
    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱ ",
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name and total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // name
                  Text(
                    productGroup.sellerName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      fontSize: 15,
                    ),
                  ),

                  // total price
                  Text(
                    formatCurrency.format(productGroup.totalPrice),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              // spacing
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(List<SalesProductModel> productList,
      VoidCallback onFetch, String token) {
    return Column(
      children: productList.map((salesProduct) {
        final orderId = salesProduct.id;
        return Column(
          children: salesProduct.products
              .where((product) => !product.rated)
              .map<Widget>((Product product) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SalesProductCard(
                rate: true,
                buttonBackgroundColor: Theme.of(context).colorScheme.onPrimary,
                buttonTextColor: Theme.of(context).colorScheme.onSecondary,
                onPressedRate: () {
                  navigateWithSlideTransition(
                    context: context,
                    page: RateProductPage(
                      id: product.id,
                      orderId: orderId,
                      price: product.price,
                      token: token,
                      productImage: product.productImage[0],
                      productName: product.productName,
                      size: product.size,
                      productId: product.productId,
                    ),
                    onFetch: onFetch,
                  );
                },
                price: product.price * product.quantity,
                image: product.productImage[0],
                productName: product.productName,
                quantity: product.quantity,
                size: product.size,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
