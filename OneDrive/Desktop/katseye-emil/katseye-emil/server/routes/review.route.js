const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  addReview,
  getAllReview,
  getReviewOfProduct,
} = require("../controllers/review.controller.js");

router.post("/post-review", authMiddleware, addReview);

router.get("/get", getAllReview);

router.get("/get/:productId", getReviewOfProduct);

module.exports = router;
