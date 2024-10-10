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

router.post("/mark-order/:orderId/:status/:sellerId", markAsNextStep);

router.post(
  "/change-status/:status/:sellerId/:nextStatus",
  changeProductSalesStatus
);

module.exports = router;
