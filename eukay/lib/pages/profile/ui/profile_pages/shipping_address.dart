import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/containers/shipping_address_container.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/ui/edit_user_information/add_shipping_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "My Address",
        textColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          // Navigate to the previous screen
          Navigator.pop(context, true);
        },
      ),
      body: const ShippingPage(),
    );
  }
}

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  late SharedPreferences pref;
  bool prefInitialized = false;
  String? token;

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      fetchAddresses();
    });
  }

  Future<void> fetchAddresses() async {
    final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token!);
    final String userId = jwtDecocded["id"];
    context
        .read<ProfileBloc>()
        .add(FetchUserAddressEvent(token: token!, userId: userId));
  }

  Future<void> refreshState() async {}

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      prefInitialized = true;
      token = pref.getString("token")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!prefInitialized) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is FetchUserAddressFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is DeleteAddressSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );
          fetchAddresses();
        } else if (state is DeleteAddressFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
          fetchAddresses();
        } else if (state is UseAddressFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
          fetchAddresses();
        } else if (state is UseAddressSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );
          fetchAddresses();
        }
      },
      builder: (context, state) {
        if (state is FetchUserAddressSuccessState) {
          final addresses = state.addresses;
          return RefreshIndicator(
            onRefresh: () => refreshState(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // add addres button
                  GestureDetector(
                    onTap: () async {
                      navigateWithSlideTransition(
                        context: context,
                        page: const AddShippingAddress(),
                        onFetch: () => fetchAddresses(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // plus icon
                        Icon(
                          Iconsax.add,
                          color: Colors.grey[600],
                          size: 30,
                        ),

                        // spacing
                        const SizedBox(width: 15),

                        // label
                        Expanded(
                          child: Text(
                            "Add address",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                        // arrow icon
                        Icon(
                          Iconsax.arrow_right_3,
                          color: Colors.grey[600],
                          size: 28,
                        ),
                      ],
                    ),
                  ),

                  // spacing
                  const SizedBox(height: 10),

                  // display shipping address information
                  Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return AddressContainer(
                          inUse: address.inUse,
                          name: address.fullName,
                          phoneNumber: address.contact,
                          province: address.province,
                          municipality: address.municipality,
                          barangay: address.barangay,
                          street: address.street,
                          nameColor: Theme.of(context).colorScheme.onSecondary,
                          informationTextColor: Colors.grey[600]!,
                          onPressed: () {
                            !address.inUse
                                ? context.read<ProfileBloc>().add(
                                      UseAddressEvent(
                                          addressId: address.id, token: token!),
                                    )
                                : null;
                          },
                          onDeletePressed: () {
                            context.read<ProfileBloc>().add(DeleteAddressEvent(
                                addressId: address.id, token: token!));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }
}
