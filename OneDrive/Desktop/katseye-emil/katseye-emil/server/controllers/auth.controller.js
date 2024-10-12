const User = require("../models/user.model.js");
const jwt = require("jsonwebtoken");
const signToken = require("../helpers/sign.new.token.helper.js");
const { sendOTP, verifyOTP } = require("../helpers/otp.helper.js");
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
      const token = signToken(user);
      return res.status(200).json({ token: token });
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

const sendOtp = async (req, res, next) => {
  try {
    const { shopEmail } = req.body;

    if (!shopEmail) {
      return res.status(400).json({ message: "Email is required" });
    }

    const user = await User.findOne({ email: shopEmail });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    sendOTP(req.body, (error, results) => {
      if (error) {
        return res.status(500).json({ message: error.message });
      }
      return res.status(200).json({ message: "OTP emailed", data: results });
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const verifyOtp = async (req, res) => {
  try {
    const { otp, hash, shopEmail } = req.body;

    if (!otp || !hash || !shopEmail) {
      return res
        .status(400)
        .json({ message: "Otp, Otp hash, and Email are required." });
    }

    const user = await User.find({ email: shopEmail });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    verifyOTP(req.body, (error) => {
      if (error) {
        return res.status(400).json({ message: error.message });
      }

      res
        .status(200)
        .json({ message: "OTP verified successfully", success: true });
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const changePassword = async (req, res) => {
  try {
    const { email, newPassword, confirmPassword, otpVerified } = req.body;

    // Validation checks
    if (!email || !newPassword || !confirmPassword) {
      return res.status(400).json({
        message: "Email, Password, and confirm password are required",
      });
    }

    if (newPassword !== confirmPassword) {
      return res.status(400).json({ message: "Passwords do not match" });
    }

    // Find the user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if OTP is verified
    if (!otpVerified) {
      return res.status(403).json({ message: "OTP verification required" });
    }

    // Hash the new password
    const hashedPassword = await hashPassword(newPassword);

    // Update user password
    user.password = hashedPassword;
    await user.save();

    // Send success response
    res
      .status(200)
      .json({ message: "Password changed successfully", success: true });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = { login, register, sendOtp, verifyOtp, changePassword };
