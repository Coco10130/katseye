const mongoose = require("mongoose");

const ProductDetailsSchema = mongoose.Schema({
  productName: {
    type: String,
    required: true,
  },

  productImage: {
    type: [String],
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

  price: {
    type: Number,
    required: true,
  },

  rated: {
    type: Boolean,
    required: false,
    default: false,
  },

  productId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Product",
    required: true,
  },
});

const OrderSchema = mongoose.Schema(
  {
    products: [ProductDetailsSchema],

    totalPrice: {
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

    shopName: {
      type: String,
      required: true,
    },

    orderedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    markAsNextStep: {
      type: Boolean,
      required: false,
      default: false,
    },

    sellerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Seller",
      required: true,
    },

    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    status: {
      type: String,
      required: false,
      enum: [
        "pending",
        "to prepare",
        "to deliver",
        "delivered",
        "completed",
        "canceled",
      ],
      default: "pending",
    },
  },
  {
    timestamps: true,
  }
);

const Order = mongoose.model("Order", OrderSchema);

module.exports = Order;
