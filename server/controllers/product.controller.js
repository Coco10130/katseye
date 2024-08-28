const Product = require("../models/product.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const addProduct = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const decode = jwt.verify(authorizationHeader, secretKey);

    const {
      productName,
      quantity,
      price,
      productDescription,
      categories,
      sizes,
    } = req.body;

    const productImages =
      req.files && req.files.length > 0
        ? req.files.map((file) => file.filename)
        : [];
    console.log("Product image:", productImages);

    const data = {
      productImage: productImages,
      productName,
      quantity,
      price,
      productDescription,
      categories,
      sizes,
      sellerId: decode.id,
    };

    await Product.create(data);

    res
      .status(201)
      .json({ success: true, message: "Product added successfully" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const searchProduct = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { searchedProduct } = req.params;

    const products = await Product.find({
      productName: { $regex: new RegExp(searchedProduct, "i") },
    });

    if (!products) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.status(200).json({ success: true, data: products });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addProduct,
  searchProduct,
};
