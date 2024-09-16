const Cart = require("../models/cart.model.js");
const Product = require("../models/product.model.js");
const User = require("../models/user.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const addToCart = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    const token = authorizationHeader.split(" ")[1];
    const { productId } = req.params;
    const { quantity } = req.body;
    const decode = jwt.verify(token, process.env.JWT_SECRET);

    const product = await Product.findById(productId);
    const user = await User.findOne({ _id: decode.id });
    const cart = await Cart.findOne({
      productId: productId,
      userId: user._id,
    });

    const existingCart = await Cart.findOne({ userId: user._id });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    const image = product.productImage[0];
    const subTotal = 1 * parseInt(product.price);

    if (cart) {
      if (!existingCart) {
        const data = {
          productName: product.productName,
          price: product.price,
          quantity: 1,
          productImage: image,
          productId: productId,
          userId: decode.id,
          subTotal,
        };
        user.cartItems += 1;

        await user.save();
        await Cart.create(data);
        res.status(201).json({ success: true });
      }

      cart.quantity += 1;
      cart.subTotal = cart.quantity * product.price;

      await cart.save();
      res.status(201).json({ success: true });
    } else {
      console.log("test");
      const data = {
        productName: product.productName,
        price: product.price,
        quantity: 1,
        productImage: image,
        productId: productId,
        userId: decode.id,
        subTotal,
      };
      user.cartItems += 1;

      await user.save();
      await Cart.create(data);
      res.status(201).json({ success: true });
    }
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const showCart = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const cart = await Cart.find({ userId: decode.id });

    const cartItems = cart.map((item) => {
      const imageUrl = `${req.protocol}://${req.get("host")}/images/products/${
        item.productImage
      }`;
      return {
        ...item.toObject(),
        productImage: imageUrl,
      };
    });

    res.status(200).json({
      success: true,
      data: cartItems,
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addToCart,
  showCart,
};
