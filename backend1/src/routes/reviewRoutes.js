//backend1/src/routes/reviewRoutes.js
const express = require('express');
const router = express.Router();
const Review = require('../models/Review');
const User = require('../models/User');
const Appointment = require('../models/Appointment');

// Get all reviews for a specific veterinarian
router.get('/vet/:vetId', async (req, res) => {
  try {
    const reviews = await Review.find({ veterinarian: req.params.vetId })
      .populate('petOwner', 'displayName photoURL')
      .sort({ createdAt: -1 });
    
    res.json(reviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get all reviews by a pet owner
router.get('/pet-owner/:ownerId', async (req, res) => {
  try {
    const reviews = await Review.find({ petOwner: req.params.ownerId })
      .populate('veterinarian', 'displayName photoURL vetProfile.clinicName')
      .sort({ createdAt: -1 });
    
    res.json(reviews);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Create a new review
router.post('/', async (req, res) => {
  try {
    // Verify that the appointment exists and is completed
    if (req.body.appointment) {
      const appointment = await Appointment.findById(req.body.appointment);
      if (!appointment) {
        return res.status(404).json({ message: 'Appointment not found' });
      }
      
      if (appointment.status !== 'completed') {
        return res.status(400).json({ message: 'Cannot review an appointment that is not completed' });
      }
      
      // Verify that the pet owner is the one who had the appointment
      if (appointment.petOwner.toString() !== req.body.petOwner) {
        return res.status(403).json({ message: 'You can only review your own appointments' });
      }
      
      // Verify that the veterinarian is the one who conducted the appointment
      if (appointment.veterinarian.toString() !== req.body.veterinarian) {
        return res.status(400).json({ message: 'Veterinarian ID does not match the appointment' });
      }
    }
    
    // Check if a review already exists for this appointment
    if (req.body.appointment) {
      const existingReview = await Review.findOne({ appointment: req.body.appointment });
      if (existingReview) {
        return res.status(400).json({ message: 'A review already exists for this appointment' });
      }
    }
    
    const review = new Review({
      petOwner: req.body.petOwner,
      veterinarian: req.body.veterinarian,
      appointment: req.body.appointment,
      rating: req.body.rating,
      comment: req.body.comment
    });
    
    const newReview = await review.save();
    
    // Update the veterinarian's average rating
    const allReviews = await Review.find({ veterinarian: req.body.veterinarian });
    const totalRating = allReviews.reduce((sum, review) => sum + review.rating, 0);
    const averageRating = totalRating / allReviews.length;
    
    await User.findByIdAndUpdate(req.body.veterinarian, {
      'vetProfile.rating': averageRating.toFixed(1),
      'vetProfile.reviewCount': allReviews.length
    });
    
    res.status(201).json(newReview);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update a review
router.put('/:reviewId', async (req, res) => {
  try {
    const review = await Review.findById(req.params.reviewId);
    if (!review) {
      return res.status(404).json({ message: 'Review not found' });
    }
    
    // Verify that the pet owner is the one who created the review
    if (review.petOwner.toString() !== req.body.petOwner) {
      return res.status(403).json({ message: 'You can only update your own reviews' });
    }
    
    if (req.body.rating) review.rating = req.body.rating;
    if (req.body.comment) review.comment = req.body.comment;
    
    const updatedReview = await review.save();
    
    // Update the veterinarian's average rating
    const allReviews = await Review.find({ veterinarian: review.veterinarian });
    const totalRating = allReviews.reduce((sum, review) => sum + review.rating, 0);
    const averageRating = totalRating / allReviews.length;
    
    await User.findByIdAndUpdate(review.veterinarian, {
      'vetProfile.rating': averageRating.toFixed(1)
    });
    
    res.json(updatedReview);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete a review
router.delete('/:reviewId', async (req, res) => {
  try {
    const review = await Review.findById(req.params.reviewId);
    if (!review) {
      return res.status(404).json({ message: 'Review not found' });
    }
    
    // Verify that the pet owner is the one who created the review
    if (review.petOwner.toString() !== req.body.petOwner) {
      return res.status(403).json({ message: 'You can only delete your own reviews' });
    }
    
    await review.remove();
    
    // Update the veterinarian's average rating
    const allReviews = await Review.find({ veterinarian: review.veterinarian });
    
    if (allReviews.length > 0) {
      const totalRating = allReviews.reduce((sum, review) => sum + review.rating, 0);
      const averageRating = totalRating / allReviews.length;
      
      await User.findByIdAndUpdate(review.veterinarian, {
        'vetProfile.rating': averageRating.toFixed(1),
        'vetProfile.reviewCount': allReviews.length
      });
    } else {
      // No reviews left
      await User.findByIdAndUpdate(review.veterinarian, {
        'vetProfile.rating': 0,
        'vetProfile.reviewCount': 0
      });
    }
    
    res.json({ message: 'Review deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router; 
