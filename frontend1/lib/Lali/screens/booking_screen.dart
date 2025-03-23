// veta-app/frontend1/lib/Lali/screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/appointments_provider.dart';
import '../models/appointment.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> vet;

  const BookingScreen({Key? key, required this.vet}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  final ScrollController _timeScrollController = ScrollController();

  // Example vet schedule - In a real app, this would come from a backend
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
    // Get weekday (1-7, where 1 is Monday and 7 is Sunday)
    int weekday = _selectedDate.weekday;
    return _vetSchedule[weekday] ?? [];
  }

  bool _isDateSelectable(DateTime date) {
    // Don't allow past dates
    if (date.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return false;
    }
    // Don't allow dates more than 3 months in advance
    if (date.isAfter(DateTime.now().add(Duration(days: 90)))) {
      return false;
    }
    // Don't allow Sundays
    if (date.weekday == DateTime.sunday) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: Color(0xFF6BA8A9),
      ),
      body: Column(
        children: [
          // Vet Info Card
          Card(
            margin: EdgeInsets.all(16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(widget.vet['image']),
              ),
              title: Text(widget.vet['name']),
              subtitle: Text(widget.vet['specialty']),
            ),
          ),

          // Calendar Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 90)),
                    onDateChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                        _selectedTime = null; // Reset selected time when date changes
                      });
                    },
                    selectableDayPredicate: _isDateSelectable,
                  ),
                ),
              ],
            ),
          ),

          // Time Slots Section
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: _getAvailableTimeSlots().isEmpty
                        ? Center(
                            child: Text(
                              'No available slots for this date',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : GridView.builder(
                            controller: _timeScrollController,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _getAvailableTimeSlots().length,
                            itemBuilder: (context, index) {
                              final timeSlot = _getAvailableTimeSlots()[index];
                              final isSelected = timeSlot == _selectedTime;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedTime = timeSlot;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xFF6BA8A9)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? Color(0xFF6BA8A9)
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    timeSlot,
                                    style: TextStyle(
                                      color:
                                          isSelected ? Colors.white : Colors.black87,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Book Button
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _selectedTime == null
                  ? null
                  : () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Appointment'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vet: ${widget.vet['name']}'),
                              SizedBox(height: 8),
                              Text(
                                  'Date: ${DateFormat('EEEE, MMMM d, y').format(_selectedDate)}'),
                              SizedBox(height: 8),
                              Text('Time: $_selectedTime'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Create and save the appointment
                                final appointment = Appointment(
                                  vetName: widget.vet['name'],
                                  vetSpecialty: widget.vet['specialty'],
                                  clinicName: widget.vet['location']['address'],
                                  dateTime: DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month,
                                    _selectedDate.day,
                                    int.parse(_selectedTime!.split(':')[0]),
                                    int.parse(_selectedTime!.split(' ')[0].split(':')[1]),
                                  ),
                                  vetImage: widget.vet['image'],
                                );

                                // Add appointment using the provider
                                Provider.of<AppointmentsProvider>(context, listen: false)
                                    .addAppointment(appointment);

                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Return to profile
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Appointment booked successfully!'),
                                    backgroundColor: Color(0xFF6BA8A9),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6BA8A9),
                              ),
                              child: Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6BA8A9),
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Book Appointment',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timeScrollController.dispose();
    super.dispose();
  }
} 
