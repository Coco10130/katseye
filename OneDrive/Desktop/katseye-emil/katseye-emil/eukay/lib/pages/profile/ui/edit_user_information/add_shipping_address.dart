import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/inputs/my_input.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/mappers/barangay_model.dart';
import 'package:eukay/pages/profile/mappers/municipality_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddShippingAddress extends StatelessWidget {
  const AddShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "Add Shipping Address",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: const AddAddressBody(),
    );
  }
}

class AddAddressBody extends StatefulWidget {
  const AddAddressBody({super.key});

  @override
  State<AddAddressBody> createState() => _AddAddressBodyState();
}

class _AddAddressBodyState extends State<AddAddressBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  late SharedPreferences pref;
  bool prefInitialized = false;

  MunicipalityModel? selectedMunicipality;
  BarangayModel? selectedBarangay;
  List<MunicipalityModel> municipalities = [];
  List<BarangayModel> barangays = [];

  @override
  void initState() {
    super.initState();
    initPref();
    context.read<ProfileBloc>().add(FetchMunicipalitiesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      prefInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!prefInitialized) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is FetchBarangaysSccessState) {
          setState(() {
            barangays = state.barangays;
          });
        } else if (state is FetchMunicipalitiesSuccessState) {
          setState(() {
            municipalities = state.municipalities;
          });
        } else if (state is FetchingFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is AddUserAddressFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is AddUserAddressSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );
          Navigator.pop(context, true);
        }
      },
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileLoadingState) {
          return LoadingScreen(
              color: Theme.of(context).colorScheme.onSecondary);
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // name
                MyTextField(
                  label: "Full Name",
                  hint: "",
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  underlineColor: Theme.of(context).colorScheme.onSecondary,
                  widthFactor: 1,
                  controller: _nameController,
                ),

                // spacing
                const SizedBox(height: 10),

                // name
                MyTextField(
                  label: "Phone Number",
                  hint: "",
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  underlineColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  widthFactor: 1,
                  controller: _contactController,
                ),

                // spacing
                const SizedBox(height: 20),

                // municipalities dropdown
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: DropdownButtonFormField<MunicipalityModel>(
                    value: selectedMunicipality,
                    onChanged: (MunicipalityModel? newValue) {
                      setState(() {
                        selectedMunicipality = newValue;
                        selectedBarangay = null;
                        barangays = [];
                        if (newValue != null) {
                          context.read<ProfileBloc>().add(FetchBarangaysEvent(
                              municipalityCode: newValue.code));
                        }
                      });
                    },
                    items: municipalities.map((MunicipalityModel value) {
                      return DropdownMenuItem<MunicipalityModel>(
                        value: value,
                        child: Text(
                          value.name,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: "Municipality",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    dropdownColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),

                // spacing
                const SizedBox(height: 20),

                // barangay dropdown
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary),
                  child: DropdownButtonFormField<BarangayModel>(
                    value: selectedBarangay,
                    onChanged: (BarangayModel? newValue) {
                      setState(() {
                        selectedBarangay = newValue;
                      });
                    },
                    items: barangays.map((BarangayModel value) {
                      return DropdownMenuItem<BarangayModel>(
                        value: value,
                        child: Text(
                          value.name,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      labelText: "Barangay",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    dropdownColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),

                // spacing
                const SizedBox(height: 20),

                // street name
                MyTextField(
                  label: "Street name, House No.",
                  hint: "",
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  underlineColor: Theme.of(context).colorScheme.onSecondary,
                  widthFactor: 1,
                  controller: _streetController,
                ),

                // spacing
                const SizedBox(height: 50),

                // save button
                Center(
                  child: MyButton(
                    title: "Save",
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    widthFactor: 0.80,
                    onPressed: () {
                      context.read<ProfileBloc>().add(AddUserAddressEvent(
                            barangay: selectedBarangay!.name,
                            municipality: selectedMunicipality!.name,
                            contact: _contactController.text.trim(),
                            fullName: _nameController.text.trim(),
                            street: _streetController.text.trim(),
                            token: pref.getString("token")!,
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
