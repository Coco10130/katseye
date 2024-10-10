const Product = require("../models/product.model.js");
const Seller = require("../models/seller.model.js");
const Order = require("../models/order.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const addProduct = async (req, res) => {
  try {
    // Check for authorization header
    const authorizationHeader = req.headers.authorization;
    if (!authorizationHeader) {
      return res
        .status(401)
        .json({ errorMessage: "No authorization token provided" });
    }

    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    // Find seller based on userId
    const seller = await Seller.findOne({ userId: decode.id });
    if (!seller) {
      return res.status(404).json({ errorMessage: "Seller not found" });
    }

    const {
      productName,
      price,
      productDescription,
      categories,
      sizes,
      quantities,
    } = req.body;

    // Validate required fields
    if (!productName || !price || !categories || !sizes || !quantities) {
      return res.status(400).json({ errorMessage: "All fields are required" });
    }

    const images =
      req.files && req.files.length > 0
        ? req.files.map((file) => file.filename)
        : [];

    // Assign quantity to each size
    const sizeQuantities = sizes.map((size, index) => ({
      size,
      quantity: quantities[index],
    }));

    const data = {
      productImage: images,
      productName,
      price,
      productDescription,
      categories,
      sizeQuantities,
      sellerName: seller.shopName,
      sellerId: seller.id,
    };

    // Create new product
    const newProduct = await Product.create(data);
    seller.products += 1;
    seller.live += 1;
    await seller.save();

    res.status(201).json({
      success: true,
      message: "Product added successfully",
      productId: newProduct._id, // Optionally return the created product ID
    });
  } catch (error) {
    console.error(error); // Log the error for debugging
    res.status(500).json({ errorMessage: error.message });
  }
};

const searchProduct = async (req, res) => {
  try {
    const { gender, category, ratings, priceRange, searchedProduct } =
      req.query;

    const filter = {
      productName: { $regex: new RegExp(searchedProduct, "i") },
      status: "live",
    };

    // add gender filter if provided
    if (gender) {
      filter.categories = { $regex: new RegExp(`^${gender}`, "i") };
    }

    // add categories filter if provided
    if (category) {
      filter.categories = { $in: category };
    }

    // add ratings filter if provided
    if (ratings) {
      const [number, string] = ratings.split(" ");
      const numericRating = parseFloat(number);
      if (!isNaN(numericRating)) {
        filter.rating = {
          $gte: numericRating,
          $lt: numericRating + 1,
        };
      }
    }

    // add price range filter if provided
    if (priceRange) {
      if (priceRange === "Above 500") {
        filter.price = { $gte: 500 };
      } else {
        const [min, max] = priceRange.split("-").map(Number);

        if (!isNaN(min) && !isNaN(max)) {
          filter.price = { $gte: min, $lte: max };
        }
      }
    }

    const products = await Product.find(filter);

    if (!products) {
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

const getProductsByStatus = async (req, res) => {
  try {
    const { sellerId, status } = req.params;

    const products = await Product.find({
      sellerId: sellerId,
      status: status,
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

const getSalesProductByStatus = async (req, res) => {
  try {
    const { sellerId, status } = req.params;

    const orders = await Order.find({ sellerId: sellerId, status: status });

    const updatedOrders = orders.map((order) => {
      const updatedProducts = order.products.map((product) => {
        const imageUrls = product.productImage.map(
          (image) =>
            `${req.protocol}://${req.get("host")}/images/products/${image}`
        );
        return { ...product.toObject(), productImage: imageUrls };
      });

      return { ...order.toObject(), products: updatedProducts };
    });

    return res.status(200).json({ success: true, data: updatedOrders });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getOrdersProductByStatus = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const userId = decode.id;
    const { status } = req.params;

    const orders = await Order.find({ userId: userId, status: status });

    const updatedOrders = orders.map((order) => {
      const updatedProducts = order.products.map((product) => {
        const imageUrls = product.productImage.map(
          (image) =>
            `${req.protocol}://${req.get("host")}/images/products/${image}`
        );
        return { ...product.toObject(), productImage: imageUrls };
      });

      return { ...order.toObject(), products: updatedProducts };
    });

    return res.status(200).json({ success: true, data: updatedOrders });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addProduct,
  searchProduct,
  getAllProducts,
  getViewProduct,
  getProductsByStatus,
  getSalesProductByStatus,
  getOrdersProductByStatus,
};
