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
    const { size } = req.body;
    const decode = jwt.verify(token, process.env.JWT_SECRET);

    const product = await Product.findById(productId);
    const user = await User.findOne({ _id: decode.id });
    const cart = await Cart.findOne({
      productId: productId,
      size: size,
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
          size: size,
          subTotal,
        };
        user.cartItems += 1;

        await user.save();
        await Cart.create(data);

        const newToken = jwt.sign(
          {
            email: user.email,
            id: user._id,
            userName: user.userName,
            role: user.role,
            cartItems: user.cartItems,
          },
          secretKey,
          { expiresIn: "7d" }
        );
        return res.status(201).json({ success: true, token: newToken });
      }

      cart.quantity += 1;
      cart.subTotal = cart.quantity * product.price;

      const newToken = jwt.sign(
        {
          email: user.email,
          id: user._id,
          userName: user.userName,
          role: user.role,
          cartItems: user.cartItems,
        },
        secretKey,
        { expiresIn: "7d" }
      );

      await cart.save();
      res.status(201).json({ success: true, token: newToken });
    } else {
      console.log("test");
      const data = {
        productName: product.productName,
        price: product.price,
        quantity: 1,
        productImage: image,
        productId: productId,
        userId: decode.id,
        size: size,
        subTotal,
      };
      user.cartItems += 1;

      await user.save();
      await Cart.create(data);

      const newToken = jwt.sign(
        {
          email: user.email,
          id: user._id,
          userName: user.userName,
          role: user.role,
          cartItems: user.cartItems,
        },
        secretKey,
        { expiresIn: "7d" }
      );

      res.status(201).json({ success: true, token: newToken });
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

const addQuantity = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const { cartItemId } = req.params;

    const cartItem = await Cart.findOne({ _id: cartItemId, userId: decode.id });

    if (!cartItem) {
      return res.status(404).json({ message: "Cart item not found" });
    }

    const product = await Product.findById(cartItem.productId);

    cartItem.quantity += 1;
    cartItem.subTotal = cartItem.quantity * product.price;

    if (cartItem.quantity > product.quantity) {
      return res.status(405).json({ message: "Not enough stock" });
    }
    await cartItem.save();

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

    res.status(200).json({ success: true, data: cartItems });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const minusQuantity = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const { cartItemId } = req.params;

    const cartItem = await Cart.findOne({ _id: cartItemId, userId: decode.id });

    if (!cartItem) {
      return res.status(404).json({ message: "Cart item not found" });
    }

    const product = await Product.findById(cartItem.productId);

    if (cartItem.quantity != 0) {
      cartItem.quantity -= 1;
      cartItem.subTotal = cartItem.quantity * product.price;
    }
    await cartItem.save();
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

    res.status(200).json({ success: true, data: cartItems });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const checkItem = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];

    const { cartItemId } = req.params;
    const decode = jwt.verify(token, secretKey);

    const cartItem = await Cart.findOne({ _id: cartItemId, userId: decode.id });
    const product = await Product.findById(cartItem.productId);

    if (!cartItem) {
      return res.status(404).json({ message: "Cart item not found" });
    }

    if (cartItem.quantity > product.quantity) {
      return res.status(405).json({ message: "Not enough stock" });
    }

    cartItem.toCheckOut = !cartItem.toCheckOut;
    await cartItem.save();

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

    res.status(200).json({ success: true, data: cartItems });

    res.status();
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const orderSummary = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const cart = await Cart.find({ userId: decode.id, toCheckOut: true });

    if (!cart) {
      return res.status(404).json({ message: "No items in cart to checkout" });
    }

    const cartItems = cart.map((item) => {
      const imageUrl = `${req.protocol}://${req.get("host")}/images/products/${
        item.productImage
      }`;
      return {
        ...item.toObject(),
        productImage: imageUrl,
      };
    });

    res.status(200).json({ success: true, data: cartItems });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addToCart,
  showCart,
  addQuantity,
  minusQuantity,
  checkItem,
  orderSummary,
};
