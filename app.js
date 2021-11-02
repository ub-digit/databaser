const express = require("express");
const path = require("path");
const cors = require("cors");
const logger = require("./middleware/logger");
const databases = require("./Databases");
const topics = require("./Topics");
const { response } = require("express");

const app = express();

// Init middleware
// app.use(logger);

// Body Parser Middleware
app.use(express.json());
app.use(cors());

// Databases API Routes
app.use("/api/databases", require("./routes/api/databases"));

app.use("/api/topics", require("./routes/api/topics"));

app.use("/api/mediatypes", require("./routes/api/mediatypes"));

// Homepage Route
app.get("/", (req, res) => {
  res.send("Database API");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
