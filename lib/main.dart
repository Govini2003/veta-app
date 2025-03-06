// veta-app/lib/main.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'add_owner_details_page.dart';
import 'friends_page.dart';
import 'services_page.dart';
import 'settings_page.dart';
import 'models/pet_owner.dart';
import 'services/pet_owner_service.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/chat_screen.dart';
import 'themes/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const VetCalendarApp());
}

class VetCalendarApp extends StatelessWidget {
  const VetCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet Calendar',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE9EFEC),
        primaryColor: const Color(0xFF6BA8A9),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF357376),
          secondary: const Color(0xFF1D4D4F),
          surface: const Color(0xFFDEC092),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Set the initial screen to SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Fade-in Effect
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Slide-up Effect
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Auto-Navigate after Splash Screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF357376), // Medium Greenish Shade
              Color(0xFF1D4D4F), // Darkest Brand Color
              Color(0xFF6BA8A9), // Lightest Green
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 45,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Veta.lk',
                      style: GoogleFonts.poppins(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'No More Struggles For\nPet Owners & Vets',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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
        return MapScreen();
      case 4:
        return SettingsPage(
          onSettingsChanged: () {
            setState(() {
              _loadCurrentOwner();
            });
          },
        );
      case 5:
        return ChatScreen();
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
            icon: _pendingRequestsCount > 0
                ? Stack(
                    children: [
                      Icon(Icons.people),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            _pendingRequestsCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  
  final LatLng _sriLankaCenter = LatLng(7.8731, 80.7718);
  final LatLngBounds _sriLankaBounds = LatLngBounds(
    LatLng(5.9167, 79.6833),
    LatLng(9.8167, 81.8833),
  );

  double _zoom = 8.0;
  LatLng? _selectedLocation;
  String _selectedLocationName = '';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() => _errorMessage = 'Please enter a location to search');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final encodedQuery = Uri.encodeComponent('$query, Sri Lanka');
    final url = 'https://nominatim.openstreetmap.org/search?format=json&q=$encodedQuery&countrycodes=lk';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'Veta.lk/1.0'},
      );

      if (response.statusCode == 200) {
        final List results = jsonDecode(response.body);
        if (results.isNotEmpty) {
          final location = results.first;
          final lat = double.parse(location['lat']);
          final lon = double.parse(location['lon']);
          final name = location['display_name'] as String;
          
          final newLocation = LatLng(lat, lon);
          if (_sriLankaBounds.contains(newLocation)) {
            setState(() {
              _selectedLocation = newLocation;
              _selectedLocationName = name.split(',')[0];
              _zoom = 14;
              _errorMessage = null;
            });
            _mapController.move(newLocation, _zoom);
            
            HapticFeedback.mediumImpact();
          } else {
            setState(() => _errorMessage = 'Location must be within Sri Lanka');
          }
        } else {
          setState(() => _errorMessage = 'Location not found in Sri Lanka');
        }
      } else {
        setState(() => _errorMessage = 'Failed to search location. Please try again.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Network error. Please check your connection.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.primaryColor.withOpacity(0.8),
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Find Places in Sri Lanka',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _searchController,
                style: TextStyle(color: AppTheme.primaryColor),
                decoration: InputDecoration(
                  hintText: 'Enter location name...',
                  hintStyle: TextStyle(color: AppTheme.primaryColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                  suffixIcon: _isLoading 
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.clear, color: AppTheme.primaryColor),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _errorMessage = null);
                        },
                      ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                onSubmitted: _searchLocation,
                textInputAction: TextInputAction.search,
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_selectedLocation != null)
          Container(
            color: AppTheme.primaryColor.withOpacity(0.8),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppTheme.primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedLocationName,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Coordinates',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Latitude: ${_selectedLocation!.latitude.toStringAsFixed(4)}\n'
                      'Longitude: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _sriLankaCenter,
                  initialZoom: _zoom,
                  minZoom: 7,
                  maxZoom: 18,
                  cameraConstraint: CameraConstraint.contain(
                    bounds: _sriLankaBounds,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.veta.app',
                  ),
                  MarkerLayer(
                    markers: _selectedLocation != null
                        ? [
                            Marker(
                              width: 180.0,
                              height: 50.0,
                              point: _selectedLocation!,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: AppTheme.primaryColor,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          _selectedLocationName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        : [],
                  ),
                ],
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add, color: AppTheme.primaryColor),
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          );
                          HapticFeedback.selectionClick();
                        },
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: AppTheme.primaryColor.withOpacity(0.2),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove, color: AppTheme.primaryColor),
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          );
                          HapticFeedback.selectionClick();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
