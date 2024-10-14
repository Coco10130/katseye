const jwt = require("jsonwebtoken");
const Seller = require("../models/seller.model.js");
const Report = require("../models/report.model.js");
const Order = require("../models/order.model.js");
const Cart = require("../models/cart.model.js");
const Product = require("../models/product.model.js");

const secretKey = process.env.JWT_SECRET;

const getSellers = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decoded = jwt.verify(token, secretKey);

    const role = decoded.role;

    if (role !== "admin") {
      return res.status(403).json({ message: "Unauthorized" });
    }

    const sellers = await Seller.find().populate("userId", "username");

    const sellerDataPromises = sellers.map(async (seller) => {
      const orderCounts = await Order.aggregate([
        { $match: { sellerId: seller._id } },
        {
          $group: {
            _id: null,
            completeOrders: {
              $sum: { $cond: [{ $eq: ["$status", "completed"] }, 1, 0] },
            },
            deliverOrders: {
              $sum: { $cond: [{ $eq: ["$status", "delivered"] }, 1, 0] },
            },
            pendingOrders: {
              $sum: { $cond: [{ $eq: ["$status", "pending"] }, 1, 0] },
            },
          },
        },
      ]);

      return {
        seller,
        orderCounts:
          orderCounts.length > 0
            ? orderCounts[0]
            : {
                completeOrders: 0,
                deliverOrders: 0,
                pendingOrders: 0,
              },
      };
    });

    const sellerData = await Promise.all(sellerDataPromises);

    res.status(200).json({
      success: true,
      sellers: sellerData,
    });
  } catch (error) {
    console.error("Error fetching sellers:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
};

const getReports = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decoded = jwt.verify(token, secretKey);

    const role = decoded.role;

    if (role !== "admin") {
      return res.status(403).json({ message: "Unauthorized" });
    }

    const reports = await Report.find().populate("productId", "name");

    res.status(200).json({
      success: true,
      reports,
    });
  } catch (error) {
    console.error("Error fetching reports:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
};

const deleteProduct = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decoded = jwt.verify(token, secretKey);

    const role = decoded.role;

    if (role !== "admin") {
      return res.status(403).json({ message: "Unauthorized" });
    }

    const { reportId } = req.params;

    const report = await Report.findById(reportId);
    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    const productId = report.productId;

    // Delete the product
    const deletedProduct = await Product.findByIdAndDelete(productId);
    if (!deletedProduct) {
      return res.status(404).json({ message: "Product not found" });
    }

    // Find and update orders that contain the deleted product
    const orders = await Order.find({ "products.productId": productId });

    for (const order of orders) {
      const sellerId = order.sellerId;
      const status = order.status;

      const seller = await Seller.findById(sellerId);

      // Deduct the seller's order count based on the order status
      switch (status) {
        case "pending":
          seller.pendingOrders -= 1;
          break;
        case "to prepare":
          seller.prepareOrders -= 1;
          break;
        case "to deliver":
          seller.deliverOrders -= 1;
          break;
        case "delivered":
          seller.deliveredOrders -= 1;
          break;
        case "completed":
          seller.completeOrders -= 1;
          break;
        case "canceled":
          seller.canceledOrders -= 1;
          break;
      }

      // Remove the product from the order
      order.products = order.products.filter(
        (p) => p.productId.toString() !== productId.toString()
      );

      if (order.products.length > 0) {
        await order.save();
      } else {
        await Order.findByIdAndDelete(order._id); // Delete order if no products are left
      }

      await seller.save();
    }

    // Delete cart items related to the product
    await Cart.deleteMany({ productId });

    // Update the seller's product counts
    const sellerOfProduct = await Seller.findById(deletedProduct.sellerId);

    // Check the product status before deducting
    if (deletedProduct.status === "live") {
      sellerOfProduct.live -= 1; // Deduct from live count if live
    } else if (deletedProduct.status === "soldOut") {
      sellerOfProduct.soldOut -= 1; // Deduct from soldOut count if sold out
    }

    sellerOfProduct.products -= 1; // Deduct total product count
    await sellerOfProduct.save();

    // Delete all reports related to the product
    await Report.deleteMany({ productId }).exec();

    res.status(200).json({
      success: true,
      message:
        "Product, all related reports, cart items, and related orders deleted successfully. Seller data updated.",
    });
  } catch (error) {
    res.status(500).json({
      errorMessage: error.message,
    });
  }
};

module.exports = { getSellers, getReports, deleteProduct };
