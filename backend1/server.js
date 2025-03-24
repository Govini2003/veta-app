//backend1/server.js
const express = require('express');
const cors = require('cors');
const env = require('./src/config/env');
const { connectDB } = require('./src/config/database');
const admin = require('firebase-admin');
const { verifyToken } = require('./src/middleware/authMiddleware');

const app = express();

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert({
    projectId: env.FIREBASE.PROJECT_ID,
    clientEmail: env.FIREBASE.CLIENT_EMAIL,
    privateKey: env.FIREBASE.PRIVATE_KEY?.replace(/\\n/g, '\n')
  })
});

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectDB()
  .then(() => console.log('Database connection initialized'))
  .catch(err => {
    console.error('Failed to connect to database:', err);
    process.exit(1);
  });

// Auth middleware for protected routes
const userRoutes = require('./src/routes/users');
const petRoutes = require('./src/routes/pets');
const appointmentRoutes = require('./src/routes/appointments');
const reviewRoutes = require('./src/routes/reviews');

app.use('/api/users', verifyToken, userRoutes);
app.use('/api/pets', verifyToken, petRoutes);
app.use('/api/appointments', verifyToken, appointmentRoutes);
app.use('/api/reviews', verifyToken, reviewRoutes);

// Public routes
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        message: 'Server is running',
        environment: env.NODE_ENV
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        message: 'Something went wrong!',
        error: env.NODE_ENV === 'development' ? err.message : undefined
    });
});

const PORT = env.PORT;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
    console.log(`Environment: ${env.NODE_ENV}`);
});
