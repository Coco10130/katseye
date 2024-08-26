const fs = require("fs");
const path = require("path");

const deleteFile = (filePath) => {
  fs.unlink(filePath, (err) => {
    if (err) {
      console.error(`Failed to delete file ${filePath}: ${err}`);
    }
  });
};

module.exports = { deleteFile };
