const express = require("express");
const {
  login,
  register,
  verifyOtp,
  sendOtp,
  changePassword,
} = require("../controllers/auth.controller");
const router = express.Router();

router.post("/login", login);

router.post("/register", register);

router.post("/send-otp", sendOtp);

router.post("/verify-otp", verifyOtp);

router.post("/change-password", changePassword);

module.exports = router;
