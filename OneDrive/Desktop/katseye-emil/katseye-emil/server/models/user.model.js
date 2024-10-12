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

const User = mongoose.model("User", UserSchema);

module.exports = User;
