//veta-app/frontend1/lib/Lali/screens/appointment_details_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/appointment.dart';
import '../providers/appointments_provider.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  _AppointmentDetailsScreenState createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  final Map<int, List<String>> _vetSchedule = {
    1: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'], // Monday
    2: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'], // Tuesday
    3: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'], // Wednesday
    4: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'], // Thursday
    5: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM'], // Friday
    6: ['09:00 AM', '10:00 AM', '11:00 AM'], // Saturday
    7: [], // Sunday - No appointments
  };

  List<String> _getAvailableTimeSlots() {
    if (_selectedDate == null) return [];
    int weekday = _selectedDate!.weekday;
    return _vetSchedule[weekday] ?? [];
  }

  bool _isDateSelectable(DateTime date) {
    if (date.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return false;
    }
    if (date.isAfter(DateTime.now().add(Duration(days: 90)))) {
      return false;
    }
    if (date.weekday == DateTime.sunday) {
      return false;
    }
    return true;
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.appointment.dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      selectableDayPredicate: _isDateSelectable,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null; // Reset time when date changes
      });
      _showTimePickerDialog();
    }
  }

  void _showTimePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Time'),
        content: Container(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _getAvailableTimeSlots().length,
            itemBuilder: (context, index) {
              final time = _getAvailableTimeSlots()[index];
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedTime == time 
                      ? Color(0xFF6BA8A9) 
                      : Colors.grey[200],
                ),
                onPressed: () {
                  setState(() => _selectedTime = time);
                  Navigator.pop(context);
                  _showConfirmationDialog();
                },
                child: Text(
                  time,
                  style: TextStyle(
                    color: _selectedTime == time ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    if (_selectedDate == null || _selectedTime == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Appointment Change'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current appointment:'),
            Text(DateFormat('EEEE, MMMM d, y - h:mm a')
                .format(widget.appointment.dateTime)),
            SizedBox(height: 16),
            Text('New appointment:'),
            Text(DateFormat('EEEE, MMMM d, y').format(_selectedDate!) +
                ' - $_selectedTime'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6BA8A9),
            ),
            onPressed: () {
              _updateAppointment();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home page
            },
            child: Text('Confirm Change'),
          ),
        ],
      ),
    );
  }

  void _updateAppointment() {
    if (_selectedDate == null || _selectedTime == null) return;

    // Parse the selected time
    final timeFormat = DateFormat('h:mm a');
    final selectedDateTime = timeFormat.parse(_selectedTime!);
    
    // Create new appointment datetime
    final newDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      selectedDateTime.hour,
      selectedDateTime.minute,
    );

    // Create new appointment with updated datetime
    final newAppointment = Appointment(
      vetName: widget.appointment.vetName,
      vetSpecialty: widget.appointment.vetSpecialty,
      clinicName: widget.appointment.clinicName,
      dateTime: newDateTime,
      vetImage: widget.appointment.vetImage,
    );

    // Update in provider
    final appointmentsProvider = Provider.of<AppointmentsProvider>(context, listen: false);
    appointmentsProvider.removeAppointment(widget.appointment);
    appointmentsProvider.addAppointment(newAppointment);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment updated successfully')),
    );
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Appointment'),
        content: Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Provider.of<AppointmentsProvider>(context, listen: false)
                  .removeAppointment(widget.appointment);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Appointment cancelled successfully')),
              );
            },
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        backgroundColor: Color(0xFF6BA8A9),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment Info Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(widget.appointment.vetImage),
                          radius: 30,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.appointment.vetName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.appointment.vetSpecialty),
                              Text(widget.appointment.clinicName),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Appointment Time:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat('EEEE, MMMM d, y - h:mm a')
                          .format(widget.appointment.dateTime),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit_calendar),
                    label: Text('Change Date & Time'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6BA8A9),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _showDatePicker,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(Icons.cancel, color: Colors.red),
                label: Text(
                  'Cancel Appointment',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _showCancelConfirmation,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
