const User = require("../models/user.model.js");
const jwt = require("jsonwebtoken");
const path = require("path");
const { deleteFile } = require("../helpers/deleteFile.helper");

const secretKey = process.env.JWT_SECRET;

const getProfile = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const userProfile = await User.findOne({ _id: decode.id }).select(
      "-password"
    );

    if (!userProfile) {
      return res.status(404).json({ message: "User not found" });
    }

    const imageUrl = userProfile.image
      ? `${req.protocol}://${req.get("host")}/images/profiles/${
          userProfile.image
        }`
      : `${req.protocol}://${req.get(
          "host"
        )}/images/profiles/default-image.jpg`;

    res.status(200).json({
      success: true,
      data: {
        ...userProfile.toObject(),
        image: imageUrl,
      },
    });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const updateProfile = async (req, res) => {
  try {
    const { userName, phoneNumber, email } = req.body;
    const image = req.file ? req.file.filename : null;
    const { id } = req.params;

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
    };

    if (image) {
      const user = await User.findById(id);

      if (user && user.image) {
        const oldImagePath = path.join(
          __dirname,
          `../images/profiles/${user.image}`
        );
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

module.exports = {
  getProfile,
  updateProfile,
};
