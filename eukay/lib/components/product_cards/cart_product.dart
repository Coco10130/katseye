import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final double price;
  final String countity;
  final String image;
  final bool marked;
  final VoidCallback toCheckOut;
  final VoidCallback addFunction;
  final VoidCallback minusFunction;
  final Color backgroundColor;
  final Color textColor;
  final double widthFactor;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.countity,
    required this.image,
    required this.addFunction,
    required this.minusFunction,
    required this.toCheckOut,
    required this.marked,
    this.backgroundColor = const Color(0xFF373737),
    this.textColor = const Color(0xFFFFFFFF),
    this.widthFactor = 0.9,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final double parentWidth = MediaQuery.of(context).size.width;
    final double width = parentWidth * widget.widthFactor;
    const double spacing = 10;
    final formatCurrency = NumberFormat.currency(
      locale: "en_PH",
      symbol: "₱",
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // spacing
              const SizedBox(
                width: spacing,
              ),

              // image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.cover,
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
                    // product name
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: spacing - 5,
                    ),

                    // product price
                    Text(
                      formatCurrency.format(widget.price),
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 15,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: spacing - 5,
                    ),

                    //product quantity
                    QuantityLabel(
                      quantity: widget.countity,
                      addFunction: widget.addFunction,
                      minusFunction: widget.minusFunction,
                    )
                  ],
                ),
              ),

              // checkbox
              Checkbox(
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
  final String quantity;
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
        //! plus button
        ElevatedButton(
          onPressed: widget.addFunction,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFFFFF),
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
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              widget.quantity,
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
          onPressed: widget.minusFunction,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFFFFF),
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
