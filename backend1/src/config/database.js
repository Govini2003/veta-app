//backend1/src/config/database.js
const mongoose = require('mongoose');
const env = require('./env');

let connection = null;

const connectDB = async () => {
    try {
        if (connection) {
            console.log('Using existing database connection');
            return connection;
        }

        // Configure mongoose
        mongoose.set('strictQuery', true);
        
        // Connect with optimized settings
        connection = await mongoose.connect(env.MONGODB.URI, {
            dbName: env.MONGODB.DB_NAME,
            ...env.MONGODB.OPTIONS,
            autoIndex: env.NODE_ENV !== 'production', // Disable auto-indexing in production
        });

        // Connection event handlers
        mongoose.connection.on('connected', () => {
            console.log('MongoDB connected successfully');
        });

        mongoose.connection.on('error', (err) => {
            console.error('MongoDB connection error:', err);
            connection = null;
        });

        mongoose.connection.on('disconnected', () => {
            console.log('MongoDB disconnected');
            connection = null;
        });

        // Handle application termination
        process.on('SIGINT', async () => {
            try {
                await mongoose.connection.close();
                console.log('MongoDB connection closed through app termination');
                process.exit(0);
            } catch (err) {
                console.error('Error closing MongoDB connection:', err);
                process.exit(1);
            }
        });

        return connection;
    } catch (error) {
        console.error('Error connecting to MongoDB:', error);
        connection = null;
        throw error;
    }
};

// Export both the connection function and the mongoose instance
module.exports = {
    connectDB,
    mongoose
};
