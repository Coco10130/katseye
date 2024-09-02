const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const { addToCart, showCart } = require("../controllers/cart.controller");

router.use(authMiddleware);

router.post("/addTocart/:productId", addToCart);

router.get("/getCart", showCart);

module.exports = router;
