const jwt = require("jsonwebtoken");
const Product = require("../models/product.model");
const Wishlist = require("../models/wishlist.model");

const secretKey = process.env.JWT_SECRET;

const addWishlist = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const { productId } = req.params;
    const userId = decode.id;

    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    if (!product.wishedByUser.includes(userId)) {
      product.wishedByUser.push(userId);
      await product.save();
    }

    const payload = {
      productId: product._id,
      userId: userId,
    };

    await Wishlist.create(payload);

    res
      .status(201)
      .json({ success: true, message: "Product added to wishlist" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getAllWishlist = async (req, res) => {
  try {
    const wishlist = await Wishlist.find({});
    res.status(200).json({ success: true, data: wishlist });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getWishlistByUser = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const wishlist = await Wishlist.find({ userId: decode.id });

    const productIds = wishlist.map((item) => item.productId);

    const products = await Product.find({
      _id: { $in: productIds },
      status: { $in: "live" },
    });

    const productsWithImageUrl = products.map((product) => {
      const imageUrls = product.productImage.map(
        (image) =>
          `${req.protocol}://${req.get("host")}/images/products/${image}`
      );

      return {
        ...product.toObject(),
        productImage: imageUrls,
      };
    });

    res.status(200).json({ success: true, data: productsWithImageUrl });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const deleteWishlist = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const { productId } = req.params;
    const userId = decode.id;

    const wishlist = await Wishlist.findOne({
      userId: userId,
      productId: productId,
    });

    if (!wishlist) {
      return res.status(404).json({ message: "Product not found in wishlist" });
    }

    await Product.findByIdAndUpdate(productId, {
      $pull: { wishedByUser: userId },
    });

    await Wishlist.findByIdAndDelete(wishlist._id);

    res.status(200).json({
      message: "Product removed from wishlist successfully",
      success: true,
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addWishlist,
  getAllWishlist,
  deleteWishlist,
  getWishlistByUser,
};
