const mongoose = require("mongoose");

const AddressSchema = mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
    },

    contact: {
      type: String,
      required: true,
    },

    province: {
      type: String,
      required: false,
      default: "Pangasinan",
    },

    municipality: {
      type: String,
      required: true,
    },

    barangay: {
      type: String,
      required: true,
    },

    street: {
      type: String,
      required: true,
    },

    inUse: {
      type: Boolean,
      default: false,
    },

    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);
const Address = mongoose.model("Address", AddressSchema);

module.exports = Address;
