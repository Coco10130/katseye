const Product = require("../model/product.model.js");
const User = require("../model/user.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const addProduct = async (req, res) => {
  try {
    const {token} = req.cookies;

    if (!token) {
      return res.status(401).json({ errorMessage: "Unauthorized" });
    }

    const decode = jwt.verify(token, secretKey);
    const user = await User.findById(decode.id);

  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};
