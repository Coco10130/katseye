const User = require("../models/user.model.js");
const jwt = require("jsonwebtoken");
const path = require("path");
const { deleteFile } = require("../helpers/deleteFile.helper");
const { sendOTP, verifyOTP } = require("../helpers/otp.helper.js");

const secretKey = process.env.JWT_SECRET;

const getProfile = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const token = authorizationHeader.split(" ")[1];
    const user = jwt.verify(token, secretKey);

    const userProfile = await User.findOne({ _id: user.id }).select(
      "-password"
    );

    if (!userProfile) {
      return res.status(404).json({ message: "User not found" });
    }

    const imageUrl = userProfile.image
      ? `${req.protocol}://${req.get("host")}/images/${userProfile.image}`
      : `${req.protocol}://${req.get("host")}/images/default-image.jpg`;

    res.status(200).json({
      success: true,
      data: {
        ...userProfile.toObject(),
        image: imageUrl,
      },
    });
  } catch (error) {
    console.error("Error in getProfile:", error.message);
    res.status(500).json({ errorMessage: error.message });
  }
};

const updateProfile = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;

    if (!authorizationHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const { userName, phoneNumber, email, birthdate } = req.body;
    const image = req.file ? req.file.filename : null;
    const { id } = req.params;
    let formattedBirthdate;

    if (birthdate) {
      const dateObject = new Date(birthdate);
      const monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      formattedBirthdate = `${
        monthNames[dateObject.getMonth()]
      } ${dateObject.getDate()}, ${dateObject.getFullYear()}`;
    }

    let formattedContact = phoneNumber;

    if (formattedContact) {
      formattedContact = formattedContact.replace(/[^0-9]/g, "");
      if (
        formattedContact.length !== 11 ||
        !formattedContact.startsWith("09")
      ) {
        return res.status(400).json({ message: "Invalid contact number" });
      }
    }

    const data = {
      userName,
      phoneNumber: formattedContact,
      email,
      birthdate: formattedBirthdate,
    };

    if (image) {
      const user = await User.findById(id);

      if (user && user.image) {
        const oldImagePath = path.join(__dirname, `../images/${user.image}`);
        deleteFile(oldImagePath);
      }

      data.image = image;
    }

    const user = await User.findByIdAndUpdate(id, data, { new: true });
    res.status(200).json({
      success: true,
      message: "Profile updated successfully",
      data: user,
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

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
        role: "seller",
      };

      // Update user profile
      const user = await User.findByIdAndUpdate(decode.id, data, { new: true });

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
        data: user,
      });
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  getProfile,
  updateProfile,
  registerSeller,
  sendOtp,
};
