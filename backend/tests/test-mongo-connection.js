const mongoose = require('mongoose');

// Directly use the MongoDB URI from the .env file
const MONGO_URI = 'mongodb+srv://admin:Password@veta-app.nrll9.mongodb.net/PetCareDB';
console.log('Attempting to connect to MongoDB with URI:', MONGO_URI);

mongoose.connect(MONGO_URI, {
    serverSelectionTimeoutMS: 5000, // Timeout after 5 seconds instead of 30 seconds
    socketTimeoutMS: 45000,        // Close sockets after 45 seconds of inactivity
    family: 4,                    // Use IPv4, skip trying IPv6
    retryWrites: true,
    w: 'majority',
    useNewUrlParser: true,
    useUnifiedTopology: true,
    tls: true,                    // Enable TLS/SSL
    tlsAllowInvalidCertificates: true // For testing only, not recommended for production
})
    .then(() => {
        console.log('Successfully connected to MongoDB');
        console.log('Connection details:', mongoose.connection);
        console.log('Database name:', mongoose.connection.name);
        console.log('Host:', mongoose.connection.host);
        console.log('Port:', mongoose.connection.port);
        
        // Test the connection by listing collections
        mongoose.connection.db.listCollections().toArray((err, names) => {
            if (err) {
                console.error('Error listing collections:', err);
            } else {
                console.log('Available collections:', names.map(n => n.name));
            }
            mongoose.connection.close();
        });
    })
    .catch((err) => {
        console.error('Error connecting to MongoDB:', err);
        console.error('Error details:', {
            message: err.message,
            name: err.name,
            stack: err.stack,
            type: err.reason?.type,
            servers: Array.from(err.reason?.servers?.values() || []),
            code: err.code
        });
    });