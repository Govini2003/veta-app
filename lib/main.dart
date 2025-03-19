import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_config.dart';
import 'services/api_service.dart';
import 'Entrance/welcome_screen.dart';
import 'Entrance/wrapper.dart';
import 'themes/theme.dart';
import 'InuPetProfile/add_pet_page.dart';

class FirebaseInitializer {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyBgdx-5nRYAiEjiIoKBn661UVamYgnhQwg",
          authDomain: "veta-login.firebaseapp.com",
          projectId: "veta-login",
          storageBucket: "veta-login.firebasestorage.app",
          messagingSenderId: "596091829422",
          appId: "1:596091829422:web:87a3075a440f449fbb013f",
          measurementId: "G-NWVETG4P5J",
        ),
      );
      _initialized = true;
      print('Firebase initialization successful.');
    } else {
      print('Firebase already initialized.');
    }
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  print('Starting Firebase initialization...');
  try {
    await FirebaseInitializer.initialize();
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  // Initialize API Configuration
  const environment =
      String.fromEnvironment('FLUTTER_ENV', defaultValue: 'development');

  switch (environment) {
    case 'production':
      ApiConfig.initConfig(Environment.production);
      break;
    case 'staging':
      ApiConfig.initConfig(Environment.staging);
      break;
    default:
      ApiConfig.initConfig(Environment.development);
  }

  // Check backend health
  final apiService = ApiService();
  final isHealthy = await apiService.checkHealth();
  if (isHealthy) {
    print('Backend is up and running!');
  } else {
    print('Warning: Backend is not accessible');
    // You might want to show a user-friendly message or retry mechanism here
  }
}

void main() async {
  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Veta.lk',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Wrapper()),
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
