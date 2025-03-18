require('dotenv').config({ path: './backend.env' });
const { MongoClient } = require('mongodb');

async function testConnection() {
  // Get the connection string from environment variables
  const uri = process.env.MONGODB_URI;
  
  // Create a new MongoClient
  const client = new MongoClient(uri);
  
  try {
    // Connect to the MongoDB server
    console.log('Attempting to connect to MongoDB...');
    console.log('Connection URI:', uri);
    
    await client.connect();
    console.log('Successfully connected to MongoDB');
    
    // List databases to verify access
    const databasesList = await client.db().admin().listDatabases();
    console.log('Databases:');
    databasesList.databases.forEach(db => console.log(` - ${db.name}`));
    
  } catch (error) {
    console.error('Error connecting to MongoDB:', error);
  } finally {
    // Close the connection
    await client.close();
    console.log('MongoDB connection closed');
  }
}

testConnection(); 