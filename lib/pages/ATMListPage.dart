import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class ATMListScreen extends StatefulWidget {
  @override
  _ATMListScreenState createState() => _ATMListScreenState();
}

class _ATMListScreenState extends State<ATMListScreen> {
  List<ATM> _atms = [];
  List<ATM> _filteredATMs = [];
  LocationData? _currentLocation;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchATMs();
    _fetchCurrentLocation();
    _searchController.addListener(_filterATMs);
  }

  Future<void> _fetchATMs() async {
    try {
      final response = await rootBundle.loadString('assets/atm_list.json');
      List<dynamic> data = json.decode(response);
      setState(() {
        _atms = data.map((item) => ATM.fromJson(item)).toList();
        _filteredATMs = _atms;
      });
    } catch (e) {
      print('Error loading ATMs: $e');
    }
  }

  Future<void> _fetchCurrentLocation() async {
    var location = Location();
    try {
      _currentLocation = await location.getLocation();
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  void _filterATMs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredATMs = _atms.where((atm) =>
          atm.name.toLowerCase().contains(query) ||
          atm.address.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATM Locations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ATM name or place',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (_) => _filterATMs(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredATMs.length,
              itemBuilder: (context, index) {
                ATM atm = _filteredATMs[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(atm.name),
                      subtitle: Text(atm.address),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ATMDetailScreen(
                              atm: atm,
                              currentLocation: _currentLocation,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ATMDetailScreen extends StatelessWidget {
  final ATM atm;
  final LocationData? currentLocation;

  ATMDetailScreen({required this.atm, required this.currentLocation});

  Future<void> _launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(atm.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blue[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(atm.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Text(atm.address),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () => _launchPhone(atm.contact),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text(
                          atm.contact,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(atm.latitude, atm.longitude),
                zoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(atm.latitude, atm.longitude),
                      builder: (ctx) => Container(
                        child: Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(height: 5.0),
                            Text(
                              atm.name,
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (currentLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                        builder: (ctx) => Container(
                          child: Column(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue),
                            SizedBox(height: 5.0),
                            Text(
                              "Me",
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ATM {
  final String name;
  final String address;
  final String contact;
  final double latitude;
  final double longitude;

  ATM({
    required this.name,
    required this.address,
    required this.contact,
    required this.latitude,
    required this.longitude,
  });

  factory ATM.fromJson(Map<String, dynamic> json) {
    return ATM(
      name: json['name'],
      address: json['address'],
      contact: json['contact'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
