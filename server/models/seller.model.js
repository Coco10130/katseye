const mongoose = require("mongoose");

const SellerSchema = mongoose.Schema(
  {
    shopName: {
      type: String,
      required: false,
    },

    shopEmail: {
      type: String,
      required: false,
    },

    shopContact: {
      type: String,
      required: false,
    },

    image: {
      type: String,
      required: false,
    },

    pendingOrders: {
      type: Number,
      required: false,
      default: 0,
    },

    prepareOrders: {
      type: Number,
      required: false,
      default: 0,
    },

    deliverOrders: {
      type: Number,
      required: false,
      default: 0,
    },

    reviewOrders: {
      type: Number,
      required: false,
      default: 0,
    },

    products: {
      type: Number,
      required: false,
      default: 0,
    },

    live: {
      type: Number,
      required: false,
      default: 0,
    },

    soldOut: {
      type: Number,
      required: false,
      default: 0,
    },

    delisted: {
      type: Number,
      required: false,
      default: 0,
    },

    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const Seller = mongoose.model("Seller", SellerSchema);

module.exports = Seller;
