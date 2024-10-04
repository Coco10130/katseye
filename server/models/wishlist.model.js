const mongoose = require("mongoose");

const WishlistSchema = mongoose.Schema(
  {
    productId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
      require: true,
    },

    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Seller",
      require: true,
    },
  },
  {
    timeStamps: true,
  }
);

const Wishlist = mongoose.model("Wishlist", WishlistSchema);

module.exports = Wishlist;
