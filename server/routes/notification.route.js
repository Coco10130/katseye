const pushNotificationController = require("../controllers/notification.controller");

const express = require("express");
const router = express.Router();

router.get("/SendNotification", pushNotificationController.SendNotification);
router.post("/SendNotificationToDevice", pushNotificationController.SendNotificationToDevice);



module.exports = router;