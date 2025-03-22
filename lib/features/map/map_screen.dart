//map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  LatLng? _selectedLocation; // Holds the searched location coordinates
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
        headers: {'User-Agent': 'VetaApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List results = json.decode(response.body);
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
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Find Veterinary Services",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Search Locations in Sri Lanka',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter location name...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _isLoading 
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _errorMessage = null);
                          },
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedLocationName,
                              style: TextStyle(
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
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Latitude: ${_selectedLocation!.latitude.toStringAsFixed(4)}\n'
                        'Longitude: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
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
                      userAgentPackageName: 'com.example.veta_app',
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
                                        color: theme.cardColor,
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
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            _selectedLocationName,
                                            style: TextStyle(
                                              fontSize: 12,
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
                    elevation: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
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
                          color: theme.dividerColor,
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
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
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
