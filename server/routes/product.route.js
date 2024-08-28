const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const uploadMiddleware = require("../middlewares/multer.middleware.js");
const {
  addProduct,
  searchProduct,
} = require("../controllers/product.controller.js");

router.use(authMiddleware);

router.post("/add", uploadMiddleware.array("images", 5), addProduct);

router.get("/search/:searchedProduct", searchProduct);

module.exports = router;
