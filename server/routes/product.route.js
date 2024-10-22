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
  updateProduct,
  getSalesProductByStatus,
  deleteProduct,
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

router.get("/get/sales/:sellerId", authMiddleware, getSalesProductByStatus);

router.put("/update/:productId", authMiddleware, updateProduct);

router.delete("/delete/:productId/:sellerId", authMiddleware, deleteProduct);

module.exports = router;
