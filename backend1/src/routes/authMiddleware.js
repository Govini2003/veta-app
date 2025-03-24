//backend1/src/routes/authMiddleware.js
const User = require('./User');
const admin = require('firebase-admin');

/**
 * Middleware to verify Firebase token and set user in request
 */
const verifyToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Unauthorized - No token provided' });
  }
  
  const token = authHeader.split(' ')[1];
  
  try {
    // Verify the Firebase token
    const decodedToken = await admin.auth().verifyIdToken(token);
    
    // Set the user ID in the request
    req.user = {
      id: decodedToken.uid,
      email: decodedToken.email,
      role: decodedToken.role || 'pet_owner' // Default role
    };
    
    next();
  } catch (error) {
    console.error('Token verification error:', error);
    return res.status(401).json({ message: 'Unauthorized - Invalid token' });
  }
};

/**
 * Middleware to check if user is authenticated
 */
const isAuthenticated = (req, res, next) => {
  if (!req.user || !req.user.id) {
    return res.status(401).json({ message: 'Unauthorized - Authentication required' });
  }
  next();
};

/**
 * Middleware to check if user is a veterinarian
 */
const isVeterinarian = async (req, res, next) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: 'Unauthorized - Authentication required' });
    }
    
    const user = await User.findOne({ firebaseUid: req.user.id });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    
    if (user.role !== 'vet') {
      return res.status(403).json({ message: 'Forbidden - Veterinarian access required' });
    }
    
    next();
  } catch (error) {
    console.error('Error in isVeterinarian middleware:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

/**
 * Middleware to check if user is an admin
 */
const isAdmin = async (req, res, next) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: 'Unauthorized - Authentication required' });
    }
    
    const user = await User.findOne({ firebaseUid: req.user.id });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    
    if (user.role !== 'admin') {
      return res.status(403).json({ message: 'Forbidden - Admin access required' });
    }
    
    next();
  } catch (error) {
    console.error('Error in isAdmin middleware:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = {
  verifyToken,
  isAuthenticated,
  isVeterinarian,
  isAdmin
}; 
