const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  getSellers,
  getReports,
  deleteProduct,
} = require("../controllers/admin.controller.js");

router.use(authMiddleware);

router.get("/get/sellers", getSellers);

router.get("/get/reports", getReports);

router.delete("/delete/product/:reportId", deleteProduct);

module.exports = router;
