// veta-app/frontend1/lib/Lali/screens/vet_location_page.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class VetLocationPage extends StatefulWidget {
  @override
  _VetLocationPageState createState() => _VetLocationPageState();
}

class _VetLocationPageState extends State<VetLocationPage> {
  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;
  String? address;
  final TextEditingController _addressController = TextEditingController();
  bool _isEditingAddress = false;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
        isLoading = false;
        _markers = {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        };
      });

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            address = '${place.street}, ${place.locality}, ${place.country}';
            _addressController.text = address ?? '';
          });
        }
      } catch (e) {
        print('Error getting address: $e');
      }

      // Move camera to current location
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(7.8731, 80.7718), // Sri Lanka center coordinates
            zoom: 7,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6BA8A9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Location',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : currentPosition == null
              ? const Center(
                  child: Text('Unable to get location'),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(7.8731, 80.7718), // Sri Lanka center
                        zoom: 7,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      mapToolbarEnabled: true,
                      compassEnabled: true,
                      markers: _markers,
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Current Location',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF357376),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isEditingAddress
                                          ? Icons.save
                                          : Icons.edit,
                                      color: const Color(0xFF357376),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isEditingAddress = !_isEditingAddress;
                                        if (!_isEditingAddress) {
                                          // Save the address
                                          address = _addressController.text;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (_isEditingAddress)
                                TextField(
                                  controller: _addressController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your address',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 2,
                                )
                              else
                                Text(
                                  address ?? 'No address set',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                'Latitude: ${currentPosition!.latitude.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Longitude: ${currentPosition!.longitude.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _getCurrentLocation,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF357376),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Update Location',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    mapController?.dispose();
    super.dispose();
  }
} 
