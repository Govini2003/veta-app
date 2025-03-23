import 'package:flutter/material.dart';
import 'vet_home_page.dart';
import 'vet_appointments_page.dart';
import 'vet_dashboard.dart';
import 'vetside_settings_page.dart';

class VetPaymentPage extends StatefulWidget {
  @override
  _VetPaymentPageState createState() => _VetPaymentPageState();
}

class _VetPaymentPageState extends State<VetPaymentPage> {
  // Mock data for payments
  final List<Map<String, dynamic>> payments = [
    {
      'id': '1',
      'clientName': 'John Doe',
      'petName': 'Max',
      'service': 'Vaccination',
      'amount': 150.0,
      'date': '2024-03-17',
      'status': 'Completed',
    },
    {
      'id': '2',
      'clientName': 'Sarah Johnson',
      'petName': 'Luna',
      'service': 'Check-up',
      'amount': 100.0,
      'date': '2024-03-16',
      'status': 'Pending',
    },
    {
      'id': '3',
      'clientName': 'Mike Wilson',
      'petName': 'Rocky',
      'service': 'Surgery',
      'amount': 500.0,
      'date': '2024-03-15',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payments',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Earnings',
                    '\$750',
                    Icons.attach_money,
                    Color(0xFF357376),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Pending',
                    '\$100',
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          // Payments List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF357376),
                      child: Icon(Icons.payment, color: Colors.white),
                    ),
                    title: Text(
                      payment['clientName'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          '${payment['petName']} - ${payment['service']}',
                          style: TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          payment['date'],
                          style: TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${payment['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF357376),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: payment['status'] == 'Completed'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            payment['status'],
                            style: TextStyle(
                              fontFamily: 'Questrial',
                              fontSize: 12,
                              color: payment['status'] == 'Completed'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle payment details view
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF357376),
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Set to 3 for Payments tab
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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

  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Questrial',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 