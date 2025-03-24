//backend1/tests/test-mongodb-access.js
require('dotenv').config({ path: './backend.env' });
const mongoose = require('mongoose');
const { Schema } = mongoose;

// Connect to MongoDB
const MONGO_URI = process.env.MONGODB_URI;
console.log('Connecting to MongoDB...');

// Create a test schema and model
const TestSchema = new Schema({
  name: String,
  createdAt: { type: Date, default: Date.now }
});

async function testDatabaseAccess() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('Connected to MongoDB successfully');
    
    // Create a temporary model for testing
    const TestModel = mongoose.model('TestAccess', TestSchema);
    
    // Test 1: Create - Insert a document
    console.log('\nTesting CREATE operation...');
    const testDoc = await TestModel.create({ name: 'Test Document' });
    console.log('CREATE successful:', testDoc);
    
    // Test 2: Read - Find the document
    console.log('\nTesting READ operation...');
    const foundDoc = await TestModel.findById(testDoc._id);
    console.log('READ successful:', foundDoc);
    
    // Test 3: Update - Modify the document
    console.log('\nTesting UPDATE operation...');
    const updatedDoc = await TestModel.findByIdAndUpdate(
      testDoc._id, 
      { name: 'Updated Test Document' },
      { new: true }
    );
    console.log('UPDATE successful:', updatedDoc);
    
    // Test 4: Delete - Remove the document
    console.log('\nTesting DELETE operation...');
    const deletedDoc = await TestModel.findByIdAndDelete(testDoc._id);
    console.log('DELETE successful:', deletedDoc);
    
    // Test 5: Drop the collection
    console.log('\nTesting DROP COLLECTION operation...');
    await mongoose.connection.collections['testaccesses'].drop();
    console.log('DROP COLLECTION successful');
    
    console.log('\nAll tests passed! MongoDB has full access permissions.');
  } catch (error) {
    console.error('Error during database access test:', error);
  } finally {
    // Close the connection
    await mongoose.connection.close();
    console.log('\nMongoDB connection closed');
  }
}

testDatabaseAccess(); 
