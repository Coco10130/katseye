import 'dart:io';

import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/my-appBar.dart';
import 'package:eukay/components/my_input.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/uitls/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatelessWidget {
  final String token, name, email, image;
  final String? number;
  const EditProfile({
    super.key,
    required this.token,
    required this.name,
    this.number,
    required this.image,
    required this.email,
  });

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
      body: EditProfilBody(
        token: token,
      ),
    );
  }
}

class EditProfilBody extends StatefulWidget {
  final String token;
  const EditProfilBody({
    super.key,
    required this.token,
  });

  @override
  State<EditProfilBody> createState() => _EditProfilBodyState();
}

class _EditProfilBodyState extends State<EditProfilBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    context
        .read<ProfileBloc>()
        .add(ProfileInitialFetchEvent(token: widget.token));
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double spacing = 10;

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
      },
      builder: (context, state) {
        if (state is FetchProfileSuccessState) {
          _nameController.text = state.profile.userName;
          _emailController.text = state.profile.email;
          if (state.profile.phoneNumber != null) {
            _phoneNumberController.text = state.profile.phoneNumber.toString();
          }
          return SingleChildScrollView(
            child: Column(
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
                          // profile picture
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : NetworkImage(state.profile.image),
                                child: _imageFile == null
                                    ? Icon(Iconsax.camera,
                                        color: Colors.grey[600])
                                    : null,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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

                      // spacing
                      const SizedBox(
                        height: spacing,
                      ),

                      MyButton(
                          title: "Update",
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            context.read<ProfileBloc>().add(ProfileUpdateEvent(
                                  email: _emailController.text,
                                  id: state.profile.id,
                                  image: _imageFile != null
                                      ? _imageFile!.path
                                      : state.profile.image,
                                  phoneNumber: _phoneNumberController.text,
                                  token: widget.token,
                                  userName: _nameController.text,
                                ));
                            Navigator.pop(context, true);
                          })
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
