const Product = require("../models/product.model.js");
const Order = require("../models/order.model.js");
const User = require("../models/user.model.js");
const Seller = require("../models/seller.model.js");
const Review = require("../models/review.model.js");
const jwt = require("jsonwebtoken");
const fs = require("fs");
const path = require("path");
const secretKey = process.env.JWT_SECRET;

const addReview = async (req, res) => {
  try {
    const { starRating, review, productId, orderId, id } = req.body;
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userId = decode.id;

    const user = await User.findById(userId);

    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ errorMessage: "Product not found" });
    }

    const order = await Order.findById(orderId);

    if (!order) {
      return res.status(404).json({ errorMessage: "Order not found" });
    }

    const sellerId = product.sellerId;
    const productImage = product.productImage[0];

    if (productImage) {
      const sourcePath = path.join(
        __dirname,
        "../images/products",
        productImage
      );
      const destinationPath = path.join(
        __dirname,
        "../images/reviews",
        productImage
      );

      fs.copyFile(sourcePath, destinationPath, (copyError) => {
        if (copyError) {
          return res.status(500).json({ message: "Failed to copy image" });
        }

        console.log(productImage);
      });
    }

    const newReview = new Review({
      starRating,
      review,
      productId,
      productImage,
      userId,
      sellerId,
      userName: user.userName,
      productName: product.productName,
    });

    await newReview.save();

    const totalReviews = await Review.find({ productId });
    const totalStars = totalReviews.reduce(
      (sum, review) => sum + review.starRating,
      0
    );
    let averageRating = totalStars / totalReviews.length;

    averageRating = parseFloat(averageRating.toFixed(1));

    product.rating = averageRating;

    await product.save();

    const productInOrder = order.products.find((p) => p._id.toString() === id);

    if (productInOrder) {
      productInOrder.rated = true;
      await Seller.findByIdAndUpdate(sellerId, {
        $inc: { deliveredOrders: -1, completeOrders: 1 },
      });
      await order.save();
    }

    const allProductsRated = order.products.every((p) => p.rated === true);

    if (allProductsRated) {
      order.status = "completed";
      await order.save();
    }

    res.status(201).json({
      message: "Review added successfully, product marked as rated",
      success: true,
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getAllReview = async (req, res) => {
  try {
    const reviews = await Review.find();

    res.status(200).json({ reviews });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getReviewOfProduct = async (req, res) => {
  try {
    const { productId } = req.params;

    const reviews = await Review.find({ productId }).populate({
      path: "userId",
      select: "userName image",
    });

    const response = reviews.map((review) => {
      const imageUrl = review.userId.image
        ? `${req.protocol}://${req.get("host")}/images/profiles/${
            review.userId.image
          }`
        : `${req.protocol}://${req.get(
            "host"
          )}/images/profiles/default-image.jpg`;

      console.log(review.productImage);

      const productImage = `${req.protocol}://${req.get(
        "host"
      )}/images/reviews/${review.productImage}`;

      return {
        _id: review._id,
        starRating: review.starRating,
        review: review.review,
        userName: review.userId.userName,
        userImage: imageUrl,
        productName: review.productName,
        productImage: productImage,
        createdAt: review.createdAt,
      };
    });

    res.status(200).json({ success: true, data: response });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getReviewOfUser = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userId = decode.id;

    const reviews = await Review.find({ userId }).populate({
      path: "userId",
      select: "userName image",
    });

    const response = reviews.map((review) => {
      const productImage = `${req.protocol}://${req.get(
        "host"
      )}/images/reviews/${review.productImage}`;

      const imageUrl = review.userId.image
        ? `${req.protocol}://${req.get("host")}/images/profiles/${
            review.userId.image
          }`
        : `${req.protocol}://${req.get(
            "host"
          )}/images/profiles/default-image.jpg`;

      return {
        _id: review._id,
        starRating: review.starRating,
        review: review.review,
        userName: review.userId.userName,
        productName: review.productName,
        userImage: imageUrl,
        productImage: productImage,
        createdAt: review.createdAt,
      };
    });

    res.status(200).json({ success: true, data: response });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addReview,
  getAllReview,
  getReviewOfProduct,
  getReviewOfUser,
};
