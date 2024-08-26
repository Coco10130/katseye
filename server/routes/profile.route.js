const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const uploadMiddleware = require("../middlewares/multer.middleware.js");
const {
  getProfile,
  updateProfile,
  registerSeller,
} = require("../controllers/profile.controller.js");

router.use(authMiddleware);

router.get("/get", getProfile);

router.put("/update/:id", uploadMiddleware.single("image"), updateProfile);

router.post("/register-seller", registerSeller);

module.exports = router;
