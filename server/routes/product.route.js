const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const { uploadProduct } = require("../middlewares/multer.middleware.js");
const {
  addProduct,
  searchProduct,
  getAllProducts,
  getViewProduct,
  getProductsByStatus,
  getSalesProductByStatus,
  getOrdersProductByStatus,
} = require("../controllers/product.controller.js");

router.post(
  "/add",
  authMiddleware,
  uploadProduct.array("images", 5),
  addProduct
);

router.get("/search", searchProduct);

router.get("/get", getAllProducts);

router.get("/get/:productId", getViewProduct);

router.get(
  "/get/products/:sellerId/:status",
  authMiddleware,
  getProductsByStatus
);

router.get(
  "/get/sales/:status/:sellerId",
  authMiddleware,
  getSalesProductByStatus
);

router.get("/get/orders/:status", authMiddleware, getOrdersProductByStatus);

module.exports = router;
