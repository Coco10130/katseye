const express = require("express");
const router = express.Router();
const {
  processOrder,
  markAsNextStep,
  cancelOrderByUser,
  changeProductSalesStatus,
  cancelOrderBySeller,
  getOrdersProductByStatus,
} = require("../controllers/order.controller.js");
const authMiddleware = require("../middlewares/auth.middleware.js");

router.use(authMiddleware);

router.post("/process", processOrder);

router.put("/mark-order/:orderId/:status/:sellerId", markAsNextStep);

router.put(
  "/change-status/:status/:sellerId/:nextStatus",
  changeProductSalesStatus
);

router.get("/get", getOrdersProductByStatus);

router.put("/cancel-order/user/:orderId/:status", cancelOrderByUser);

router.put("/cancel-order/seller/:sellerId", cancelOrderBySeller);

module.exports = router;
