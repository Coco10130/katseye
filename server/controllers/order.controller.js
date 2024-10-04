const Product = require("../models/product.model.js");
const Address = require("../models/address.model.js");
const Cart = require("../models/cart.model.js");
const jwt = require("jsonwebtoken");
const Order = require("../models/order.model.js");
const User = require("../models/user.model.js");
const secretKey = process.env.JWT_SECRET;

const processOrder = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userAddress = await Address.findOne({
      inUse: true,
      userId: decode.id,
    });

    const user = await User.findById(decode.id);

    if (!userAddress) {
      return res.status(400).json({ errorMessage: "No active address found." });
    }

    const deliveryAddress = `${userAddress.province}, ${userAddress.municipality}, ${userAddress.barangay}, ${userAddress.street}`;

    const cartItems = await Cart.find({
      userId: decode.id,
      toCheckOut: true,
    }).populate("productId");

    const orders = [];
    for (const item of cartItems) {
      const newOrder = new Order({
        productName: item.productName,
        productImage: item.productImage,
        totalPrice: item.price * item.quantity,
        size: item.size,
        quantity: item.quantity,
        deliveryAddress,
        buyerContact: userAddress.contact,
        buyerName: userAddress.fullName,
        orderedBy: decode.id,
        sellerId: item.sellerId,
        status: "pending",
      });

      user.cartItems -= 1;

      await user.save();

      await newOrder.save();
      orders.push(newOrder);
    }

    await Cart.deleteMany({ userId: decode.id, toCheckOut: true });

    res.status(200).json({ success: true, data: orders });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = { processOrder };
