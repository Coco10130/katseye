import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class OrderShippingAddressContainer extends StatefulWidget {
  const OrderShippingAddressContainer({super.key});

  @override
  State<OrderShippingAddressContainer> createState() =>
      _OrderShippingAddressContainerState();
}

class _OrderShippingAddressContainerState
    extends State<OrderShippingAddressContainer> {
  @override
  Widget build(BuildContext context) {
    const double spacing = 10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Theme.of(context).colorScheme.onPrimary,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is FetchDeliveryAddressSuccessState) {
            final address = state.address;
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // shipping information
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // shipping information label
                      Row(
                        children: [
                          // icon
                          Icon(
                            Iconsax.location,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: 18,
                          ),

                          // spacing
                          const SizedBox(width: spacing),

                          // shipping inforation text
                          Text(
                            address.fullName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 15,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // spacing
                          const SizedBox(width: spacing),

                          // contact
                          Text(
                            address.contact,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 15,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      // spacing
                      const SizedBox(height: spacing),

                      // shipping address
                      Text(
                        "${address.province}, ${address.municipality}, ${address.barangay}, ${address.street}.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // change address indicator
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ],
            );
          } else if (state is DeliveryAddressEmpty) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // no shipping address text indicator
                Expanded(
                  child: Text(
                    state.errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // change address indicator
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ],
            );
          }
          return LoadingScreen(
              color: Theme.of(context).colorScheme.onSecondary);
        },
      ),
    );
  }
}
