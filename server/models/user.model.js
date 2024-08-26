const mongoose = require("mongoose");

const UserSchema = mongoose.Schema(
  {
    userName: {
      type: String,
      required: true,
    },

    email: {
      type: String,
      required: false,
    },

    password: {
      type: String,
      required: true,
    },

    birthdate: {
      type: Date,
      required: false,
    },

    isSeller: {
      type: Boolean,
      required: false,
      default: false,
    },

    role: {
      type: String,
      required: false,
      default: "user",
    },

    phoneNumber: {
      type: String,
      required: false,
    },

    address: {
      type: String,
      required: false,
    },

    shopName: {
      type: String,
      required: false,
    },

    shopEmail: {
      type: String,
      required: false,
    },

    shopContact: {
      type: String,
      required: false,
    },

    cartItems: {
      type: Number,
      reqruire: false,
      default: 0,
    },

    image: {
      type: String,
      required: false,
    },
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model("user", UserSchema);

module.exports = User;
