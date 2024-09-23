const jwt = require("jsonwebtoken");
const Address = require("../models/address.model.js");

const secretKey = process.env.JWT_SECRET;

const getAddress = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const address = await Address.find({ userId: decode.id });

    res.status(200).json({ success: true, data: address });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

const addAddress = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const { fullName, municipality, contact, barangay, street } = req.body;
    let formattedContact = contact;

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
      fullName,
      contact: formattedContact,
      municipality,
      barangay,
      street,
      userId: decode.id,
    };

    await Address.create(data);
    res
      .status(201)
      .json({ success: true, message: "Address added successfully" });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  addAddress,
  getAddress,
};
