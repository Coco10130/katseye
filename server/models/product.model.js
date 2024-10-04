const mongoose = require("mongoose");

const ProductSchema = mongoose.Schema(
  {
    productImage: {
      type: [String],
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

    productDescription: {
      type: String,
      required: true,
    },

    categories: {
      type: [String],
      required: true,
    },

    sizes: {
      type: [String],
      required: true,
    },

    status: {
      type: String,
      default: "live",
    },

    rating: {
      type: Number,
      default: 0.0,
    },

    reviews: {
      type: Number,
      default: 0,
    },

    sellerName: {
      type: String,
      required: true,
    },

    wishedByUser: {
      type: [mongoose.Schema.Types.ObjectId],
      ref: "User",
      default: [],
    },

    sellerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const Product = mongoose.model("Product", ProductSchema);

module.exports = Product;
