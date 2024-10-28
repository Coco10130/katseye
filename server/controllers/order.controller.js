const Product = require("../models/product.model.js");
const Address = require("../models/address.model.js");
const Cart = require("../models/cart.model.js");
const jwt = require("jsonwebtoken");
const Order = require("../models/order.model.js");
const User = require("../models/user.model.js");
const Seller = require("../models/seller.model.js");
const Notification = require("../models/notification.model.js");
const signToken = require("../helpers/sign.new.token.helper.js");
const fs = require("fs");
const path = require("path");

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

        // Delete size if the quantity reached 0
        if (matchingSizeQuantity.quantity === 0) {
          item.productId.sizeQuantities = item.productId.sizeQuantities.filter(
            (sizeQuantity) => sizeQuantity.size !== item.size
          );
        }

        if (item.productId.sizeQuantities.length === 0) {
          item.productId.status = "sold out";
          const message = `Your product has ${item.productId.productName} no quantity`;
          const sellerId = item.productId.sellerId;
          const seller = await Seller.findById(sellerId);

          await Notification.create({
            icon: "shop.png",
            userId: seller.userId,
            message,
          });

          await Seller.findByIdAndUpdate(sellerId, {
            $inc: { soldOut: 1, live: -1, products: -1 },
          });
        }
        await item.productId.save();
      }
    }

    const orders = [];
    // Set to track processed product IDs
    const processedProductIds = new Set();

    for (const sellerId in groupedOrders) {
      const { products, totalPrice, sellerName } = groupedOrders[sellerId];
      const seller = await Seller.findById(sellerId);

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

      const notificationMessage = `You have a new order from ${user.userName} for ${products.length} item(s).`;

      await Notification.create({
        icon: "shop.png",
        userId: seller.userId,
        message: notificationMessage,
      });

      for (const product of products) {
        const productId = product.productId.toString();
        if (!processedProductIds.has(productId)) {
          const images = product.productImage;
          for (const image of images) {
            const sourcePath = path.join(
              __dirname,
              `../images/products/${image}`
            );
            const destPath = path.join(__dirname, `../images/orders/${image}`);

            fs.mkdirSync(path.dirname(destPath), { recursive: true });

            fs.copyFileSync(sourcePath, destPath);
          }
          processedProductIds.add(productId);
        }
      }

      user.cartItems -= products.length;
      await user.save();

      await Seller.findByIdAndUpdate(sellerId, {
        $inc: { pendingOrders: products.length },
      });

      await User.findByIdAndUpdate(userId, {
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
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const { status, sellerId, nextStatus } = req.params;

    const orders = await Order.find({ status, sellerId, markAsNextStep: true });
    const seller = await Seller.findById(sellerId);

    if (orders.length === 0) {
      return res.status(404).json({ message: "No orders found." });
    }

    await Promise.all(
      orders.map(async (order) => {
        const orderLength = order.products.length;
        order.markAsNextStep = false;
        order.status = nextStatus;

        const orderedBy = order.userId;

        switch (status) {
          case "pending":
            await Seller.findByIdAndUpdate(sellerId, {
              $inc: { pendingOrders: -orderLength, prepareOrders: orderLength },
            });

            await User.findByIdAndUpdate(orderedBy, {
              $inc: { pendingOrders: -orderLength, prepareOrders: orderLength },
            });

            await Notification.create({
              icon: "user.png",
              userId: orderedBy,
              message: `Your order has been accepted by ${seller.shopName}`,
            });

            break;
          case "to prepare":
            await Seller.findByIdAndUpdate(sellerId, {
              $inc: { prepareOrders: -orderLength, deliverOrders: orderLength },
            });

            await User.findByIdAndUpdate(orderedBy, {
              $inc: { prepareOrders: -orderLength, deliverOrders: orderLength },
            });

            await Notification.create({
              icon: "user.png",
              userId: orderedBy,
              message: `Your parcel was out for delivery`,
            });

            break;

          case "to deliver":
            await Seller.findByIdAndUpdate(sellerId, {
              $inc: {
                deliverOrders: -orderLength,
                deliveredOrders: orderLength,
              },
            });

            await User.findByIdAndUpdate(orderedBy, {
              $inc: {
                deliverOrders: -orderLength,
                deliveredOrders: orderLength,
              },
            });

            await Notification.create({
              icon: "user.png",
              userId: orderedBy,
              message: `Your parcel has delivered`,
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

const cancelOrderByUser = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userId = decode.id;
    const { orderId, status } = req.params;

    const orders = await Order.findOne({ _id: orderId, status: status });

    const sellerId = orders.sellerId;

    if (!orders || orders.length === 0) {
      return res.status(404).json({ message: "Order not found." });
    }

    if (orders.markAsNextStep) {
      return res.status(400).json({ message: "Can't cancel this order" });
    }

    const orderLength = orders.products.length;

    switch (status) {
      case "pending":
        await Seller.findByIdAndUpdate(sellerId, {
          $inc: { pendingOrders: -orderLength, completeOrders: orderLength },
        });
        await User.findByIdAndUpdate(userId, {
          $inc: { pendingOrders: -orderLength, completeOrders: orderLength },
        });
        break;
      case "to prepare":
        await Seller.findByIdAndUpdate(sellerId, {
          $inc: { prepareOrders: -orderLength, completeOrders: orderLength },
        });
        await User.findByIdAndUpdate(userId, {
          $inc: { prepareOrders: -orderLength, completeOrders: orderLength },
        });
        break;

      default:
        console.log("Unknown");
    }

    const seller = await Seller.findById(sellerId);

    if (!seller) {
      return res.status(404).json({ message: "Seller not found." });
    }

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }

    await Notification.create({
      icon: "shop.png",
      userId: seller.userId,
      message: `Order has canceled by ${user.userName}`,
    });

    await Order.findByIdAndUpdate(orderId, { status: "canceled" });

    res
      .status(200)
      .json({ success: true, message: "Product canceled successfully" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const cancelOrderBySeller = async (req, res) => {
  try {
    const { sellerId } = req.params;

    const orders = await Order.find({
      sellerId: sellerId,
      markAsNextStep: true,
      status: "pending",
    });

    const seller = await Seller.findById(sellerId);

    if (!orders || orders.length === 0) {
      return res.status(404).json({ message: "Order not found." });
    }

    let totalProductsToCancel = 0;
    const userOrderCounts = {};

    orders.forEach((order) => {
      const userId = order.orderedBy.toString();
      const productCount = order.products.length;
      totalProductsToCancel += productCount;

      userOrderCounts[userId] = (userOrderCounts[userId] || 0) + productCount;
    });

    // Update the seller's pending orders and canceled orders count
    await Seller.updateOne(
      { _id: sellerId },
      {
        $inc: {
          pendingOrders: -totalProductsToCancel,
          canceledOrders: totalProductsToCancel,
        },
      }
    );

    // Update each user's pending orders based on the total number of products
    for (const userId in userOrderCounts) {
      await User.updateOne(
        { _id: userId },
        {
          $inc: {
            pendingOrders: -userOrderCounts[userId],
            completeOrders: userOrderCounts[userId],
          },
        }
      );

      await Notification.create({
        icon: "user.png",
        userId: userId,
        message: `Your order has canceled by ${seller.shopName}`,
      });
    }

    await Order.updateMany(
      { sellerId: sellerId, markAsNextStep: true, status: "pending" },
      { status: "canceled" }
    );

    res.status(200).json({
      success: true,
      message: "Product canceled successfully",
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getOrdersProductByStatus = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userId = decode.id;
    const { status } = req.query;

    const statuses = status.split(",");

    const orders = await Order.find({
      userId: userId,
      status: { $in: statuses },
    });

    const updatedOrders = orders.map((order) => {
      const updatedProducts = order.products.map((product) => {
        const imageUrls = product.productImage.map(
          (image) =>
            `${req.protocol}://${req.get("host")}/images/orders/${image}`
        );
        return { ...product.toObject(), productImage: imageUrls };
      });

      return { ...order.toObject(), products: updatedProducts };
    });

    return res.status(200).json({ success: true, data: updatedOrders });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  processOrder,
  markAsNextStep,
  changeProductSalesStatus,
  cancelOrderByUser,
  getOrdersProductByStatus,
  cancelOrderBySeller,
};
