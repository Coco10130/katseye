import 'package:eukay/components/my-appBar.dart';
import 'package:eukay/components/my_input.dart';
import 'package:eukay/uitls/curved_edges.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: MyAppBar(
        label: "Edit Profile",
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: const EditProfilBody(),
    );
  }
}

class EditProfilBody extends StatefulWidget {
  const EditProfilBody({super.key});

  @override
  State<EditProfilBody> createState() => _EditProfilBodyState();
}

class _EditProfilBodyState extends State<EditProfilBody> {
  final TextEditingController _nameController =
      TextEditingController(text: "Tanggol dimagiba");
  final TextEditingController _emailController =
      TextEditingController(text: "tanggol@gmail.com");
  final TextEditingController _phoneNumberController =
      TextEditingController(text: "09308823882");

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double spacing = 10;

    return SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: Container(
              color: Theme.of(context).colorScheme.onSurface,
              child: const SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  children: [
                    // profile picture
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage("assets/images/colet.jpeg"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // name textfield
                MyTextField(
                  label: "Name",
                  hint: "Enter Name",
                  controller: _nameController,
                ),

                // spacing
                const SizedBox(
                  height: spacing,
                ),

                // email textfield
                MyTextField(
                  label: "Email",
                  hint: "Enter Email",
                  controller: _emailController,
                ),

                // spcaing
                const SizedBox(
                  height: spacing,
                ),

                // phone number textfield
                MyTextField(
                  label: "Phone Number",
                  hint: "Enter Phone Number",
                  controller: _phoneNumberController,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
