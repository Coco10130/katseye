import 'package:eukay/uitls/curved_edges.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const ProfilePageBody(),
    );
  }
}

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: CustomCurvedEdges(),
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  // Profile picture
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              AssetImage('assets/images/colet.jpeg'),
                        ),

                        // spacing
                        const SizedBox(
                          height: 10,
                        ),

                        // name
                        Text(
                          'Tanggol Dimagiba',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            color: Theme.of(context).colorScheme.onSecondary,
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

        // edit profile
        _myContainer("Edit Profile", "assets/icons/user.png"),
        _myContainer("Shipping Address", "assets/icons/location.png"),
        _myContainer("Wishlist", "assets/icons/heart.png"),
        _myContainer("Order History", "assets/icons/clip.png"),
      ],
    );
  }

  Widget _myContainer(
    String label,
    String icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          onPressed: () {},
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
