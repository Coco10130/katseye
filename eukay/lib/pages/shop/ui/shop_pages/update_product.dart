import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/inputs/my_input.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/pages/dashboard/mappers/product_model.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProductPage extends StatelessWidget {
  final String productId;

  const UpdateProductPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "Update Product",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: UpdateProductBody(productId: productId),
    );
  }
}

class UpdateProductBody extends StatefulWidget {
  final String productId;

  const UpdateProductBody({super.key, required this.productId});

  @override
  State<UpdateProductBody> createState() => _UpdateProductBodyState();
}

class _UpdateProductBodyState extends State<UpdateProductBody> {
  late SharedPreferences pref;
  String? token;
  bool initializedPref = false;

  List<String> selectedSizes = [];
  Map<String, TextEditingController> sizeQuantityControllers = {};
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      fetchProduct();
    });
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

  Future<void> initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("token");
      initializedPref = true;
    });
  }

  void initializeProductDetails(ProductModel product) {
    _productNameController.text = product.productName;
    _productPriceController.text = product.price.toString();
    _productDescriptionController.text = product.productDescription;

    selectedSizes.clear();
    sizeQuantityControllers.clear();

    for (final sizeQuantity in product.sizeQuantities) {
      selectedSizes.add(sizeQuantity.size);
      sizeQuantityControllers[sizeQuantity.size] =
          TextEditingController(text: sizeQuantity.quantity.toString());
    }

    setState(() {});
  }

  Future<void> fetchProduct() async {
    context.read<ShopBloc>().add(
        FetchUpdateProductEvent(productId: widget.productId, token: token!));
  }

  bool _isFormValid() {
    return _productNameController.text.isNotEmpty &&
        _productPriceController.text.isNotEmpty &&
        selectedSizes.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!initializedPref) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state is UpdateProductFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is UpdateProductSuccessState) {
          _resetForm();
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.successMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is FetchUpdateProductState) {
          final product = state.product;
          initializeProductDetails(product);
        }
      },
      builder: (context, state) {
        if (state is FetchUpdateProductState) {
          final product = state.product;
          _productNameController.text = product.productName;
          _productPriceController.text = product.price.toString();
          _productDescriptionController.text = product.productDescription;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name input
                  _buildTextField("Product Name", "E.G stylish shirt",
                      _productNameController),

                  // Spacing
                  const SizedBox(height: 10),

                  // Description input
                  _buildTextField(
                      "Product Description",
                      "Enter the product description",
                      _productDescriptionController),

                  // Spacing
                  const SizedBox(height: 20),

                  // Price input
                  _buildPriceInput(context),

                  // Spacing
                  const SizedBox(height: 20),

                  // Sizes input
                  _buildSizes(),

                  // Spacing
                  const SizedBox(height: 20),

                  // Quantity of size input
                  _buildSizeQuantityInputs(),

                  // Spacing
                  const SizedBox(height: 50),

                  // Submit button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MyButton(
                      title: "Update",
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: _isFormValid()
                          ? () {
                              context.read<ShopBloc>().add(
                                    UpdateProductEvent(
                                      productId: widget.productId,
                                      token: pref.getString("token")!,
                                      sizes: selectedSizes,
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
        }
        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
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
    // Check if selectedSizes is not empty to render quantity inputs
    if (selectedSizes.isEmpty) {
      return Container(); // Return an empty container if no sizes are selected
    }

    return Column(
      children: selectedSizes.map((size) {
        // Ensure each controller is initialized properly
        sizeQuantityControllers.putIfAbsent(
            size, () => TextEditingController());
        final controller = sizeQuantityControllers[size]!;

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
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Collect the quantities for each selected size
  Map<String, int> _getTotalQuantity() {
    final Map<String, int> sizeQuantities = {};
    sizeQuantityControllers.forEach((size, controller) {
      sizeQuantities[size] = int.tryParse(controller.text) ?? 0;
    });
    return sizeQuantities;
  }

  void _resetForm() {
    _productNameController.clear();
    _productDescriptionController.clear();
    _productPriceController.clear();
    _productStockController.clear();
    selectedSizes.clear();
    sizeQuantityControllers.clear();
  }
}
