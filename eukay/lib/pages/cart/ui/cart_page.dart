import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/pages/cart/bloc/cart_bloc.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/product_cards/cart_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  final String token;
  const CartPage({super.key, required this.token});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "Shopping Cart",
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: CartBody(token: widget.token),
    );
  }
}

class CartBody extends StatefulWidget {
  final String token;
  const CartBody({super.key, required this.token});

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future fetchCart() async {
    context.read<CartBloc>().add(InitialCartFetchEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FetchCartFailedState) {
          return Text(
            state.errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          );
        }
        if (state is FetchCartSuccessState) {
          final cartProducts = state.cartItems;
          return RefreshIndicator(
            onRefresh: fetchCart,
            child: Stack(
              children: <Widget>[
                // cart products
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 20,
                    bottom: 130,
                  ),
                  child: ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final cart = cartProducts[index];

                      return CartProduct(
                        name: cart.productName,
                        price: cart.subTotal,
                        image: cart.productImage,
                        quantity: cart.quantity,
                        marked: false,
                        toCheckOut: () => {},
                        addFunction: () {},
                        minusFunction: () {},
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onSecondary,
                      );
                    },
                  ),
                ),
                // floating navigation bar
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: _navigationBar(parentWidth),
                )
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _navigationBar(double width) {
    // for fomating price
    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱",
    );

    return Container(
      width: width,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withAlpha(20),
              blurRadius: 20,
              spreadRadius: 10,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // display total
            Text(
              "Total: ₱0",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // spacing
            const SizedBox(
              height: 10,
            ),

            // checkout button
            MyButton(
              title: "Proceed to Checkout",
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}