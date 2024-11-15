const Report = require("../models/report.model.js");
const Product = require("../models/product.model.js");
const Seller = require("../models/seller.model.js");
const User = require("../models/user.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const createReport = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decoded = jwt.verify(token, secretKey);
    const userId = decoded.id;

    const { productId, reason, type } = req.body;

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const productExists = await Product.findById(productId);

    if (!productExists) {
      return res.status(404).json({ message: "Product not found" });
    }

    const seller = await Seller.findOne({
      userId: userId,
      _id: productExists.sellerId,
    });

    if (seller) {
      return res
        .status(400)
        .json({ message: "Seller can't report their own product." });
    }

    const newReport = new Report({
      productName: productExists.productName,
      productId,
      reason,
      userName: user.userName,
      type,
    });

    await newReport.save();
    res
      .status(201)
      .json({ message: "Report created successfully", success: true });
  } catch (error) {
    console.error(error);
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  createReport,
};
