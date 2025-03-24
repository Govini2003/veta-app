//backend1/src/models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  firebaseUid: {
    type: String,
    required: true,
    unique: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  displayName: {
    type: String,
    required: true,
    trim: true
  },
  photoURL: {
    type: String,
    default: ''
  },
  phoneNumber: {
    type: String,
    trim: true
  },
  role: {
    type: String,
    enum: ['pet_owner', 'vet', 'admin'],
    default: 'pet_owner'
  },
  // Pet Owner specific fields
  address: {
    type: String,
    trim: true
  },
  location: {
    type: String,
    trim: true
  },
  bio: {
    type: String,
    trim: true
  },
  // Vet specific fields
  vetProfile: {
    licenseNumber: {
      type: String,
      trim: true
    },
    nic: {
      type: String,
      trim: true
    },
    slvcNumber: {
      type: String,
      trim: true
    },
    clinicName: {
      type: String,
      trim: true
    },
    clinicAddress: {
      type: String,
      trim: true
    },
    university: {
      type: String,
      trim: true
    },
    practiceInfo: {
      type: String,
      trim: true
    },
    specialization: {
      type: String,
      trim: true
    },
    qualifications: [String],
    workingHours: {
      monday: { start: String, end: String },
      tuesday: { start: String, end: String },
      wednesday: { start: String, end: String },
      thursday: { start: String, end: String },
      friday: { start: String, end: String },
      saturday: { start: String, end: String },
      sunday: { start: String, end: String }
    },
    services: [{
      name: String,
      fee: Number,
      description: String
    }],
    paymentMethods: [String],
    rating: {
      type: Number,
      min: 0,
      max: 5,
      default: 0
    },
    reviewCount: {
      type: Number,
      default: 0
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  lastLogin: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('User', userSchema); 
