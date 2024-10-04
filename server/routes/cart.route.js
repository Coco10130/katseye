const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  addToCart,
  showCart,
  addQuantity,
  minusQuantity,
  checkItem,
  getCheckOutItems,
  orderItem,
} = require("../controllers/cart.controller");

router.use(authMiddleware);

router.post("/addTocart/:productId", addToCart);

router.get("/get-cart", showCart);

router.post("/add-quantity/:cartItemId", addQuantity);

router.post("/minus-quantity/:cartItemId", minusQuantity);

router.post("/to-check-out/:cartItemId", checkItem);

router.get("/get/orders", getCheckOutItems);

router.get("/order-items", orderItem);

module.exports = router;
