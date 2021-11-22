const express = require("express");
const router = express.Router();
const databases = require("../../Databases");

const idFilter = (req) => (database) => database.id === parseInt(req.params.id);

// Gets All Databases
router.get("/", (req, res) => {
  let filter = req.query.payload;
  console.log(filter)
  if (filter && filter.topics) {
    filter = [...filter.topics].map(Number); // to int
    const filteredDatabases = databases.data.filter((database) => {
      return database.topics.some((item) => filter.includes(item));
    });
    res.json(filteredDatabases);
  } else {
    res.json(databases);
  }
});

// Gets Popular Databases
router.get("/popular", (req, res) => {
  const popularDatabases = databases.data.filter((db) => db.is_popular);
  res.json(popularDatabases); // always return and handle .length on client
});

// Get Single Database
router.get("/:id", (req, res) => {
  const found = databases.data.some(idFilter(req));

  if (found) {
    res.json(databases.data.find(idFilter(req)));
  } else {
    res
      .status(400)
      .json({ message: `No database with the id of ${req.params.id}` });
  }
});

module.exports = router;
