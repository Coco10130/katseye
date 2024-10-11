const express = require("express");
const router = express.Router();
const {
  processOrder,
  markAsNextStep,
  changeProductSalesStatus,
} = require("../controllers/order.controller.js");
const authMiddleware = require("../middlewares/auth.middleware.js");

router.use(authMiddleware);

router.post("/process", processOrder);

router.put("/mark-order/:orderId/:status/:sellerId", markAsNextStep);

router.put(
  "/change-status/:status/:sellerId/:nextStatus",
  changeProductSalesStatus
);

module.exports = router;
