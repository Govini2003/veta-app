require('dotenv').config({ path: './backend.env' });
const { MongoClient } = require('mongodb');

async function testDirectConnection() {
  const uri = process.env.MONGODB_URI;
  console.log('Testing connection with URI:', uri);
  
  const client = new MongoClient(uri, {
    connectTimeoutMS: 5000,
    socketTimeoutMS: 5000,
    serverSelectionTimeoutMS: 5000,
    // Force new connection for testing
    forceServerObjectId: true,
    monitorCommands: true
  });

  try {
    console.log('Attempting to connect...');
    await client.connect();
    console.log('Successfully connected to MongoDB');
    
    // Test basic operations
    const adminDb = client.db().admin();
    const result = await adminDb.ping();
    console.log('Ping result:', result);
    
  } catch (error) {
    console.error('Detailed connection error:');
    console.error('Error name:', error.name);
    console.error('Error message:', error.message);
    console.error('Error code:', error.code);
    console.error('Error stack:', error.stack);
    
    if (error.cause) {
      console.error('Underlying cause:', error.cause);
    }
  } finally {
    await client.close();
    console.log('Connection closed');
  }
}

testDirectConnection(); 