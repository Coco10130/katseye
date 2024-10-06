const nodemailer = require("nodemailer");
require("dotenv").config();

const sendEmail = async (params, cb) => {
  try{
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  const mailOptions = {
    from: "Pocket Picks",
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
} catch(error) {
  res.status(500).json({errorMessage: error.mesage })
}
};

module.exports = { sendEmail };
