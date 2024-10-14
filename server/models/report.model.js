const mongoose = require("mongoose");

const ReportScheme = mongoose.Schema(
  {
    productName: {
      type: String,
      required: true,
    },

    productId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
      required: true,
    },

    reason: {
      type: String,
      required: true,
    },

    userName: {
      type: String,
      required: true,
    },

    type: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const Report = mongoose.model("Report", ReportScheme);

module.exports = Report;
