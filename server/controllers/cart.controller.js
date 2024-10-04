const Cart = require("../models/cart.model.js");
const Product = require("../models/product.model.js");
const User = require("../models/user.model.js");
const Seller = require("../models/seller.model.js");
const Order = require("../models/order.model.js");
const jwt = require("jsonwebtoken");
const signToken = require("../helpers/sign.new.token.helper.js");

const secretKey = process.env.JWT_SECRET;

const addToCart = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const { productId } = req.params;
    const { size } = req.body;
    const decode = jwt.verify(token, process.env.JWT_SECRET);

    const product = await Product.findById(productId);
    const seller = await Seller.findById(product.sellerId);
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
          sellerName: seller.shopName,
          subTotal,
          sellerId: product.sellerId,
        };
        user.cartItems += 1;

        await user.save();
        await Cart.create(data);

        const newToken = signToken(user);
        return res.status(201).json({ success: true, token: newToken });
      }

      cart.quantity += 1;
      cart.subTotal = cart.quantity * product.price;

      const newToken = signToken(user);

      await cart.save();
      res.status(201).json({ success: true, token: newToken });
    } else {
      const data = {
        productName: product.productName,
        price: product.price,
        quantity: 1,
        productImage: image,
        productId: productId,
        userId: decode.id,
        size: size,
        sellerName: seller.shopName,
        subTotal,
        sellerId: product.sellerId,
      };
      user.cartItems += 1;

      await user.save();
      await Cart.create(data);

      const newToken = signToken(user);

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

const getCheckOutItems = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const userId = decode.id;

    const items = await Cart.find({ toCheckOut: true, userId: userId });

    if (!items) {
      return res.status(404).json({ message: "No items in cart to checkout" });
    }

    const productItems = items.map((item) => {
      const imageUrl = `${req.protocol}://${req.get("host")}/images/products/${
        item.productImage
      }`;
      return {
        ...item.toObject(),
        productImage: imageUrl,
      };
    });

    res.status(200).json({ success: true, data: productItems });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const orderItem = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userId = decode.id;

    const items = await Cart.find({ toCheckOut: true, userId: userId });

    let invalidItems = [];
    let orderItems = [];
    for (const item of items) {
      const product = await Product.findById(item.productId);
      const user = await User.findById(userId);

      const productImage = product.productImage[0];

      if (!product) {
        invalidItems.push(item._id);
      } else {
        const orderItem = {
          productname: product.productName,
          productImage: productImage,

          orderedBy: userId,
          sellerId: product.sellerId,
          productId: product._id,
          status: "pending",
        };

        orderItems.push(Order.create(orderItem));

        const seller = await Seller.findById(product.sellerId);

        seller.pendingOrders += 1;
        user.cartItems -= 1;
        await user.save();
        await seller.save();
      }
    }

    if (invalidItems.length > 0) {
      return res.status(404).json({
        message: "Some of the products are no longer available.",
        invalidItems: invalidItems,
      });
    }

    await Promise.all(orderItems);

    // delete the items in cart
    await Cart.deleteMany({ toCheckOut: true, userId: userId });

    res
      .status(200)
      .json({ success: true, message: "Items ordered successfully" });
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
  getCheckOutItems,
  orderItem,
};
