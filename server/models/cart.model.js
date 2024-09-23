const mongoose = require("mongoose");

const CartSchema = mongoose.Schema(
  {
    productImage: {
      type: String,
      required: true,
    },

    productName: {
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

    subTotal: {
      type: Number,
      required: true,
    },

    toCheckOut: {
      type: Boolean,
      required: false,
      default: false,
    },

    size: {
      type: String,
      required: true,
    },

    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    productId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const Cart = mongoose.model("Cart", CartSchema);

module.exports = Cart;
