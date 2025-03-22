const Pet = require('../models/Pet');

// Create new pet
exports.createPet = async (req, res) => {
    try {
        const pet = new Pet({
            ...req.body,
            owner: req.user._id
        });
        const newPet = await pet.save();
        res.status(201).json(newPet);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Get all pets
exports.getAllPets = async (req, res) => {
    try {
        const pets = await Pet.find().populate('owner', 'name email');
        res.json(pets);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Get pet by ID
exports.getPetById = async (req, res) => {
    try {
        const pet = await Pet.findById(req.params.id).populate('owner', 'name email');
        if (!pet) {
            return res.status(404).json({ message: 'Pet not found' });
        }
        res.json(pet);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Update pet
exports.updatePet = async (req, res) => {
    try {
        const pet = await Pet.findById(req.params.id);
        if (!pet) {
            return res.status(404).json({ message: 'Pet not found' });
        }
        
        // Check if user is the owner
        if (pet.owner.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized to update this pet' });
        }

        const updatedPet = await Pet.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        ).populate('owner', 'name email');
        
        res.json(updatedPet);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Delete pet
exports.deletePet = async (req, res) => {
    try {
        const pet = await Pet.findById(req.params.id);
        if (!pet) {
            return res.status(404).json({ message: 'Pet not found' });
        }

        // Check if user is the owner
        if (pet.owner.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized to delete this pet' });
        }

        await pet.remove();
        res.json({ message: 'Pet deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};