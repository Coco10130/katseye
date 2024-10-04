const mongoose = require("mongoose");

const OrderSchema = mongoose.Schema(
  {
    productName: {
      type: String,
      required: true,
    },

    productImage: {
      type: String,
      required: true,
    },

    totalPrice: {
      type: Number,
      required: true,
    },

    size: {
      type: String,
      required: true,
    },

    quantity: {
      type: Number,
      required: true,
    },

    deliveryAddress: {
      type: String,
      required: true,
    },

    buyerContact: {
      type: String,
      required: true,
    },

    buyerName: {
      type: String,
      required: true,
    },

    orderedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    sellerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Seller",
      required: true,
    },

    status: {
      type: String,
      required: false,
      enum: ["pending", "preparing", "to deliver", "delivered", "cancelled"],
      default: "pending",
    },
  },
  {
    timestamps: true,
  }
);

const Order = mongoose.model("Order", OrderSchema);

module.exports = Order;
