import 'package:flutter/material.dart';
import 'models/pet_owner.dart';
import 'theme/app_theme.dart';

class ServicesPage extends StatefulWidget {
  final List<ServiceBooking> bookings;
  final Function(ServiceBooking) onBookingAdded;

  ServicesPage({
    required this.bookings,
    required this.onBookingAdded,
  });

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Map<String, dynamic>> _services = [
    {
      'type': 'Veterinary',
      'icon': Icons.local_hospital,
      'services': [
        'Regular Check-ups',
        'Vaccinations',
        'Emergency Care',
        'Surgery',
      ],
    },
    {
      'type': 'Pet Grooming',
      'icon': Icons.content_cut,
      'services': [
        'Bath & Brush',
        'Haircut',
        'Nail Trimming',
        'Teeth Cleaning',
      ],
    },
    {
      'type': 'Training',
      'icon': Icons.school,
      'services': [
        'Basic Obedience',
        'Behavior Modification',
        'Agility Training',
        'Puppy Classes',
      ],
    },
    {
      'type': 'Pet Sitting',
      'icon': Icons.pets,
      'services': [
        'Day Care',
        'Overnight Stay',
        'Dog Walking',
        'Home Visits',
      ],
    },
  ];

  void _bookService(String serviceType, String specificService) async {
    // Show booking dialog
    final result = await showDialog<ServiceBooking>(
      context: context,
      builder: (BuildContext context) {
        return BookServiceDialog(
          serviceType: serviceType,
          specificService: specificService,
        );
      },
    );

    if (result != null) {
      widget.onBookingAdded(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Services'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Services Categories
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return ExpansionTile(
                  leading: Icon(service['icon'] as IconData),
                  title: Text(
                    service['type'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: (service['services'] as List<String>).map((specificService) {
                    return ListTile(
                      title: Text(specificService),
                      trailing: ElevatedButton(
                        onPressed: () => _bookService(service['type'] as String, specificService),
                        child: Text('Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // Upcoming Appointments
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Upcoming Appointments',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.bookings.length,
              itemBuilder: (context, index) {
                final booking = widget.bookings[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(booking.serviceType),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.providerName),
                        Text(
                          'Date: ${booking.appointmentTime.year}-${booking.appointmentTime.month}-${booking.appointmentTime.day}',
                        ),
                        Text(
                          'Time: ${booking.appointmentTime.hour}:${booking.appointmentTime.minute.toString().padLeft(2, '0')}',
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(booking.status),
                      backgroundColor: booking.status == 'Confirmed'
                          ? Colors.green[100]
                          : Colors.orange[100],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookServiceDialog extends StatefulWidget {
  final String serviceType;
  final String specificService;

  BookServiceDialog({
    required this.serviceType,
    required this.specificService,
  });

  @override
  _BookServiceDialogState createState() => _BookServiceDialogState();
}

class _BookServiceDialogState extends State<BookServiceDialog> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _noteController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _bookAppointment() {
    final booking = ServiceBooking(
      id: DateTime.now().toString(),
      serviceType: '${widget.serviceType} - ${widget.specificService}',
      providerName: 'Best Pet Care Center', // This would come from a real provider
      providerAddress: '123 Pet Street', // This would come from a real provider
      appointmentTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      status: 'Pending',
      notes: _noteController.text,
    );

    Navigator.of(context).pop(booking);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Book ${widget.specificService}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            ListTile(
              title: Text(
                '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
              ),
              trailing: Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _bookAppointment,
          child: Text('Book'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
