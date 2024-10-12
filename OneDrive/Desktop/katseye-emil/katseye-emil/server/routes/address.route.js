const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  addAddress,
  getAddress,
  deleteAddress,
  useAddress,
  
} = require("../controllers/address.controller.js");

router.use(authMiddleware);

router.post("/add", addAddress);

router.get("/user", getAddress);

router.delete("/delete/:addressId", deleteAddress);

router.put("/use-address/:addressId", useAddress);

module.exports = router;
