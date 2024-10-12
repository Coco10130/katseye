const jwt = require("jsonwebtoken");

const signToken = (user) => {
  return jwt.sign(
    {
      email: user.email,
      id: user._id,
      userName: user.userName,
      cartItems: user.cartItems,
      role: user.role,
    },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );
};

module.exports = signToken;
