const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  addWishlist,
  getAllWishlist,
  deleteWishlist,
  getWishlistByUser,
} = require("../controllers/wishlist.controller.js");

router.use(authMiddleware);

router.post("/add/:productId", addWishlist);

router.get("/get", getAllWishlist);

router.get("/get/user", getWishlistByUser);

router.delete("/delete/:productId", deleteWishlist);

module.exports = router;
