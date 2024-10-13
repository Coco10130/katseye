import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartProduct extends StatefulWidget {
  final String name;
  final double price;
  final int quantity;
  final String image;
  final bool marked;
  final VoidCallback toCheckOut;
  final VoidCallback addFunction;
  final VoidCallback minusFunction;
  final Color backgroundColor;
  final Color textColor;
  final double widthFactor;
  final String size;

  const CartProduct({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.addFunction,
    required this.minusFunction,
    required this.toCheckOut,
    required this.marked,
    required this.size,
    this.backgroundColor = const Color(0xFF373737),
    this.textColor = const Color(0xFFFFFFFF),
    this.widthFactor = 0.9,
  });

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  String getSizeLabel(String size) {
    switch (size) {
      case "XS":
        return "Extra Small";
      case "S":
        return "Small";
      case "M":
        return "Medium";
      case "L":
        return "Large";
      case "XL":
        return "Extra Large";
      case "XXL":
        return "Double Extra Large";
      default:
        return "Unknown Size";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;
    final double width = parentWidth * widget.widthFactor;
    const double spacing = 10;
    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱ ",
    );

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // spacing
              const SizedBox(
                width: spacing,
              ),

              // image
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              // spacing
              const SizedBox(
                width: spacing,
              ),

              // product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // product namee
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(
                      height: spacing - 5,
                    ),

                    // product price
                    Text(
                      formatCurrency.format(widget.price),
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: spacing - 5,
                    ),

                    // display size
                    Text(
                      getSizeLabel(widget.size),
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 13,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(
                      height: 1,
                    ),

                    //product quantity
                    QuantityLabel(
                      quantity: widget.quantity,
                      addFunction: widget.addFunction,
                      minusFunction: widget.minusFunction,
                    )
                  ],
                ),
              ),

              // checkbox
              Checkbox(
                checkColor: Theme.of(context).colorScheme.onPrimary,
                value: widget.marked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.toCheckOut();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuantityLabel extends StatefulWidget {
  final int quantity;
  final VoidCallback addFunction;
  final VoidCallback minusFunction;
  const QuantityLabel({
    super.key,
    required this.quantity,
    required this.addFunction,
    required this.minusFunction,
  });

  @override
  State<QuantityLabel> createState() => _QuantityLabelState();
}

class _QuantityLabelState extends State<QuantityLabel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // plus button
        ElevatedButton(
          onPressed: widget.addFunction,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: EdgeInsets.zero,
            minimumSize: const Size(25, 25),
          ),
          child: const Text(
            "+",
            style: TextStyle(
              color: Color(0xFF373737),
              fontSize: 15,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // quantity display
        Container(
          width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "${widget.quantity}",
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 13,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // minus button
        ElevatedButton(
          onPressed: widget.quantity > 1 ? widget.minusFunction : () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: EdgeInsets.zero,
            minimumSize: const Size(25, 25),
          ),
          child: const Text(
            "-",
            style: TextStyle(
              color: Color(0xFF373737),
              fontSize: 15,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
