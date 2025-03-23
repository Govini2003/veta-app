//veta-app/frontend1/lib/Lali/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedLocation = '';
  LatLng? _selectedLatLng;
  GoogleMapController? _mapController;
  bool _isMapFullScreen = false;

  // Sri Lanka map configuration
  static const LatLng _sriLankaCenter = LatLng(7.8731, 80.7718);
  static const double _initialZoom = 8.0;
  
  // Sri Lanka bounds
  static final LatLngBounds _sriLankaBounds = LatLngBounds(
    southwest: LatLng(5.916667, 79.516667), // Sri Lanka SW corner
    northeast: LatLng(9.850000, 81.883333), // Sri Lanka NE corner
  );

  // Major Sri Lankan cities for search suggestions
  final List<Map<String, dynamic>> _sriLankanCities = [
    {'name': 'Colombo', 'lat': 6.9271, 'lng': 79.8612},
    {'name': 'Kandy', 'lat': 7.2906, 'lng': 80.6337},
    {'name': 'Galle', 'lat': 6.0535, 'lng': 80.2210},
    {'name': 'Jaffna', 'lat': 9.6615, 'lng': 80.0255},
    {'name': 'Negombo', 'lat': 7.2081, 'lng': 79.8383},
    {'name': 'Trincomalee', 'lat': 8.5874, 'lng': 81.2152},
    {'name': 'Batticaloa', 'lat': 7.7170, 'lng': 81.7000},
    {'name': 'Anuradhapura', 'lat': 8.3114, 'lng': 80.4037},
    {'name': 'Ratnapura', 'lat': 6.7056, 'lng': 80.3847},
    {'name': 'Matara', 'lat': 5.9485, 'lng': 80.5353},
  ];

  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('ownerName') ?? '';
      _selectedLocation = prefs.getString('ownerLocation') ?? '';
      _locationController.text = _selectedLocation;
      double? lat = prefs.getDouble('ownerLocationLat');
      double? lng = prefs.getDouble('ownerLocationLng');
      if (lat != null && lng != null) {
        _selectedLatLng = LatLng(lat, lng);
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ownerName', _nameController.text);
    await prefs.setString('ownerLocation', _selectedLocation);
    if (_selectedLatLng != null) {
      await prefs.setDouble('ownerLocationLat', _selectedLatLng!.latitude);
      await prefs.setDouble('ownerLocationLng', _selectedLatLng!.longitude);
    }
  }

  void _focusOnSriLanka() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          _sriLankaBounds,
          50.0, // padding
        ),
      );
    }
  }

  void _searchCities(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _searchResults = _sriLankanCities
          .where((city) =>
              city['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectCity(Map<String, dynamic> city) {
    final latLng = LatLng(city['lat'], city['lng']);
    setState(() {
      _selectedLatLng = latLng;
      _selectedLocation = city['name'];
      _locationController.text = city['name'];
      _searchResults = [];
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 12),
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: "en_LK",
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = place.locality ?? place.subLocality ?? place.street ?? '';
        if (address.isNotEmpty) {
          setState(() {
            _selectedLocation = address;
            _locationController.text = address;
            _selectedLatLng = position;
          });
        }
      }
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        _selectedLocation = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        _locationController.text = _selectedLocation;
        _selectedLatLng = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isMapFullScreen) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Select Location'),
          backgroundColor: Color(0xFF357376),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _isMapFullScreen = false;
              });
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.center_focus_strong),
              onPressed: _focusOnSriLanka,
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLatLng ?? _sriLankaCenter,
                zoom: _initialZoom,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                _focusOnSriLanka();
              },
              onTap: (LatLng position) {
                if (_sriLankaBounds.contains(position)) {
                  _getAddressFromLatLng(position);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a location within Sri Lanka'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              markers: _selectedLatLng != null
                  ? {
                      Marker(
                        markerId: MarkerId('selected_location'),
                        position: _selectedLatLng!,
                        infoWindow: InfoWindow(title: _selectedLocation),
                      ),
                    }
                  : {},
              mapType: MapType.normal,
              minMaxZoomPreference: MinMaxZoomPreference(7, 16),
              cameraTargetBounds: CameraTargetBounds(_sriLankaBounds),
            ),
            // Search bar with suggestions
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Search cities in Sri Lanka',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: _locationController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _locationController.clear();
                                    _searchResults = [];
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: _searchCities,
                    ),
                  ),
                  if (_searchResults.isNotEmpty)
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.only(top: 4),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final city = _searchResults[index];
                            return ListTile(
                              leading: Icon(Icons.location_city),
                              title: Text(city['name']),
                              onTap: () => _selectCity(city),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Confirm button
            if (_selectedLatLng != null)
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isMapFullScreen = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF357376),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                  ),
                  child: Text(
                    'Confirm Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFF357376),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _locationController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.location_on),
              ),
              onTap: () {
                setState(() {
                  _isMapFullScreen = true;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _saveProfileData();
                Navigator.pop(context, true);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF357376),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
} 
