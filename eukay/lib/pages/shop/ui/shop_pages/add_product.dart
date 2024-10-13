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
          Navigator.pop(context, true);
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
  List<String> selectedSizes = [];
  Map<String, TextEditingController> sizeQuantityControllers = {};
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  List<String> categoryItems = [
    "Men",
    "Women",
    "Shoes",
    "Pants",
    "Shirts",
    "Long Sleeves",
    "Jacket",
    "Cap",
    "Hoodie",
    "Belt",
    "Suits",
    "Blouse",
    "Dress",
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
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    _productStockController.dispose();
    sizeQuantityControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
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

  bool _isFormValid() {
    return _productNameController.text.isNotEmpty &&
        _productPriceController.text.isNotEmpty &&
        _imageFiles.isNotEmpty &&
        selectedCategories.isNotEmpty &&
        selectedSizes.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is AddProductFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is AddProductSuccessState) {
          _resetForm();
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ShopLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image input
                _buildImageInput(context),

                // spacing
                const SizedBox(height: 20),

                // product name input
                _buildTextField("Product Name", "E.G stylish shirt",
                    _productNameController),

                // spacing
                const SizedBox(height: 10),

                // description input
                _buildTextField(
                    "Product Description",
                    "Enter the product description",
                    _productDescriptionController),

                // spacing
                const SizedBox(height: 20),

                // select category
                _buildCategorySelector(),

                // spacing
                const SizedBox(height: 20),

                // price input
                _buildPriceInput(context),

                // spacing
                const SizedBox(height: 20),

                // sizes input
                _buildSizes(),

                // spacing
                const SizedBox(height: 20),

                // quantity of size input
                _buildSizeQuantityInputs(),

                // spacing
                const SizedBox(height: 50),

                // submit button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MyButton(
                    title: "Submit",
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: _isFormValid()
                        ? () {
                            context.read<ShopBloc>().add(
                                  AddProductEvent(
                                    token: pref.getString("token")!,
                                    images: _imageFiles,
                                    sizes: selectedSizes,
                                    categories: selectedCategories,
                                    price: _productPriceController.text,
                                    sizeQuantities: _getTotalQuantity(),
                                    productName:
                                        _productNameController.text.trim(),
                                    description: _productDescriptionController
                                        .text
                                        .trim(),
                                  ),
                                );
                          }
                        : () {}, // Disable button if the form is invalid
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return MyTextField(
      label: label,
      hint: hint,
      controller: controller,
      textColor: Theme.of(context).colorScheme.onSecondary,
      underlineColor: Theme.of(context).colorScheme.onSecondary,
      cursorColor: Theme.of(context).colorScheme.onSecondary,
    );
  }

  Widget _buildImageInput(BuildContext context) {
    return Column(
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
        const SizedBox(height: 10),
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
                Icon(
                  Iconsax.add,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                Text(
                  "${_imageFiles.length}/5",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return MultiSelectDialogField(
      barrierColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      items: categoryItems
          .map((category) => MultiSelectItem(category, category))
          .toList(),
      title: Text(
        "Categories",
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.secondary,
      chipDisplay: MultiSelectChipDisplay(
        chipColor: Theme.of(context).colorScheme.onPrimary,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonText: Text(
        "Select Categories",
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      onConfirm: (values) {
        setState(() {
          selectedCategories = List<String>.from(values);
        });
      },
    );
  }

  Widget _buildPriceInput(BuildContext context) {
    return _buildTextField(
      "Price",
      "Enter the product price",
      _productPriceController,
    );
  }

  Widget _buildSizes() {
    return MultiSelectDialogField(
      barrierColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      items: sizes.map((size) => MultiSelectItem(size, size)).toList(),
      title: Text(
        "Select Sizes",
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.secondary,
      chipDisplay: MultiSelectChipDisplay(
        chipColor: Theme.of(context).colorScheme.onPrimary,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonText: Text(
        "Select Sizes",
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      onConfirm: (values) {
        setState(() {
          selectedSizes = List<String>.from(values);
        });
      },
    );
  }

  Widget _buildSizeQuantityInputs() {
    return Column(
      children: selectedSizes.map((size) {
        final controller = TextEditingController();
        sizeQuantityControllers[size] = controller;
        return Row(
          children: [
            Text(
              size,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MyTextField(
                label: "Quantity",
                controller: controller,
                hint: "Quantity",
                textColor: Theme.of(context).colorScheme.onSecondary,
                underlineColor: Theme.of(context).colorScheme.onSecondary,
                cursorColor: Theme.of(context).colorScheme.onSecondary,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Map<String, String> _getTotalQuantity() {
    Map<String, String> quantities = {};
    selectedSizes.forEach((size) {
      quantities[size] = sizeQuantityControllers[size]?.text ?? "0";
    });
    return quantities;
  }

  void _resetForm() {
    _productNameController.clear();
    _productDescriptionController.clear();
    _productPriceController.clear();
    _productStockController.clear();
    setState(() {
      selectedCategories.clear();
      selectedSizes.clear();
      _imageFiles.clear();
      sizeQuantityControllers.clear();
    });
  }
}
