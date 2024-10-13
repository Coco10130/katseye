const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  addReview,
  getAllReview,
  getReviewOfProduct,
  getReviewOfUser,
} = require("../controllers/review.controller.js");

router.post("/post-review", authMiddleware, addReview);

router.get("/get", getAllReview);

router.get("/get/:productId", getReviewOfProduct);

router.get("/review-user", authMiddleware, getReviewOfUser);

module.exports = router;
