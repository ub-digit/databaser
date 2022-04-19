const express = require("express");
const router = express.Router();


// Gets All
router.get("/", (req, res) => {
  let message = {
    en: "testing error en",
    sv: "testing error sv"
  }
  console.log(message);
  res.json(message);
});

module.exports = router;
