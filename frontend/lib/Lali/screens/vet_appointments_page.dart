import 'package:flutter/material.dart';
import 'vet_home_page.dart';
import 'vet_dashboard.dart';
import 'vet_profile.dart'; // Add this import at the top of the file
import 'petO_account_page.dart';

class VetAppointmentsPage extends StatefulWidget {
  @override
  _VetAppointmentsPageState createState() => _VetAppointmentsPageState();
}

class _VetAppointmentsPageState extends State<VetAppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Simulate API call to fetch appointments
    _fetchAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Simulate fetching appointments from an API
  Future<void> _fetchAppointments() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Mock data
    final mockAppointments = [
      Appointment(
        id: '1',
        petOwnerName: 'John Smith',
        petName: 'Max',
        petType: 'Dog',
        breed: 'Golden Retriever',
        date: DateTime.now().add(Duration(days: 1)),
        time: '10:00 AM',
        status: AppointmentStatus.pending,
        reason: 'Annual checkup and vaccination',
        ownerImage: 'assets/images/profile_photo.png',
      ),
      Appointment(
        id: '2',
        petOwnerName: 'Sarah Johnson',
        petName: 'Luna',
        petType: 'Cat',
        breed: 'Persian',
        date: DateTime.now(),
        time: '2:30 PM',
        status: AppointmentStatus.confirmed,
        reason: 'Skin irritation and excessive scratching',
        ownerImage: 'assets/images/profile_photo.png',
      ),
      Appointment(
        id: '3',
        petOwnerName: 'Michael Brown',
        petName: 'Rocky',
        petType: 'Dog',
        breed: 'Bulldog',
        date: DateTime.now().add(Duration(days: 2)),
        time: '9:15 AM',
        status: AppointmentStatus.pending,
        reason: 'Limping on right front leg',
        ownerImage: 'assets/images/profile_photo.png',
      ),
      Appointment(
        id: '4',
        petOwnerName: 'Emily Davis',
        petName: 'Coco',
        petType: 'Cat',
        breed: 'Siamese',
        date: DateTime.now().subtract(Duration(days: 1)),
        time: '4:00 PM',
        status: AppointmentStatus.completed,
        reason: 'Dental cleaning and checkup',
        ownerImage: 'assets/images/profile_photo.png',
      ),
      Appointment(
        id: '5',
        petOwnerName: 'David Wilson',
        petName: 'Bella',
        petType: 'Dog',
        breed: 'Poodle',
        date: DateTime.now().add(Duration(days: 3)),
        time: '11:30 AM',
        status: AppointmentStatus.confirmed,
        reason: 'Weight management consultation',
        ownerImage: 'assets/images/profile_photo.png',
      ),
      Appointment(
        id: '6',
        petOwnerName: 'Jennifer Taylor',
        petName: 'Oliver',
        petType: 'Cat',
        breed: 'Maine Coon',
        date: DateTime.now().subtract(Duration(days: 2)),
        time: '1:45 PM',
        status: AppointmentStatus.cancelled,
        reason: 'Respiratory issues and coughing',
        ownerImage: 'assets/images/profile_photo.png',
      ),
    ];

    setState(() {
      _appointments = mockAppointments;
      _isLoading = false;
    });
  }

  // Update appointment status
  void _updateAppointmentStatus(String id, AppointmentStatus newStatus) {
    setState(() {
      final index =
          _appointments.indexWhere((appointment) => appointment.id == id);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(status: newStatus);

        // Show a snackbar to confirm the action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Appointment ${_getStatusText(newStatus).toLowerCase()}'),
            backgroundColor: _getStatusColor(newStatus),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Color(0xFF357376); // Primary color
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Appointment> _getFilteredAppointments() {
    switch (_tabController.index) {
      case 0: // Upcoming
        return _appointments
            .where((appointment) =>
                appointment.status == AppointmentStatus.pending ||
                appointment.status == AppointmentStatus.confirmed)
            .toList();
      case 1: // Completed
        return _appointments
            .where((appointment) =>
                appointment.status == AppointmentStatus.completed)
            .toList();
      case 2: // Cancelled
        return _appointments
            .where((appointment) =>
                appointment.status == AppointmentStatus.cancelled)
            .toList();
      default:
        return _appointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Appointments',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              // Filter functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF357376), // Primary color
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF357376), // Primary color
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
          onTap: (index) {
            setState(() {});
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF357376)),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentsList(),
                _buildAppointmentsList(),
                _buildAppointmentsList(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF357376),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Appointments tab
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Payments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetHomePage()),
              );
              break;
            case 1:
              // Already on Appointments
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetDashboard()),
              );
              break;
            case 3:
              // Navigate to Payments
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetProfile()),
              );
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF357376),
        child: Icon(Icons.add),
        onPressed: () {
          // Add new appointment
        },
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final filteredAppointments = _getFilteredAppointments();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              'No appointments found',
              style: TextStyle(
                fontFamily: 'Questrial',
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return AppointmentCard(
          appointment: appointment,
          onAccept: () => _updateAppointmentStatus(
              appointment.id, AppointmentStatus.confirmed),
          onReject: () => _updateAppointmentStatus(
              appointment.id, AppointmentStatus.cancelled),
          onComplete: () => _updateAppointmentStatus(
              appointment.id, AppointmentStatus.completed),
        );
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onComplete;

  const AppointmentCard({
    required this.appointment,
    required this.onAccept,
    required this.onReject,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(appointment.ownerImage),
                  backgroundColor: Color(0xFF6BA8A9),
                  child: appointment.ownerImage.isEmpty
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.petOwnerName,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${appointment.petName} (${appointment.petType} - ${appointment.breed})',
                        style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(appointment.status),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.event, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  '${_formatDate(appointment.date)} | ${appointment.time}',
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.medical_services, size: 18, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.reason,
                    style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildActionButtons(appointment.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case AppointmentStatus.pending:
        chipColor = Colors.orange;
        statusText = 'Pending';
        break;
      case AppointmentStatus.confirmed:
        chipColor = Color(0xFF357376); // Primary color
        statusText = 'Confirmed';
        break;
      case AppointmentStatus.completed:
        chipColor = Colors.green;
        statusText = 'Completed';
        break;
      case AppointmentStatus.cancelled:
        chipColor = Colors.red;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: chipColor,
          fontFamily: 'Questrial',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppointmentStatus status) {
    if (status == AppointmentStatus.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: onReject,
            child: Text(
              'Reject',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Questrial',
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: onAccept,
            child: Text(
              'Accept',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Questrial',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF357376), // Primary color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      );
    } else if (status == AppointmentStatus.confirmed) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: onReject,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Questrial',
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: onComplete,
            child: Text(
              'Mark as Completed',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Questrial',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox
          .shrink(); // No actions for completed or cancelled appointments
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final appointmentDate = DateTime(date.year, date.month, date.day);

    if (appointmentDate == today) {
      return 'Today';
    } else if (appointmentDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Model classes
enum AppointmentStatus { pending, confirmed, completed, cancelled }

class Appointment {
  final String id;
  final String petOwnerName;
  final String petName;
  final String petType;
  final String breed;
  final DateTime date;
  final String time;
  final AppointmentStatus status;
  final String reason;
  final String ownerImage;

  Appointment({
    required this.id,
    required this.petOwnerName,
    required this.petName,
    required this.petType,
    required this.breed,
    required this.date,
    required this.time,
    required this.status,
    required this.reason,
    required this.ownerImage,
  });

  Appointment copyWith({
    String? id,
    String? petOwnerName,
    String? petName,
    String? petType,
    String? breed,
    DateTime? date,
    String? time,
    AppointmentStatus? status,
    String? reason,
    String? ownerImage,
  }) {
    return Appointment(
      id: id ?? this.id,
      petOwnerName: petOwnerName ?? this.petOwnerName,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      breed: breed ?? this.breed,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      ownerImage: ownerImage ?? this.ownerImage,
    );
  }
}
