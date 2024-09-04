const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const upload = require("../middlewares/multer.middleware.js");
const {
  getProfile,
  updateProfile,
  registerSeller,
  sendOtp,
} = require("../controllers/profile.controller.js");

router.use(authMiddleware);

router.get("/get", getProfile);

router.put("/update/:id", upload.single("image"), updateProfile);

router.post("/register-seller", registerSeller);

router.post("/send-otp", sendOtp);

module.exports = router;
