import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/product_cards/sales_product_card.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:eukay/pages/shop/mappers/buyer_model.dart';
import 'package:eukay/pages/shop/mappers/sales_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingPage extends StatefulWidget {
  final String sellerId;

  const PendingPage({super.key, required this.sellerId});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  late SharedPreferences pref;
  String? token;

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
    context.read<ShopBloc>().add(FetchSalesProductEvent(
        token: token!, sellerId: widget.sellerId, status: "pending"));
  }

  Future<void> fetchSellerProfile() async {
    context.read<ShopBloc>().add(FetchSellerProfileEvent(token: token!));
  }

  @override
  void initState() {
    super.initState();
    _initPreferences().then((_) {
      _fetchProducts();
    });
  }

  Map<String, BuyerGroup> _groupProductsByBuyer(
      List<SalesProductModel> orders) {
    final Map<String, BuyerGroup> groupedProducts = {};

    for (var item in orders) {
      if (item.id.isNotEmpty) {
        if (groupedProducts.containsKey(item.id)) {
          groupedProducts[item.id]!.products.add(item);
        } else {
          groupedProducts[item.id] = BuyerGroup(
            id: item.id,
            totalPrice: item.totalPrice,
            sellerId: item.sellerId,
            marked: item.markAsNextStep,
            buyerName: item.buyerName,
            contact: item.buyerContact,
            address: item.deliveryAddress,
            products: [item],
          );
        }
      } else {
        throw Exception("Item with null or empty buyerName: ${item.buyerName}");
      }
    }

    return groupedProducts;
  }

  Future<void> _markOrder(String orderId, String sellerId) async {
    context.read<ShopBloc>().add(
          MarkAsNextStepProductEvent(
            orderId: orderId,
            status: "pending",
            sellerId: sellerId,
            token: token!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is MarkSalesProductSuccessState) {
          _fetchProducts();
        } else if (state is MarkSalesProductFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
          _fetchProducts();
        } else if (state is ChangeStatusSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );

          fetchSellerProfile().then((_) {
            _fetchProducts();
          });
        } else if (state is ChangeStatusFailedState) {
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
        if (state is FetchProductFailedState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }

        if (state is FetchSalesProductsState) {
          final orderProducts = state.products;
          final groupedProducts = _groupProductsByBuyer(orderProducts);

          if (orderProducts.isEmpty) {
            return Center(
              child: Text(
                'No pending products were found',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            );
          }

          return Stack(
            children: [
              Padding(
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

                    return _buildBuyerGroup(productGroup);
                  },
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MyButton(
                    title: "Accept order",
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    verticalPadding: 10,
                    height: 60,
                    widthFactor: 0.9,
                    onPressed: () {
                      context.read<ShopBloc>().add(
                            ChangeOrderStatusEvent(
                              nextStatus: "to prepare",
                              status: "pending",
                              sellerId: widget.sellerId,
                              token: token!,
                            ),
                          );
                    },
                  ),
                ),
              )
            ],
          );
        }

        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
        // return showLoadingDialog(context, Colors.blue);
      },
    );
  }

  Widget _buildBuyerGroup(BuyerGroup productGroup) {
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
            _buildBuyerInfo(
              productGroup,
              () => _markOrder(
                productGroup.id,
                productGroup.sellerId,
              ),
            ),
            const SizedBox(height: 10),
            _buildProductList(productGroup.products),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerInfo(BuyerGroup productGroup, VoidCallback onCheck) {
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
                    productGroup.buyerName,
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

              // contact
              Text(
                productGroup.contact,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 15,
                  fontFamily: "Poppins",
                ),
              ),

              // full address
              Text(
                productGroup.address,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 12,
                  fontFamily: "Poppins",
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        Checkbox(
          hoverColor: Colors.black,
          activeColor: Theme.of(context).colorScheme.secondary,
          value: productGroup.marked,
          onChanged: (bool? value) {
            onCheck();
          },
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(List<SalesProductModel> productList) {
    return Column(
      children: productList.map((salesProduct) {
        return Column(
          children: salesProduct.products.map<Widget>((Product product) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SalesProductCard(
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
