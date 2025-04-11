import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class DoctorMapPage extends StatefulWidget {
  @override
  _DoctorMapPageState createState() => _DoctorMapPageState();
}

class _DoctorMapPageState extends State<DoctorMapPage> {
  final mapController = MapController();
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> _routePoints = [];
  String? _selectedSpecialty;
  String _searchQuery = '';
  String? _etaInfo;

  final List<Map<String, dynamic>> doctorLocations = [
    {
      'name': 'Dr. Meera Singh',
      'specialty': 'Cardiologist',
      'location': LatLng(28.6139, 77.2090), // New Delhi
    },
    {
      'name': 'Dr. Rohit Malhotra',
      'specialty': 'Dentist',
      'location': LatLng(28.7041, 77.1025), // Delhi
    },
    {
      'name': 'Dr. Rina Verma',
      'specialty': 'Gynecologist',
      'location': LatLng(28.5355, 77.3910), // Noida
    },
    {
      'name': 'Dr. Anil Kapoor',
      'specialty': 'Cardiologist',
      'location': LatLng(28.4595, 77.0266), // Gurgaon
    },
    {
      'name': 'Dr. Priya Sharma',
      'specialty': 'Dermatologist',
      'location': LatLng(28.4089, 77.3178), // Faridabad
    },
    {
      'name': 'Dr. Nikhil Joshi',
      'specialty': 'Pediatrician',
      'location': LatLng(28.6692, 77.4538), // Ghaziabad
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    LocationData currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  Future<void> _getDirectionsAndETA(LatLng dest) async {
    const apiKey = '5b3ce3597851110001cf62482e1fb23b0a594412b4d0dd60b6a37df7'; // Replace with your API key
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${_currentLocation!.longitude},${_currentLocation!.latitude}&end=${dest.longitude},${dest.latitude}');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List coords = decoded['features'][0]['geometry']['coordinates'];
      final summary = decoded['features'][0]['properties']['summary'];
      double distanceKm = summary['distance'] / 1000;
      double durationHr = summary['duration'] / 3600; // convert seconds to hours

      setState(() {
        _routePoints = coords.map((c) => LatLng(c[1], c[0])).toList();
        _destination = dest;
        _etaInfo = "Distance: ${distanceKm.toStringAsFixed(2)} km | ETA: ${durationHr.toStringAsFixed(2)} hr";
      });
    } else {
      print('Error fetching directions: ${response.body}');
    }
  }

  List<Map<String, dynamic>> get filteredDoctors {
    return doctorLocations.where((doc) {
      final matchesSpecialty = _selectedSpecialty == null || doc['specialty'] == _selectedSpecialty;
      final matchesSearch = _searchQuery.isEmpty || doc['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSpecialty && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find Doctors on Map")),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedSpecialty,
                          hint: Text("Filter by Specialty"),
                          items: [
                            'All',
                            'Cardiologist',
                            'Dentist',
                            'Gynecologist',
                            'Dermatologist',
                            'Pediatrician',
                          ].map((specialty) {
                            return DropdownMenuItem(
                              value: specialty,
                              child: Text(specialty),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSpecialty = value == 'All' ? null : value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search by name",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: _currentLocation,
                      zoom: 10.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation!,
                            width: 40,
                            height: 40,
                            child: Icon(Icons.my_location, color: Colors.blue),
                          ),
                          ...filteredDoctors.map((doctor) {
                            return Marker(
                              point: doctor['location'],
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () => _getDirectionsAndETA(doctor['location']),
                                child: Tooltip(
                                  message: "${doctor['name']} (${doctor['specialty']})\nTap for ETA",
                                  child: Icon(Icons.location_on, color: Colors.red, size: 36),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      if (_routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              strokeWidth: 5.0,
                              color: Colors.green,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (_etaInfo != null)
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey.shade100,
                    child: Text(
                      _etaInfo!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
    );
  }
}
