const Notification = require("../models/notification.model.js");
const jwt = require("jsonwebtoken");

const secretKey = process.env.JWT_SECRET;

const getAllNotificationsOfUser = async (req, res) => {
  try {
    const authorizationHeader = req.headers.authorization;
    const token = authorizationHeader.split(" ")[1];
    const decode = jwt.verify(token, secretKey);

    const notifications = await Notification.find({ userId: decode.id });

    const notification = notifications.map((notifs) => {
      const notificationIcon = `${req.protocol}://${req.get(
        "host"
      )}/images/notification/${notifs.icon}`;

      return {
        _id: notifs._id,
        icon: notificationIcon,
        message: notifs.message,
        createdAt: notifs.createdAt,
      };
    });

    res.status(200).json({ success: true, data: notification });
  } catch (error) {
    res.status(500).json({ errorMessage: error.message });
  }
};

module.exports = {
  getAllNotificationsOfUser,
};
