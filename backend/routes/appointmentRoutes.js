const express = require('express');
const router = express.Router();
const Appointment = require('../models/Appointment');
const User = require('../models/User');
const Pet = require('../models/Pet');

// Get all appointments for a pet owner
router.get('/pet-owner/:userId', async (req, res) => {
  try {
    const appointments = await Appointment.find({ petOwner: req.params.userId })
      .populate('pet', 'name species breed')
      .populate('veterinarian', 'displayName photoURL vetProfile.clinicName')
      .sort({ date: 1 });
    
    res.json(appointments);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get all appointments for a veterinarian
router.get('/vet/:userId', async (req, res) => {
  try {
    const appointments = await Appointment.find({ veterinarian: req.params.userId })
      .populate('pet', 'name species breed')
      .populate('petOwner', 'displayName photoURL phoneNumber')
      .sort({ date: 1 });
    
    res.json(appointments);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get appointments for a specific pet
router.get('/pet/:petId', async (req, res) => {
  try {
    const appointments = await Appointment.find({ pet: req.params.petId })
      .populate('veterinarian', 'displayName photoURL vetProfile.clinicName')
      .sort({ date: -1 });
    
    res.json(appointments);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get a specific appointment
router.get('/:appointmentId', async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.appointmentId)
      .populate('pet', 'name species breed photoURL')
      .populate('petOwner', 'displayName photoURL phoneNumber')
      .populate('veterinarian', 'displayName photoURL vetProfile');
    
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }
    
    res.json(appointment);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Create a new appointment
router.post('/', async (req, res) => {
  try {
    // Verify that the pet belongs to the pet owner
    const pet = await Pet.findById(req.body.pet);
    if (!pet) {
      return res.status(404).json({ message: 'Pet not found' });
    }
    
    if (pet.owner.toString() !== req.body.petOwner) {
      return res.status(403).json({ message: 'This pet does not belong to the specified owner' });
    }
    
    // Verify that the veterinarian exists and is a vet
    const vet = await User.findById(req.body.veterinarian);
    if (!vet || vet.role !== 'vet') {
      return res.status(404).json({ message: 'Veterinarian not found' });
    }
    
    const appointment = new Appointment({
      pet: req.body.pet,
      petOwner: req.body.petOwner,
      veterinarian: req.body.veterinarian,
      date: req.body.date,
      timeSlot: req.body.timeSlot,
      reason: req.body.reason,
      notes: req.body.notes
    });
    
    const newAppointment = await appointment.save();
    
    res.status(201).json(newAppointment);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update an appointment
router.put('/:appointmentId', async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.appointmentId);
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }
    
    // Update fields
    if (req.body.status) appointment.status = req.body.status;
    if (req.body.date) appointment.date = req.body.date;
    if (req.body.timeSlot) appointment.timeSlot = req.body.timeSlot;
    if (req.body.reason) appointment.reason = req.body.reason;
    if (req.body.notes) appointment.notes = req.body.notes;
    
    // Fields that can be updated by vet
    if (req.body.diagnosis) appointment.diagnosis = req.body.diagnosis;
    if (req.body.prescription) appointment.prescription = req.body.prescription;
    if (req.body.followUpDate) appointment.followUpDate = req.body.followUpDate;
    
    const updatedAppointment = await appointment.save();
    res.json(updatedAppointment);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Cancel an appointment
router.patch('/:appointmentId/cancel', async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.appointmentId);
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }
    
    appointment.status = 'cancelled';
    const updatedAppointment = await appointment.save();
    
    res.json(updatedAppointment);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Complete an appointment (vet only)
router.patch('/:appointmentId/complete', async (req, res) => {
  try {
    const appointment = await Appointment.findById(req.params.appointmentId);
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }
    
    appointment.status = 'completed';
    
    // Update medical information
    if (req.body.diagnosis) appointment.diagnosis = req.body.diagnosis;
    if (req.body.prescription) appointment.prescription = req.body.prescription;
    if (req.body.followUpDate) appointment.followUpDate = req.body.followUpDate;
    
    const updatedAppointment = await appointment.save();
    
    // Optionally update pet's medical history
    if (req.body.updateMedicalHistory) {
      await Pet.findByIdAndUpdate(appointment.pet, {
        $push: {
          medicalHistory: {
            date: appointment.date,
            condition: appointment.diagnosis,
            treatment: appointment.prescription,
            vet: appointment.veterinarian
          }
        }
      });
    }
    
    res.json(updatedAppointment);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

module.exports = router; 