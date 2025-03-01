import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'add_owner_details_page.dart';
import 'friends_page.dart';
import 'services_page.dart';
import 'settings_page.dart';
import 'models/pet_owner.dart';
import 'services/pet_owner_service.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';
import 'themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veta.lk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PetOwnerService _petOwnerService = PetOwnerService();
  PetOwner? _currentOwner;
  int _selectedIndex = 0;
  int _pendingRequestsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentOwner();
    _setupFriendRequestListener();
  }

  Future<void> _loadCurrentOwner() async {
    final owner = await _petOwnerService.getCurrentOwner();
    setState(() {
      _currentOwner = owner;
      if (owner != null) {
        _pendingRequestsCount = owner.pendingFriendRequests.length;
      }
    });
  }

  void _setupFriendRequestListener() {
    _petOwnerService.friendRequestStream.listen((requester) {
      setState(() {
        _pendingRequestsCount++;
      });
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return AddOwnerDetailsPage(
          initialOwner: _currentOwner,
          onOwnerUpdated: (owner) {
            setState(() {
              _currentOwner = owner;
            });
          },
        );
      case 1:
        return FriendsPage();
      case 2:
        return ServicesPage(
          bookings: _currentOwner?.serviceBookings ?? [],
          onBookingAdded: (booking) {
            if (_currentOwner != null) {
              setState(() {
                _currentOwner = _currentOwner!.copyWith(
                  serviceBookings: [..._currentOwner!.serviceBookings, booking],
                );
              });
              _petOwnerService.updatePetOwner(_currentOwner!);
            }
          },
        );
      case 3:
        return SettingsPage(
          onSettingsChanged: () {
            setState(() {
              // Reload the current owner to reflect any settings changes
              _loadCurrentOwner();
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text(_pendingRequestsCount > 0 ? _pendingRequestsCount.toString() : ''),
              isLabelVisible: _pendingRequestsCount > 0,
              child: Icon(Icons.people),
            ),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veta.lk'),
        backgroundColor: const Color(0xFF1D4D4F),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello,\nUser\'s Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D4D4F),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction(Icons.help, 'Help'),
                _buildQuickAction(Icons.account_balance_wallet, 'Wallet'),
                _buildQuickAction(Icons.message, 'Messages'),
              ],
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              title: 'Add your Pet',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPetPage(
                      onPetAdded: (pet) {
                        // TODO: Handle the added pet
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Pet added successfully!')),
                        );
                      },
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

  Widget _buildQuickAction(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFE9EFEC),
          child: Icon(icon, color: const Color(0xFF357376), size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Color(0xFF1D4D4F))),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String title, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF357376),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}