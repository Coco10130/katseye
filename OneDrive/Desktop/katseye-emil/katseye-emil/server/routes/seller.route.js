const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  registerSeller,
  sendOtp,
  getSellerProfile,
} = require("../controllers/seller.controller.js");

router.use(authMiddleware);

router.post("/register-seller", registerSeller);

router.get("/get-seller-profile", getSellerProfile);

router.post("/send-otp", sendOtp);

module.exports = router;
