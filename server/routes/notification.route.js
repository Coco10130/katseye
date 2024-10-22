const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const {
  getAllNotificationsOfUser,
} = require("../controllers/notification.controller.js");

router.use(authMiddleware);

router.get("/get", getAllNotificationsOfUser);

module.exports = router;
