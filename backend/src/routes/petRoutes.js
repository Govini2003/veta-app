const express = require('express');
const router = express.Router();
const Pet = require('../models/Pet');
const User = require('../models/User');

// Get all pets for a user
router.get('/user/:userId', async (req, res) => {
  try {
    const pets = await Pet.find({ owner: req.params.userId });
    res.json(pets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get specific pet
router.get('/:petId', async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.petId)
      .populate('owner')
      .populate({
        path: 'vaccinations.vet',
        select: 'displayName vetProfile.slvcNumber'
      });
    
    if (!pet) {
      return res.status(404).json({ message: 'Pet not found' });
    }
    res.json(pet);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Create new pet
router.post('/', async (req, res) => {
  const pet = new Pet({
    owner: req.body.owner,
    name: req.body.name,
    species: req.body.species,
    breed: req.body.breed,
    dateOfBirth: req.body.dateOfBirth,
    gender: req.body.gender,
    weight: req.body.weight,
    photoURL: req.body.photoURL
  });

  try {
    const newPet = await pet.save();
    res.status(201).json(newPet);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update pet
router.put('/:petId', async (req, res) => {
  try {
    const updatedPet = await Pet.findByIdAndUpdate(
      req.params.petId,
      {
        $set: {
          name: req.body.name,
          species: req.body.species,
          breed: req.body.breed,
          dateOfBirth: req.body.dateOfBirth,
          gender: req.body.gender,
          weight: req.body.weight,
          photoURL: req.body.photoURL
        }
      },
      { new: true }
    );
    res.json(updatedPet);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Add medical history
router.post('/:petId/medical-history', async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.petId);
    pet.medicalHistory.push({
      date: req.body.date,
      condition: req.body.condition,
      treatment: req.body.treatment,
      vet: req.body.vetId
    });
    const updatedPet = await pet.save();
    res.status(201).json(updatedPet);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Add vaccination
router.post('/:petId/vaccination', async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.petId);
    
    // Verify the vet exists
    const vet = await User.findById(req.body.vetId);
    if (!vet || vet.role !== 'vet') {
      return res.status(400).json({ message: 'Invalid veterinarian ID' });
    }
    
    // Create vaccination record
    const vaccination = {
      vaccineType: req.body.vaccineType,
      vaccinationDate: req.body.vaccinationDate,
      renewalDate: req.body.renewalDate,
      vet: req.body.vetId,
      veterinarianName: vet.displayName,
      veterinarianRegNumber: vet.vetProfile?.slvcNumber || '',
      vaccineLabel: req.body.vaccineLabel,
      notes: req.body.notes
    };
    
    pet.vaccinations.push(vaccination);
    const updatedPet = await pet.save();
    res.status(201).json(updatedPet);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Get pet's vaccination history
router.get('/:petId/vaccinations', async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.petId)
      .populate({
        path: 'vaccinations.vet',
        select: 'displayName vetProfile.slvcNumber'
      });
    
    if (!pet) {
      return res.status(404).json({ message: 'Pet not found' });
    }
    
    res.json(pet.vaccinations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Update a vaccination record
router.put('/:petId/vaccination/:vaccinationId', async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.petId);
    
    if (!pet) {
      return res.status(404).json({ message: 'Pet not found' });
    }
    
    // Find the vaccination record
    const vaccination = pet.vaccinations.id(req.params.vaccinationId);
    
    if (!vaccination) {
      return res.status(404).json({ message: 'Vaccination record not found' });
    }
    
    // Update the vaccination fields
    if (req.body.vaccineType) vaccination.vaccineType = req.body.vaccineType;
    if (req.body.vaccinationDate) vaccination.vaccinationDate = req.body.vaccinationDate;
    if (req.body.renewalDate) vaccination.renewalDate = req.body.renewalDate;
    if (req.body.vaccineLabel) vaccination.vaccineLabel = req.body.vaccineLabel;
    if (req.body.notes) vaccination.notes = req.body.notes;
    
    // If vet is being updated, update related fields
    if (req.body.vetId) {
      const vet = await User.findById(req.body.vetId);
      if (!vet || vet.role !== 'vet') {
        return res.status(400).json({ message: 'Invalid veterinarian ID' });
      }
      
      vaccination.vet = req.body.vetId;
      vaccination.veterinarianName = vet.displayName;
      vaccination.veterinarianRegNumber = vet.vetProfile?.slvcNumber || '';
    }
    
    const updatedPet = await pet.save();
    res.json(updatedPet);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete a vaccination record
router.delete('/:petId/vaccination/:vaccinationId', async (req, res) => {
  try {
    const pet = await Pet.findById(req.params.petId);
    
    if (!pet) {
      return res.status(404).json({ message: 'Pet not found' });
    }
    
    // Find and remove the vaccination record
    pet.vaccinations.id(req.params.vaccinationId).remove();
    
    const updatedPet = await pet.save();
    res.json({ message: 'Vaccination record deleted', pet: updatedPet });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

module.exports = router; 