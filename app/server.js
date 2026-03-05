// =============================================================================
// Intentionally Vulnerable Express Server — for Defender for DevOps Demo
// Contains code-level security issues that security scanners will detect
// =============================================================================

const express = require('express');
const app = express();

// ISSUE: Hardcoded credentials
const DB_CONNECTION = "Server=sql-server.database.windows.net;Database=mydb;User=admin;Password=P@ssw0rd123!";
const API_SECRET = "sk-demo-12345-insecure-key";

// ISSUE: No helmet middleware (missing security headers)
// ISSUE: No rate limiting
// ISSUE: No CORS configuration

app.use(express.json());

// ISSUE: Verbose error messages in production
app.use((err, req, res, next) => {
  res.status(500).json({
    error: err.message,
    stack: err.stack,  // ISSUE: Stack trace exposed
  });
});

// ISSUE: SQL injection vulnerability (for demo purposes only)
app.get('/api/users', (req, res) => {
  const userId = req.query.id;
  // NEVER do this in production — parameterize your queries!
  const query = `SELECT * FROM users WHERE id = '${userId}'`;
  res.json({ query: query, message: "Demo endpoint" });
});

// ISSUE: No input validation
app.post('/api/data', (req, res) => {
  const data = req.body;
  // Directly using user input without sanitization
  res.json({ received: data });
});

// ISSUE: Serving sensitive paths
app.get('/api/config', (req, res) => {
  res.json({
    dbConnection: DB_CONNECTION,
    apiSecret: API_SECRET,
    environment: process.env
  });
});

// ISSUE: No authentication on sensitive endpoint
app.delete('/api/users/:id', (req, res) => {
  res.json({ deleted: req.params.id });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
