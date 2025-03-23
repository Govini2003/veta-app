import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'vet_home_page.dart';
import 'vet_appointments_page.dart';
import 'vet_dashboard.dart';
import 'vet_profile.dart';
import 'vetside_settings_page.dart';

class VetPaymentPage extends StatefulWidget {
  @override
  _VetPaymentPageState createState() => _VetPaymentPageState();
}

class _VetPaymentPageState extends State<VetPaymentPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> payments = [
    {
      'id': 'PAY001',
      'amount': 150.00,
      'date': DateTime.now().subtract(Duration(days: 1)),
      'status': 'pending',
      'customerName': 'John Doe',
      'service': 'Vaccination'
    },
    {
      'id': 'PAY002',
      'amount': 200.00,
      'date': DateTime.now().subtract(Duration(days: 2)),
      'status': 'completed',
      'customerName': 'Jane Smith',
      'service': 'General Checkup'
    },
    {
      'id': 'PAY003',
      'amount': 300.00,
      'date': DateTime.now(),
      'status': 'pending',
      'customerName': 'Mike Johnson',
      'service': 'Surgery Consultation'
    },
  ];

  Future<void> _refreshPayments() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _processPayment(int index) async {
    setState(() {
      isLoading = true;
    });

    // Simulate processing delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      payments[index]['status'] = 'completed';
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Payment ${payments[index]['id']} processed successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _refundPayment(int index) async {
    setState(() {
      isLoading = true;
    });

    // Simulate refund delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      payments[index]['status'] = 'refunded';
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment ${payments[index]['id']} refunded successfully'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
        backgroundColor: Color(0xFF357376),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshPayments,
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                final formattedDate =
                    DateFormat('MMM dd, yyyy').format(payment['date']);
                final formattedAmount = NumberFormat.currency(symbol: '\$')
                    .format(payment['amount']);

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID: ${payment['id']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF357376),
                              ),
                            ),
                            _buildStatusChip(payment['status']),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Customer: ${payment['customerName']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Service: ${payment['service']}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedAmount,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64CCC5),
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _buildActionButtons(payment['status'], index),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF64CCC5)),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF357376),
        unselectedItemColor: Colors.grey,
        currentIndex: 3,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetAppointmentsPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetDashboard()),
              );
              break;
            case 3:
              // Already on Payments page
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => VetsideSettingsPage()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'refunded':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildActionButtons(String status, int index) {
    if (status == 'pending') {
      return ElevatedButton(
        onPressed: () => _processPayment(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF64CCC5),
          minimumSize: Size(double.infinity, 36),
        ),
        child: Text('Process Payment'),
      );
    } else if (status == 'completed') {
      return ElevatedButton(
        onPressed: () => _refundPayment(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: Size(double.infinity, 36),
        ),
        child: Text('Refund Payment'),
      );
    }
    return SizedBox.shrink();
  }
}
