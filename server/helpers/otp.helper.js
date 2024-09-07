const otpGenerator = require("otp-generator");
const crypto = require("crypto");
const { sendEmail } = require("./emailer.helper");
require("dotenv").config();

const key = process.env.OTP_KEY;

const sendOTP = async (params, cb) => {
  const otp = otpGenerator.generate(4, {
    digits: true,
    upperCaseAlphabets: false,
    specialChars: false,
    lowerCaseAlphabets: false,
  });

  const ttl = 5 * 60 * 1000; // 5 minutes expiration
  const expires = Date.now() + ttl;
  const data = `${params.shopEmail}.${otp}.${expires}`;
  const hash = crypto.createHmac("sha256", key).update(data).digest("hex");
  const fullHash = `${hash}.${expires}`;

  const otpMessage = `Dear User, your one time password is "${otp}" this will expire within 5 minutes`;
  const model = {
    email: params.shopEmail,
    subject: "Email authentication",
    body: otpMessage,
  };

  sendEmail(model, (error, result) => {
    if (error) {
      cb(error);
    }
    return cb(null, fullHash);
  });
};

const verifyOTP = async (params, cb) => {
  const [hashValue, expires] = params.hash.split(".");

  const now = Date.now();

  if (now > parseInt(expires)) return cb("OTP Expired");

  const data = `${params.shopEmail}.${params.otp}.${expires}`;
  const newCalculatedHash = crypto
    .createHmac("sha256", key)
    .update(data)
    .digest("hex");

  if (newCalculatedHash === hashValue) {
    return cb(null, "Success");
  }

  return cb("Invalid OTP");
};

module.exports = {
  sendOTP,
  verifyOTP,
};
