const jwt = require("jsonwebtoken");
const User = require("../models/user.model");

const authMiddleware = async (req, res, next) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (authorizationHeader) {
      const token = authorizationHeader.split(" ")[1];

      const { _id } = jwt.verify(token, process.env.JWT_SECRET);
      req.user = await User.findOne({ _id }).select("_id");
      next();
    } else {
      res.status(401).json({ message: "Authorization token required" });
    }
  } catch (error) {
    res.status(401).json({ message: "Invalid authorization token" });
  }
};

module.exports = authMiddleware;
