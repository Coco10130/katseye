const User = require("../models/user.model.js");
const Seller = require("../models/seller.model.js");
const jwt = require("jsonwebtoken");
const { sendOTP, verifyOTP } = require("../helpers/otp.helper.js");

const secretKey = process.env.JWT_SECRET;

const sendOtp = (req, res, next) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    sendOTP(req.body, (error, results) => {
      if (error) {
        return res.status(500).json({ errorMessage: error.message });
      }
      return res.status(200).json({ message: "OTP emailed", data: results });
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const registerSeller = (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { shopName, shopContact, shopEmail } = req.body;

    verifyOTP(req.body, async (error, results) => {
      if (error) {
        return res.status(400).json({ errorMessage: error });
      }

      const token = authorizationHeader.split(" ")[1];
      const decode = jwt.verify(token, secretKey);
      let user = await User.findById(decode.id);

      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      let formattedContact = shopContact;

      // Validate contact number
      formattedContact = formattedContact.replace(/[^0-9]/g, "");
      if (
        formattedContact.length !== 11 ||
        !formattedContact.startsWith("09")
      ) {
        return res.status(400).json({ message: "Invalid contact number" });
      }

      const data = {
        shopName,
        shopContact: formattedContact,
        shopEmail,
        image: user.image,
        userId: user.id,
      };

      // Update seller profile
      await Seller.create(data);

      user = await User.findByIdAndUpdate(
        decode.id,
        { role: "seller" },
        { new: true }
      );

      if (!user) {
        return res.status(500).json({ message: "Failed to update user role" });
      }

      const newToken = jwt.sign(
        {
          email: user.email,
          id: user._id,
          userName: user.userName,
          role: user.role,
        },
        secretKey,
        { expiresIn: "2h" }
      );

      res.status(200).json({
        success: true,
        message: "Seller profile updated successfully",
        token: newToken,
      });
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const getSellerProfile = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);
    const seller = await Seller.findOne({ userId: decode.id });

    const imageUrl = seller.image
      ? `${req.protocol}://${req.get("host")}/images/sellers/${seller.image}`
      : `${req.protocol}://${req.get(
          "host"
        )}/images/profiles/default-image.jpg`;

    if (!seller) {
      return res.status(404).json({ message: "Seller profile not found" });
    }

    res.status(200).json({
      success: true,
      data: {
        ...seller.toObject(),
        image: imageUrl,
      },
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  sendOtp,
  registerSeller,
  getSellerProfile,
};
