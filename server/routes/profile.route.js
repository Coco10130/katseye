const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const { uploadProfile } = require("../middlewares/multer.middleware.js");
const {
  getProfile,
  updateProfile,
} = require("../controllers/profile.controller.js");

router.use(authMiddleware);

router.get("/get", getProfile);

router.put("/update/:id", uploadProfile.single("image"), updateProfile);

module.exports = router;
