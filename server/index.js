const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const path = require("path");
require("dotenv").config();
const app = express();

// import routes
const authRouters = require("./routes/auth.route.js");
const profileRouters = require("./routes/profile.route.js");
const productRouters = require("./routes/product.route.js");
const cartRouters = require("./routes/cart.route.js");

// middlewares
app.use(express.json());
app.use(
  cors({
    credentials: true,
    allowedHeaders: "Authorization, Content-Type",
  })
);
app.use(cookieParser());
app.use("/images", express.static(path.join(__dirname, "images")));

// default route
app.get("/", (req, res) => {
  res.send("Hello World!");
});

// routes
app.use("/api/auth/", authRouters);
app.use("/api/profile/", profileRouters);
app.use("/api/product/", productRouters);
app.use("/api/cart/", cartRouters);

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
