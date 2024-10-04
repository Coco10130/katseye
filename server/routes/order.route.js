const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");

const { processOrder } = require("../controllers/order.controller.js");

router.use(authMiddleware);

router.get("/process", processOrder);

module.exports = router;
