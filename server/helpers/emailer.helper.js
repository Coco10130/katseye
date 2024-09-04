const nodemailer = require("nodemailer");
require("dotenv").config();

const sendEmail = async (params, cb) => {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  const mailOptions = {
    from: "E-Ukay",
    to: params.email,
    subject: params.subject,
    text: params.body,
  };

  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      return cb(error);
    } else {
      return cb(null, info.response);
    }
  });
};

module.exports = { sendEmail };
