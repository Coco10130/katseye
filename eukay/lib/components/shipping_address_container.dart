import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddressContainer extends StatelessWidget {
  final String name, province, municipality, barangay, street, phoneNumber;
  final Color nameColor, informationTextColor;
  final VoidCallback onPressed;
  final VoidCallback onDeltePressed;

  const AddressContainer({
    super.key,
    required this.name,
    required this.onPressed,
    required this.onDeltePressed,
    required this.phoneNumber,
    required this.municipality,
    required this.street,
    required this.barangay,
    required this.province,
    this.nameColor = Colors.green,
    this.informationTextColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // name
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: nameColor,
                    ),
                  ),

                  // spacing
                  const SizedBox(height: 5),

                  // phone number
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      color: informationTextColor,
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // spacing
                  const SizedBox(height: 10),

                  // shipping address
                  Text(
                    "$province, $municipality, $barangay, $street",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: informationTextColor,
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // delete button
              Positioned(
                top: 5,
                right: 10,
                child: GestureDetector(
                  onTap: onDeltePressed,
                  child: const Icon(
                    Iconsax.trash,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
