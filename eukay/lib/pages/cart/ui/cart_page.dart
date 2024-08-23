import 'package:eukay/pages/cart/bloc/cart_bloc.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/product_cards/cart_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> cartProducts = [
    {
      "title": "Stylish Shoe",
      "price": 9999,
      "image": "assets/images/shoe.jpg",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Stylish Shirt",
      "price": 499,
      "image": "assets/images/shirt.png",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Black shirt",
      "price": 499,
      "image": "assets/images/colet.jpeg",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Stylish Shoe",
      "price": 9999,
      "image": "assets/images/shoe.jpg",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Stylish Shirt",
      "price": 499,
      "image": "assets/images/shirt.png",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Black shirt",
      "price": 499,
      "image": "assets/images/colet.jpeg",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Stylish Shoe",
      "price": 9999.90,
      "image": "assets/images/shoe.jpg",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Stylish Shirt",
      "price": 499,
      "image": "assets/images/shirt.png",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Black shirt",
      "price": 499,
      "image": "assets/images/colet.jpeg",
      "quantity": 1,
      "toCheckOut": false,
    },
    {
      "title": "Stylish Shoe",
      "price": 9999,
      "image": "assets/images/shoe.jpg",
      "quantity": 1,
      "toCheckOut": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        iconTheme: const IconThemeData(
          color: Color(0xFFFFFFFF),
        ),
        title: const Text(
          "Shopping Cart",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
        ),
        centerTitle: true,
      ),
      body: CartBody(
        cartProducts: cartProducts,
      ),
    );
  }
}

class CartBody extends StatefulWidget {
  final List<Map<String, dynamic>> cartProducts;
  const CartBody({super.key, required this.cartProducts});

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  @override
  void initState() {
    super.initState();
    context
        .read<CartBloc>()
        .add(InitializeCart(cartItems: widget.cartProducts));
  }

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartUpdateState) {
          return Stack(
            children: <Widget>[
              // cart products
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: 130,
                ),
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: widget.cartProducts.length,
                      itemBuilder: (context, index) {
                        final product = widget.cartProducts[index];
                        final int quantity = product["quantity"];
                        final double price = product["price"].toDouble();
                        final double totalPrice = price * quantity;

                        return ProductCard(
                          name: product["title"]!,
                          price: totalPrice,
                          image: product["image"]!,
                          countity: "$quantity",
                          marked: product["toCheckOut"],
                          toCheckOut: () => context
                              .read<CartBloc>()
                              .add(CartToggleCheckOut(index: index)),
                          addFunction: () => context
                              .read<CartBloc>()
                              .add(CartAddQuantity(index: index)),
                          minusFunction: () => context
                              .read<CartBloc>()
                              .add(CartMinusQuantity(index: index)),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        );
                      },
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
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _navigationBar(double width) {
    final double totalCheckedPrice = widget.cartProducts
        .where((product) => product["toCheckOut"] == true)
        .fold(0,
            (sum, product) => sum + (product["price"] * product["quantity"]));
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
              "Total: ${formatCurrency.format(totalCheckedPrice)}",
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
