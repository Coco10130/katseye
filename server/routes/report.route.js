const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/auth.middleware.js");
const { createReport } = require("../controllers/report.controller.js");

router.use(authMiddleware);

router.post("/create", createReport);

module.exports = router;
