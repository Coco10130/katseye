const Cart = require("../models/cart.model.js");
const Product = require("../models/product.model.js");
const User = require("../models/user.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const addToCart = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { productId } = req.params.productId;
    const { quantity } = req.body;
    const decode = jwt.verify(authorizationHeader, secretKey);

    const product = await Product.findById(productId);
    const user = await User.findById(decode.id);
    const existingProduct = await Cart.findOne({
      productId: productId,
      userId: decode.id,
    });

    if (!existingProduct) {
      const totalPrice = product.price * quantity;
      const data = {
        productName: product.productName,
        productImage: product.productImage[1],
        quantity: quantity,
        price: totalPrice,
        productId: product.productId,
        userId: user._id,
      };

      user.cartItems += 1;
      await user.save();
      await Cart.create(data);

      return res.status(201).json({ message: "Product added successfully" });
    } else {
      existingProduct.quantity += quantity;
      existingProduct.price = existingProduct.quantity * product.price;

      await existingProduct.save();
      return res.status(201).json({ message: "Product added successfully" });
    }
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const showCart = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const cart = await Cart.find({ userId: jwt.decode.id });

    res.status(200).json({ success: true, data: cart });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addToCart,
  showCart,
};
