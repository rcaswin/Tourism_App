import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class RoomListScreen extends StatefulWidget {
  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<Room> _rooms = [];
  List<Room> _filteredRooms = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _searchController.addListener(_filterRooms);
  }

  Future<void> _fetchRooms() async {
  try {
    final response = await rootBundle.loadString('assets/rooms.json');
    print(response); // Log the JSON data to verify its contents
    List<dynamic> data = json.decode(response);
    setState(() {
      _rooms = data.map((item) => Room.fromJson(item)).toList();
      _filteredRooms = _rooms;
    });
  } catch (e) {
    print('Error loading rooms: $e');
  }
}


  void _filterRooms() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRooms = _rooms.where((room) {
        return room.name.toLowerCase().contains(query) ||
            room.address.toLowerCase().contains(query);
      }).toList();
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
        title: Text('Rooms'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Image.asset(
          'assets/images/rooms/roombg.jpg',
          fit: BoxFit.cover,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by room name or place',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (_) => _filterRooms(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRooms.length,
              itemBuilder: (context, index) {
                Room room = _filteredRooms[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Image.asset(room.photos.first, width: 50, height: 50),
                      title: Text(room.name),
                      subtitle: Text(room.address),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailScreen(room: room),
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

class RoomDetailScreen extends StatelessWidget {
  final Room room;

  RoomDetailScreen({required this.room});

  
Future<void> _makePhoneCall(String phoneNumber) async {
  final String formattedPhoneNumber = 'tel:${phoneNumber.replaceAll(RegExp(r'[^\d]'), '')}';
  
  try {
    if (await canLaunch(formattedPhoneNumber)) {
      await launch(formattedPhoneNumber);
    } else {
      throw 'Could not launch $formattedPhoneNumber';
    }
  } catch (e) {
    print('Error launching phone call: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(room.description),
              SizedBox(height: 16),
              Text("Address: ${room.address}"),
              GestureDetector(
                onTap: () => _makePhoneCall('tel:${room.contactNumber}'),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "${room.contactNumber}",
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WebViewScreen(url: room.website);
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Website",
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
              Text("Checkin and Checkout: ${room.openingTime} - ${room.closingTime}"),
              SizedBox(height: 16),
              // Image Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: room.photos.map((photo) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return FullScreenImage(imageUrl: photo);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(photo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              // Small Map
              Container(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(room.latitude, room.longitude),
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
                          point: LatLng(room.latitude, room.longitude),
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
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
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.asset(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Website'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class Room {
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String contactNumber;
  final String website;
  final List<String> photos;
  final String openingTime;
  final String closingTime;

  Room({
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.website,
    required this.photos,
    required this.openingTime,
    required this.closingTime,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'] ?? 'No name available',
      description: json['description'] ?? 'No description available',
      address: json['address'] ?? 'No address available',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      contactNumber: json['contactNumber'] ?? 'No contact available',
      website: json['website'] ?? 'No website available',
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
      openingTime: json['openingTime'] ?? 'No opening time available',
      closingTime: json['closingTime'] ?? 'No closing time available',
    );
  }
}
