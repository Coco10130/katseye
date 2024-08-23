const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const cookieParser = require("cookie-parser");
require("dotenv").config();
const app = express();

// import routes
const authRouters = require("./routes/auth.route.js");

// middlewares
app.use(express.json());
app.use(cors());
app.use(cookieParser());

// default route
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// routes
app.use("/api/auth/", authRouters);

mongoose
  .connect(process.env.MONGODB)
  .then(() => {
    console.log("Connected to Database");
    app.listen(process.env.PORT, () => {
      console.log(`Server running on port ${process.env.PORT}`);
    });
  })
  .catch((error) => {
    console.log(`Error: ${error}`);
  });
