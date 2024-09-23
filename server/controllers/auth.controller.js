const User = require("../models/user.model.js");
const jwt = require("jsonwebtoken");
const {
  hashPassword,
  comparePassword,
} = require("../helpers/authentication.helper.js");

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // check if user entered email
    if (!email) {
      return res.status(400).json({ errorMessage: "Email is required" });
    }

    // check if user entered password
    if (!password) {
      return res.status(400).json({ errorMessage: "Password is required" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ errorMessage: "User not found" });
    }

    // check if password match
    const match = await comparePassword(password, user.password);

    if (match) {
      jwt.sign(
        {
          email: user.email,
          id: user._id,
          userName: user.userName,
          cartItems: user.cartItems,
          role: user.role,
        },
        process.env.JWT_SECRET,
        { expiresIn: "7d" },
        (err, token) => {
          if (err) {
            throw err;
          }

          res.status(200).json({ token: token });
        }
      );
    } else {
      return res.status(401).json({ errorMessage: "Invalid credentials" });
    }
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const register = async (req, res) => {
  try {
    const { userName, email, password, confirmPassword } = req.body;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    // check if user entered all required fields

    // check email
    if (!userName || userName.length < 4) {
      return res
        .status(403)
        .json({ errorMessage: "Enter User name atleast 4 characters" });
    }

    // check email
    if (!email) {
      return res.status(403).json({ errorMessage: "Please enter Email" });
    } else if (!emailRegex.test(email)) {
      return res.status(403).json({ errorMessage: "Invalid Email format" });
    }

    // check password
    if (!password || password.length < 8) {
      return res.status(403).json({
        errorMessage: "Password should be at least 8 characters long",
      });
    }

    // check if password not match
    if (password !== confirmPassword) {
      return res.status(403).json({ errorMessage: "Passwords do not match" });
    }

    // check if email is already exist
    const user = await User.findOne({ email });
    if (user) {
      return res.status(409).json({ errorMessage: "Email already exists" });
    }

    // hash passwrod
    const hashedPassword = await hashPassword(password);

    const userData = {
      userName,
      email,
      password: hashedPassword,
    };

    await User.create(userData);
    res.status(201).json({ successMessage: "User Registered successfully" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = { login, register };
