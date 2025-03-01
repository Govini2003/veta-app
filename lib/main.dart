import 'package:flutter/material.dart';
import 'add_owner_details_page.dart';
import 'friends_page.dart';
import 'services_page.dart';
import 'settings_page.dart';
import 'models/pet_owner.dart';
import 'services/pet_owner_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Owner Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
        useMaterial3: true,
      ),
      home: const HomePage(),
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