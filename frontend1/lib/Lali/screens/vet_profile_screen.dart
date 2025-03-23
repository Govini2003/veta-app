//veta-app/frontend1/lib/Lali/screens/vet_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_screen.dart';
import 'booking_screen.dart';

class VetProfileScreen extends StatefulWidget {
  final Map<String, dynamic> vet;

  const VetProfileScreen({Key? key, required this.vet}) : super(key: key);

  @override
  _VetProfileScreenState createState() => _VetProfileScreenState();
}

class _VetProfileScreenState extends State<VetProfileScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeMarkers();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _initializeMarkers() {
    // Example vet location in Sri Lanka (you should replace with actual vet location)
    final vetLocation = LatLng(
      widget.vet['location']?['latitude'] ?? 6.9271,  // Default to Colombo
      widget.vet['location']?['longitude'] ?? 79.8612,
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('vet_location'),
          position: vetLocation,
          infoWindow: InfoWindow(
            title: widget.vet['name'],
            snippet: widget.vet['address'],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.vet['image'],
                fit: BoxFit.cover,
              ),
              title: Text(widget.vet['name']),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vet Info Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medical_services,
                                  color: Color(0xFF6BA8A9)),
                              SizedBox(width: 8),
                              Text(
                                'Specialty: ${widget.vet['specialty']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              SizedBox(width: 8),
                              Text(
                                'Rating: ${widget.vet['rating']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.work, color: Color(0xFF6BA8A9)),
                              SizedBox(width: 8),
                              Text(
                                'Experience: ${widget.vet['experience']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Location Section
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 200,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  widget.vet['location']?['latitude'] ?? 6.9271,
                                  widget.vet['location']?['longitude'] ?? 79.8612,
                                ),
                                zoom: 13,
                              ),
                              markers: _markers,
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                            ),
                          ),
                  ),
                  SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(vet: widget.vet),
                              ),
                            );
                          },
                          icon: Icon(Icons.message),
                          label: Text('Message'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6BA8A9),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(vet: widget.vet),
                              ),
                            );
                          },
                          icon: Icon(Icons.calendar_today),
                          label: Text('Book Appointment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6BA8A9),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
} 
