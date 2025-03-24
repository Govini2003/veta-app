//backend1/src/controllers/appointmentController.js
const Appointment = require('../models/Appointment');

// Create new appointment
exports.createAppointment = async (req, res) => {
    try {
        const appointment = new Appointment({
            ...req.body,
            userId: req.user._id
        });
        const newAppointment = await appointment.save();
        await newAppointment.populate('petId userId veterinarianId');
        res.status(201).json(newAppointment);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Get all appointments for a user
exports.getUserAppointments = async (req, res) => {
    try {
        const appointments = await Appointment.find({ userId: req.user._id })
            .populate('petId')
            .populate('veterinarianId')
            .sort({ appointmentDate: 1 });
        res.json(appointments);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Get appointment by ID
exports.getAppointmentById = async (req, res) => {
    try {
        const appointment = await Appointment.findById(req.params.id)
            .populate('petId')
            .populate('veterinarianId');
        
        if (!appointment) {
            return res.status(404).json({ message: 'Appointment not found' });
        }

        // Check if user is authorized to view this appointment
        if (appointment.userId.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized to view this appointment' });
        }

        res.json(appointment);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Update appointment
exports.updateAppointment = async (req, res) => {
    try {
        const appointment = await Appointment.findById(req.params.id);
        if (!appointment) {
            return res.status(404).json({ message: 'Appointment not found' });
        }

        // Check if user is authorized to update this appointment
        if (appointment.userId.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized to update this appointment' });
        }

        const updatedAppointment = await Appointment.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        ).populate('petId veterinarianId');

        res.json(updatedAppointment);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Delete appointment
exports.deleteAppointment = async (req, res) => {
    try {
        const appointment = await Appointment.findById(req.params.id);
        if (!appointment) {
            return res.status(404).json({ message: 'Appointment not found' });
        }

        // Check if user is authorized to delete this appointment
        if (appointment.userId.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized to delete this appointment' });
        }

        await appointment.remove();
        res.json({ message: 'Appointment cancelled successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
