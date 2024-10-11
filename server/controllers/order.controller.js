const Product = require("../models/product.model.js");
const Address = require("../models/address.model.js");
const Cart = require("../models/cart.model.js");
const jwt = require("jsonwebtoken");
const Order = require("../models/order.model.js");
const User = require("../models/user.model.js");
const Seller = require("../models/seller.model.js");
const signToken = require("../helpers/sign.new.token.helper.js");
const secretKey = process.env.JWT_SECRET;

const processOrder = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userId = decode.id;

    const userAddress = await Address.findOne({
      inUse: true,
      userId: userId,
    });

    const user = await User.findById(userId);

    if (!userAddress) {
      return res.status(404).json({ message: "No active address found." });
    }

    const deliveryAddress = `${userAddress.province}, ${userAddress.municipality}, ${userAddress.barangay}, ${userAddress.street}`;

    const cartItems = await Cart.find({
      userId,
      toCheckOut: true,
    }).populate("productId");

    if (!cartItems || cartItems.length === 0) {
      return res.status(404).json({ message: "No items marked for checkout." });
    }

    // Initialize groupedOrders
    const groupedOrders = {};

    for (const item of cartItems) {
      const sellerId = item.sellerId.toString();

      if (!groupedOrders[sellerId]) {
        groupedOrders[sellerId] = {
          sellerId,
          products: [],
          totalPrice: 0,
          sellerName: item.sellerName,
        };
      }

      // Find matching size quantity
      const matchingSizeQuantity = item.productId.sizeQuantities.find(
        (sizeQuantity) => item.size === sizeQuantity.size
      );

      if (matchingSizeQuantity) {
        if (item.quantity > matchingSizeQuantity.quantity) {
          return res.status(400).json({
            message: `Ordered quantity for ${item.productId.productName} in size ${item.size} exceeds available stock.`,
          });
        }

        groupedOrders[sellerId].products.push({
          productName: item.productId.productName,
          productImage: item.productId.productImage,
          size: item.size,
          price: item.price,
          quantity: item.quantity,
          productId: item.productId._id,
        });

        groupedOrders[sellerId].totalPrice += item.price * item.quantity;

        // Deduct the quantity
        matchingSizeQuantity.quantity -= item.quantity;

        // delete size if the quantity reached 0
        if (matchingSizeQuantity.quantity === 0) {
          item.productId.sizeQuantities = item.productId.sizeQuantities.filter(
            (sizeQuantity) => sizeQuantity.size !== item.size
          );
        }

        if (item.productId.sizeQuantities.length === 0) {
          item.productId.status = "sold out";

          // increment product sold out of seller and decrement live products count
          await Seller.findByIdAndUpdate(sellerId, {
            $inc: { soldOut: 1, live: -1, products: -1 },
          });
        }
        await item.productId.save();
      }
    }

    const orders = [];
    for (const sellerId in groupedOrders) {
      const { products, totalPrice, sellerName } = groupedOrders[sellerId];

      const newOrder = new Order({
        products,
        totalPrice,
        deliveryAddress,
        buyerContact: userAddress.contact,
        buyerName: userAddress.fullName,
        orderedBy: userId,
        shopName: sellerName,
        userId,
        sellerId,
        status: "pending",
      });

      await newOrder.save();
      orders.push(newOrder);

      user.cartItems -= products.length;
      await user.save();

      // Increment seller's pending orders
      await Seller.findByIdAndUpdate(sellerId, {
        $inc: { pendingOrders: products.length },
      });
    }

    const newToken = signToken(user);
    await Cart.deleteMany({ userId: userId, toCheckOut: true });

    res.status(200).json({
      success: true,
      newToken: newToken,
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const markAsNextStep = async (req, res) => {
  try {
    const { orderId, status, sellerId } = req.params;

    const order = await Order.findOne({
      _id: orderId,
      status: status,
      sellerId,
    });

    order.markAsNextStep = !order.markAsNextStep;
    await order.save();

    res.status(200).json({ success: true, message: "Marked as next step" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const changeProductSalesStatus = async (req, res) => {
  try {
    const { status, sellerId, nextStatus } = req.params;

    const orders = await Order.find({ status, sellerId, markAsNextStep: true });

    if (orders.length === 0) {
      return res.status(404).json({ message: "No orders found." });
    }

    await Promise.all(
      orders.map(async (order) => {
        const orderLength = order.products.length;
        order.markAsNextStep = false;
        order.status = nextStatus;

        switch (status) {
          case "pending":
            await Seller.findByIdAndUpdate(sellerId, {
              $inc: { pendingOrders: -orderLength, prepareOrders: orderLength },
            });
            break;
          case "to prepare":
            await Seller.findByIdAndUpdate(sellerId, {
              $inc: { prepareOrders: -orderLength, deliverOrders: orderLength },
            });
            break;
          case "to deliver":
            await Seller.findByIdAndUpdate(sellerId, {
              $inc: {
                deliverOrders: -orderLength,
                deliveredOrders: orderLength,
              },
            });
            break;
          default:
            console.log("Unknown");
        }

        return await order.save();
      })
    );

    res
      .status(200)
      .json({ success: true, message: "Orders changed status successfully" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = { processOrder, markAsNextStep, changeProductSalesStatus };
