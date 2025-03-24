//backend1/src/models/Appointment.js
const mongoose = require('mongoose');

const petSchema = new mongoose.Schema({
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  species: {
    type: String,
    required: true,
    trim: true
  },
  breed: {
    type: String,
    trim: true
  },
  dateOfBirth: {
    type: Date
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'unknown'],
    default: 'unknown'
  },
  weight: {
    type: Number
  },
  photoURL: {
    type: String,
    default: ''
  },
  medicalHistory: [{
    date: Date,
    condition: String,
    treatment: String,
    vet: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }
  }],
  vaccinations: [{
    vaccineType: {
      type: String,
      required: true,
      trim: true
    },
    vaccinationDate: {
      type: Date,
      required: true
    },
    renewalDate: {
      type: Date
    },
    vet: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    veterinarianName: {
      type: String,
      trim: true
    },
    veterinarianRegNumber: {
      type: String,
      trim: true
    },
    vaccineLabel: {
      type: String,
      trim: true
    },
    notes: {
      type: String,
      trim: true
    }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Pet', petSchema); 
