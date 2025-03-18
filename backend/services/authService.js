const User = require('../models/User');

/**
 * Find or create a user based on their email
 * This is useful for authentication with third-party providers
 * @param {Object} userData - User data from authentication provider
 * @returns {Object} - User object
 */
const findOrCreateUser = async (userData) => {
  try {
    // Check if user exists
    let user = await User.findOne({ email: userData.email });
    
    if (user) {
      // Update last login time
      user.lastLogin = new Date();
      await user.save();
      return user;
    }
    
    // Create new user if not exists
    const newUserData = {
      email: userData.email,
      displayName: userData.displayName || userData.email.split('@')[0],
      photoURL: userData.photoURL || '',
      phoneNumber: userData.phoneNumber || '',
      role: userData.role || 'pet_owner'
    };
    
    // Add role-specific data
    if (userData.role === 'pet_owner') {
      newUserData.address = userData.address || '';
      newUserData.location = userData.location || '';
      newUserData.bio = userData.bio || '';
    }
    
    if (userData.role === 'vet') {
      newUserData.vetProfile = {
        licenseNumber: userData.licenseNumber || '',
        nic: userData.nic || '',
        slvcNumber: userData.slvcNumber || '',
        clinicName: userData.clinicName || '',
        clinicAddress: userData.clinicAddress || '',
        university: userData.university || '',
        practiceInfo: userData.practiceInfo || '',
        specialization: userData.specialization || '',
        qualifications: userData.qualifications || [],
        services: userData.services || [],
        paymentMethods: userData.paymentMethods || []
      };
    }
    
    const newUser = new User(newUserData);
    await newUser.save();
    return newUser;
  } catch (error) {
    throw new Error(`Error in findOrCreateUser: ${error.message}`);
  }
};

/**
 * Register a new pet owner
 * @param {Object} userData - Pet owner data
 * @returns {Object} - User object
 */
const registerPetOwner = async (userData) => {
  try {
    // Check if user already exists
    const existingUser = await User.findOne({ email: userData.email });
    if (existingUser) {
      throw new Error('User with this email already exists');
    }
    
    const petOwnerData = {
      email: userData.email,
      displayName: userData.displayName,
      photoURL: userData.photoURL || '',
      phoneNumber: userData.phoneNumber || '',
      role: 'pet_owner',
      address: userData.address || '',
      location: userData.location || '',
      bio: userData.bio || ''
    };
    
    const newUser = new User(petOwnerData);
    await newUser.save();
    return newUser;
  } catch (error) {
    throw new Error(`Error in registerPetOwner: ${error.message}`);
  }
};

/**
 * Register a new veterinarian
 * @param {Object} userData - Veterinarian data
 * @returns {Object} - User object
 */
const registerVeterinarian = async (userData) => {
  try {
    // Check if user already exists
    const existingUser = await User.findOne({ email: userData.email });
    if (existingUser) {
      throw new Error('User with this email already exists');
    }
    
    const vetData = {
      email: userData.email,
      displayName: userData.displayName,
      photoURL: userData.photoURL || '',
      phoneNumber: userData.phoneNumber || '',
      role: 'vet',
      vetProfile: {
        licenseNumber: userData.licenseNumber || '',
        nic: userData.nic || '',
        slvcNumber: userData.slvcNumber || '',
        clinicName: userData.clinicName || '',
        clinicAddress: userData.clinicAddress || '',
        university: userData.university || '',
        practiceInfo: userData.practiceInfo || '',
        specialization: userData.specialization || '',
        qualifications: userData.qualifications || [],
        services: userData.services || [],
        paymentMethods: userData.paymentMethods || []
      }
    };
    
    const newUser = new User(vetData);
    await newUser.save();
    return newUser;
  } catch (error) {
    throw new Error(`Error in registerVeterinarian: ${error.message}`);
  }
};

/**
 * Get user profile by ID
 * @param {string} userId - User ID
 * @returns {Object} - User object
 */
const getUserProfile = async (userId) => {
  try {
    const user = await User.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }
    return user;
  } catch (error) {
    throw new Error(`Error in getUserProfile: ${error.message}`);
  }
};

/**
 * Check if user is a veterinarian
 * @param {string} userId - User ID
 * @returns {boolean} - True if user is a vet
 */
const isVeterinarian = async (userId) => {
  try {
    const user = await User.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }
    return user.role === 'vet';
  } catch (error) {
    throw new Error(`Error in isVeterinarian: ${error.message}`);
  }
};

/**
 * Check if user is a pet owner
 * @param {string} userId - User ID
 * @returns {boolean} - True if user is a pet owner
 */
const isPetOwner = async (userId) => {
  try {
    const user = await User.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }
    return user.role === 'pet_owner';
  } catch (error) {
    throw new Error(`Error in isPetOwner: ${error.message}`);
  }
};

module.exports = {
  findOrCreateUser,
  registerPetOwner,
  registerVeterinarian,
  getUserProfile,
  isVeterinarian,
  isPetOwner
}; 