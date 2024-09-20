const Product = require("../models/product.model.js");
const Seller = require("../models/seller.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const addProduct = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const seller = await Seller.findOne({ userId: decode.id });

    const {
      productName,
      quantity,
      price,
      productDescription,
      categories,
      sizes,
    } = req.body;

    const images =
      req.files && req.files.length > 0
        ? req.files.map((file) => file.filename)
        : [];

    const data = {
      productImage: images,
      productName,
      quantity,
      price,
      productDescription,
      categories,
      sizes,
      sellerName: seller.shopName,
      sellerId: seller.id,
    };

    await Product.create(data);
    seller.products += 1;
    await seller.save();

    res
      .status(201)
      .json({ success: true, message: "Product added successfully" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const searchProduct = async (req, res) => {
  try {
    const { searchedProduct } = req.params;

    const products = await Product.find({
      productName: { $regex: new RegExp(searchedProduct, "i") },
    });

    if (!products || products.length === 0) {
      return res.status(404).json({ message: "Product not found" });
    }

    const productsWithImageUrl = products.map((product) => {
      const imageUrls = product.productImage.map(
        (image) =>
          `${req.protocol}://${req.get("host")}/images/products/${image}`
      );

      return {
        ...product.toObject(),
        productImage: imageUrls,
      };
    });

    res.status(200).json({ success: true, data: productsWithImageUrl });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getAllProducts = async (req, res) => {
  try {
    const products = await Product.find({ status: "live" });

    const productsWithImageUrl = products.map((product) => {
      const imageUrls = product.productImage.map(
        (image) =>
          `${req.protocol}://${req.get("host")}/images/products/${image}`
      );

      return {
        ...product.toObject(),
        productImage: imageUrls,
      };
    });

    res.status(200).json({
      success: true,
      data: productsWithImageUrl,
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getViewProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    const imageUrls = product.productImage.map(
      (image) => `${req.protocol}://${req.get("host")}/images/products/${image}`
    );

    res.status(200).json({
      success: true,
      data: {
        ...product.toObject(),
        productImage: imageUrls,
      },
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getLiveProducts = async (req, res) => {
  try {
    const { sellerId } = req.params;

    const products = await Product.find({
      sellerId: sellerId,
      status: "live",
    });

    const updatedProducts = products.map((product) => {
      const imageUrls = product.productImage.map(
        (image) =>
          `${req.protocol}://${req.get("host")}/images/products/${image}`
      );
      return { ...product.toObject(), productImage: imageUrls };
    });

    res.status(200).json({
      success: true,
      data: updatedProducts,
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addProduct,
  searchProduct,
  getAllProducts,
  getViewProduct,
  getLiveProducts,
};
