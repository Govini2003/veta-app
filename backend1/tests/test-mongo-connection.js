//backend1/tests/test-mongo-connection.js
require('dotenv').config({ path: './backend.env' });
const mongoose = require('mongoose');

const MONGO_URI = process.env.MONGODB_URI;
console.log('Attempting to connect to MongoDB with URI:', MONGO_URI);

mongoose.connect(MONGO_URI)
    .then(() => {
        console.log('Successfully connected to MongoDB');
        console.log('Connection details:', mongoose.connection);
        mongoose.connection.close();
    })
    .catch((err) => {
        console.error('Error connecting to MongoDB:', err);
    }); 
