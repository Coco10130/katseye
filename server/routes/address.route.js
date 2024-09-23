const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  addAddress,
  getAddress,
} = require("../controllers/address.controller.js");

router.use(authMiddleware);

router.post("/add", addAddress);

router.get("/user", getAddress);

module.exports = router;
