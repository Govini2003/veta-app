//veta-app/backend1/src/config/env.js
require('dotenv').config();

const env = {
    PORT: process.env.PORT || 3000,
    NODE_ENV: process.env.NODE_ENV || 'development',
    JWT_SECRET: process.env.JWT_SECRET,
    
    // MongoDB Configuration
    MONGODB: {
        URI: process.env.MONGODB_URI,
        DB_NAME: 'veta_lk_db',
        OPTIONS: {
            maxPoolSize: process.env.MONGODB_POOL_SIZE || 10,
            connectTimeoutMS: process.env.MONGODB_CONNECT_TIMEOUT || 10000,
            socketTimeoutMS: process.env.MONGODB_SOCKET_TIMEOUT || 45000,
            serverSelectionTimeoutMS: process.env.MONGODB_SERVER_TIMEOUT || 15000,
            retryWrites: true,
            ssl: process.env.NODE_ENV === 'production',
        }
    },

    // Firebase Configuration
    FIREBASE: {
        PROJECT_ID: process.env.FIREBASE_PROJECT_ID,
        CLIENT_EMAIL: process.env.FIREBASE_CLIENT_EMAIL,
        PRIVATE_KEY: process.env.FIREBASE_PRIVATE_KEY,
    }
};

module.exports = env;
