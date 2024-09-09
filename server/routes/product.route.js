const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const { uploadProduct } = require("../middlewares/multer.middleware.js");
const {
  addProduct,
  searchProduct,
  getAllProducts,
  getViewProduct,
} = require("../controllers/product.controller.js");

router.post(
  "/add",
  authMiddleware,
  uploadProduct.array("images", 5),
  addProduct
);

router.get("/search/:searchedProduct", searchProduct);

router.get("/get", getAllProducts);

router.get("/get/:productId", getViewProduct);

module.exports = router;
