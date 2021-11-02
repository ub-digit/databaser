const express = require("express");
const router = express.Router();
const topics = require("../../Topics");

// Gets All Topics
router.get("/", (req, res) => res.json(topics));

module.exports = router;
