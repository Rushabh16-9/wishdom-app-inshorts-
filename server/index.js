require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

// Connect to Database
connectDB();

const app = express();

// Middleware
app.use(cors());
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
    next();
});
app.use(express.json());
app.use(express.static('public')); // Serve static files

// Routes
app.use('/api/feed', require('./routes/feedRoutes'));

app.get('/', (req, res) => {
    res.send('Wisdom API is running');
});

// Admin Panel Route
app.get('/admin', (req, res) => {
    res.sendFile(__dirname + '/public/admin.html');
});

const PORT = process.env.PORT || 5000;

if (require.main === module) {
    app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
}

module.exports = app;
