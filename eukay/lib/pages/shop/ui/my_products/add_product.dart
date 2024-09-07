import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/inputs/my_input.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "Add Product",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: const AddProductBody(),
    );
  }
}

class AddProductBody extends StatefulWidget {
  const AddProductBody({super.key});

  @override
  State<AddProductBody> createState() => _AddProductBodyState();
}

class _AddProductBodyState extends State<AddProductBody> {
  late SharedPreferences pref;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];
  List<String> selectedCategories = [];
  List<String> sizes = [];
  List<String> categoryItems = [
    "Shirt",
    "Pant",
    "Shoe",
    "Accessories",
    "Watch",
    "Men",
    "Women",
  ];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    initPref();
    initPref();
  }

  @override
  void dispose() {
    super.dispose();
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    _productStockController.dispose();
  }

  void initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> _pickImages() async {
    final List<XFile> selectedImages =
        await _picker.pickMultiImage(imageQuality: 85);
    if (selectedImages.isNotEmpty) {
      setState(() {
        _imageFiles = selectedImages.take(5).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is AddProductFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              errorMessage: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is AddProductSuccessState) {
          _productNameController.clear();
          _productDescriptionController.clear();
          _productPriceController.clear();
          _productStockController.clear();
          _imageFiles = [];
          selectedCategories = [];
          sizes = [];
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              errorMessage: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ShopLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // product Image
                Column(
                  children: [
                    Text(
                      "Product Image",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // spacing
                    const SizedBox(
                      height: 10,
                    ),

                    // image input
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // plus icon
                            Icon(
                              Iconsax.add,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),

                            // image count
                            Text(
                              "${_imageFiles.length}/5",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // spacing
                const SizedBox(
                  height: 20,
                ),

                // product name input
                MyTextField(
                  label: "Product Name",
                  hint: "E.G stylish shirt",
                  controller: _productNameController,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  underlineColor: Theme.of(context).colorScheme.onSecondary,
                  cursorColor: Theme.of(context).colorScheme.onSecondary,
                ),

                // spacing
                const SizedBox(
                  height: 10,
                ),

                // product description input
                MyTextField(
                  label: "Product Description",
                  hint: "Enter the product description",
                  controller: _productDescriptionController,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  underlineColor: Theme.of(context).colorScheme.onSecondary,
                  cursorColor: Theme.of(context).colorScheme.onSecondary,
                ),

                // spacing
                const SizedBox(
                  height: 20,
                ),

                // category
                MultiSelectDialogField(
                  items: categoryItems
                      .map((category) => MultiSelectItem(category, category))
                      .toList(),
                  title: Text(
                    "Categories",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  buttonText: Text(
                    "Select Categories",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onConfirm: (values) {
                    setState(() {
                      selectedCategories = values.cast<String>();
                    });
                  },
                ),

                // spacing
                const SizedBox(
                  height: 20,
                ),

                // label
                Text(
                  "Price and Stock",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),

                // spacing
                const SizedBox(
                  height: 10,
                ),

                // price and stock
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // price
                    _input("Price", _productPriceController),
                    // stock
                    _input("Stock", _productStockController),
                  ],
                ),

                // spacing
                const SizedBox(
                  height: 20,
                ),

                // label
                Text(
                  "Sizes",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),

                // spacing
                const SizedBox(
                  height: 20,
                ),

                // sizes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _size("XS", sizes),
                    _size("S", sizes),
                    _size("M", sizes),
                    _size("L", sizes),
                    _size("XL", sizes),
                    _size("XXL", sizes),
                  ],
                ),

                // spacing
                const SizedBox(
                  height: 50,
                ),

                // submit button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MyButton(
                    title: "Submit",
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      context.read<ShopBloc>().add(
                            AddProductEvent(
                              token: pref.getString("token")!,
                              images: _imageFiles,
                              sizes: sizes,
                              categories: selectedCategories,
                              price: _productPriceController.text,
                              quantity: _productStockController.text,
                              productName: _productNameController.text.trim(),
                              description:
                                  _productDescriptionController.text.trim(),
                            ),
                          );
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

  Widget _size(String size, List<String> value) {
    bool selected = sizes.contains(size);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            sizes.remove(size);
          } else {
            sizes.add(size);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          size,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return SizedBox(
      width: 120,
      child: TextField(
        controller: controller,
        cursorColor: Theme.of(context).colorScheme.onSecondary,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
