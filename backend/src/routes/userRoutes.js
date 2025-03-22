const express = require('express');
const router = express.Router();
const User = require('../models/User');

// Get user profile
router.get('/profile/:userId', async (req, res) => {
  try {
    const user = await User.findById(req.params.userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update user profile
router.put('/profile/:userId', async (req, res) => {
  try {
    const updateData = {};
    
    // Common fields
    if (req.body.displayName) updateData.displayName = req.body.displayName;
    if (req.body.phoneNumber) updateData.phoneNumber = req.body.phoneNumber;
    if (req.body.photoURL) updateData.photoURL = req.body.photoURL;
    if (req.body.email) updateData.email = req.body.email;
    
    // Role-specific fields
    const user = await User.findById(req.params.userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    
    if (user.role === 'pet_owner') {
      // Pet owner specific fields
      if (req.body.address) updateData.address = req.body.address;
      if (req.body.location) updateData.location = req.body.location;
      if (req.body.bio) updateData.bio = req.body.bio;
    }
    
    if (user.role === 'vet' && req.body.vetProfile) {
      // Update only the provided vet profile fields
      updateData.vetProfile = user.vetProfile || {};
      
      const vetFields = [
        'licenseNumber', 'nic', 'slvcNumber', 'specialization', 'qualifications', 
        'clinicName', 'clinicAddress', 'university', 'practiceInfo',
        'workingHours', 'services', 'paymentMethods'
      ];
      
      vetFields.forEach(field => {
        if (req.body.vetProfile[field]) {
          updateData.vetProfile[field] = req.body.vetProfile[field];
        }
      });
    }
    
    const updatedUser = await User.findByIdAndUpdate(
      req.params.userId,
      { $set: updateData },
      { new: true }
    );
    
    res.json(updatedUser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Create new user
router.post('/register', async (req, res) => {
  try {
    const userData = {
      email: req.body.email,
      displayName: req.body.displayName,
      photoURL: req.body.photoURL || '',
      phoneNumber: req.body.phoneNumber || '',
      role: req.body.role || 'pet_owner'
    };
    
    // Add role-specific data
    if (req.body.role === 'pet_owner') {
      userData.address = req.body.address || '';
      userData.location = req.body.location || '';
      userData.bio = req.body.bio || '';
    }
    
    if (req.body.role === 'vet') {
      userData.vetProfile = {
        licenseNumber: req.body.licenseNumber || '',
        nic: req.body.nic || '',
        slvcNumber: req.body.slvcNumber || '',
        clinicName: req.body.clinicName || '',
        clinicAddress: req.body.clinicAddress || '',
        university: req.body.university || '',
        practiceInfo: req.body.practiceInfo || '',
        specialization: req.body.specialization || '',
        qualifications: req.body.qualifications || [],
        services: req.body.services || [],
        paymentMethods: req.body.paymentMethods || []
      };
    }
    
    const user = new User(userData);
    const newUser = await user.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Alternative registration endpoint for veterinarians with flattened structure
router.post('/register/vet', async (req, res) => {
  try {
    const userData = {
      email: req.body.email,
      displayName: req.body.displayName,
      photoURL: req.body.photoURL || '',
      phoneNumber: req.body.phoneNumber || '',
      role: 'vet',
      vetProfile: {
        licenseNumber: req.body.licenseNumber || '',
        nic: req.body.nic || '',
        slvcNumber: req.body.slvcNumber || '',
        clinicName: req.body.clinicName || '',
        clinicAddress: req.body.clinicAddress || '',
        university: req.body.university || '',
        practiceInfo: req.body.practiceInfo || '',
        specialization: req.body.specialization || '',
        qualifications: req.body.qualifications || [],
        services: req.body.services || [],
        paymentMethods: req.body.paymentMethods || []
      }
    };
    
    const user = new User(userData);
    const newUser = await user.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Alternative registration endpoint for pet owners with flattened structure
router.post('/register/pet-owner', async (req, res) => {
  try {
    const userData = {
      email: req.body.email,
      displayName: req.body.displayName,
      photoURL: req.body.photoURL || '',
      phoneNumber: req.body.phoneNumber || '',
      role: 'pet_owner',
      address: req.body.address || '',
      location: req.body.location || '',
      bio: req.body.bio || ''
    };
    
    const user = new User(userData);
    const newUser = await user.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Get all veterinarians
router.get('/vets', async (req, res) => {
  try {
    const vets = await User.find({ role: 'vet' });
    res.json(vets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get veterinarians by specialization
router.get('/vets/specialization/:specialization', async (req, res) => {
  try {
    const vets = await User.find({ 
      role: 'vet', 
      'vetProfile.specialization': req.params.specialization 
    });
    res.json(vets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get top-rated veterinarians
router.get('/vets/top-rated', async (req, res) => {
  try {
    const vets = await User.find({ role: 'vet' })
      .sort({ 'vetProfile.rating': -1 })
      .limit(10);
    res.json(vets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Sync Firebase user with backend
router.post('/sync', async (req, res) => {
  try {
    // Check if user exists in our database
    let user = await User.findOne({ firebaseUid: req.user.id });
    
    if (user) {
      // Update existing user
      user.email = req.user.email || user.email;
      user.displayName = req.body.displayName || user.displayName;
      user.photoURL = req.body.photoURL || user.photoURL;
      user.phoneNumber = req.body.phoneNumber || user.phoneNumber;
      user.lastLogin = new Date();
      
      await user.save();
      return res.json(user);
    }
    
    // Create new user if not exists
    const newUser = new User({
      firebaseUid: req.user.id,
      email: req.user.email,
      displayName: req.body.displayName || req.user.email.split('@')[0],
      photoURL: req.body.photoURL || '',
      phoneNumber: req.body.phoneNumber || '',
      role: req.body.role || 'pet_owner',
      lastLogin: new Date()
    });
    
    await newUser.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

module.exports = router; 