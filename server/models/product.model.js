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

const Product = mongoose.model("product", ProductSchema);

module.exports = Product;
