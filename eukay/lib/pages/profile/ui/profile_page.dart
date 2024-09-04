import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/ui/edit_profile.dart';
import 'package:eukay/uitls/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatefulWidget {
  final String token;
  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() {
    context
        .read<ProfileBloc>()
        .add(ProfileInitialFetchEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: ProfilePageBody(fetchProfile: fetchProfile, token: widget.token),
    );
  }
}

class ProfilePageBody extends StatelessWidget {
  final VoidCallback fetchProfile;
  final String token;
  const ProfilePageBody(
      {super.key, required this.fetchProfile, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is FetchProfileFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              errorMessage: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        }

        if (state is ProfileUpdateSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              errorMessage: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );

          fetchProfile();
        }
      },
      builder: (context, state) {
        if (state is FetchProfileSuccessState) {
          return Column(
            children: [
              ClipPath(
                clipper: CustomCurvedEdges(),
                child: Container(
                  color: Theme.of(context).colorScheme.onSurface,
                  child: SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // TODO: LOGOUT BUTTON

                        // Profile picture
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 45,
                                backgroundImage:
                                    NetworkImage(state.profile.image),
                              ),

                              // spacing
                              const SizedBox(
                                height: 20,
                              ),

                              // name
                              Text(
                                state.profile.userName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // spacing
              const SizedBox(
                height: 30,
              ),

              // orders label
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Orders",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),

              // spacing
              const SizedBox(
                height: 10,
              ),

              // order status
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _icons(
                      const Icon(
                        Iconsax.box,
                        size: 25,
                      ),
                      "To Prepare"),
                  _icons(
                      const Icon(
                        Iconsax.truck,
                        size: 25,
                      ),
                      "To Recieve"),
                  _icons(
                      const Icon(
                        Iconsax.star,
                        size: 25,
                      ),
                      "To Rate"),
                ],
              ),

              // spacing
              const SizedBox(
                height: 30,
              ),

              // edit profile
              _myContainer("Edit Profile", "assets/icons/user.png", () {
                navigateWithSlideTransition(
                  context: context,
                  page: EditProfile(
                    token: token,
                    name: state.profile.userName,
                    email: state.profile.email,
                    number: state.profile.phoneNumber,
                    image: state.profile.image,
                  ),
                  onFetch: fetchProfile,
                );
              }),
              _myContainer(
                  "Shipping Address", "assets/icons/location.png", () {}),
              _myContainer("Wishlist", "assets/icons/heart.png", () {}),
              _myContainer("Order History", "assets/icons/clip.png", () {}),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _icons(Icon icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 20,
          child: icon,
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  Widget _myContainer(
    String label,
    String icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: SizedBox(
        height: 60,
        child: GestureDetector(
          onTap: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // icon
              Image.asset(
                icon,
                width: 25,
                height: 25,
                color: const Color(0xFFFFFFFF),
              ),

              // spacing
              const SizedBox(
                width: 20,
              ),

              // label
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "Poppins",
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "assets/icons/next.png",
                  width: 25,
                  height: 25,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
