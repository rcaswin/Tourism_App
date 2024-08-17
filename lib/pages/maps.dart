import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'api.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

class CustomLocationData {
  final String name;
  final double latitude;
  final double longitude;

  CustomLocationData(this.name, this.latitude, this.longitude);
}

void main() => runApp(const MaterialApp(home: MapScreen()));

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CustomLocationData? userLocation;
  Location location = Location();
  List<CustomLocationData> locations = [];
  CustomLocationData? selectedLocation;
  List<LatLng> routeCoordinates = [];
  TextEditingController locationController = TextEditingController();
  String? distance;
  String? duration;

  @override
  void initState() {
    super.initState();

    _requestLocationPermission();

    _loadLocations();

    _startLocationUpdates();
  }

  void _requestLocationPermission() {
    location.requestPermission().then((PermissionStatus status) {
      if (status == PermissionStatus.granted) {
        _startLocationUpdates();
      } else {
        print('Location permission denied');
      }
    });
  }

  void _startLocationUpdates() {
    location.onLocationChanged.listen((LocationData? newLocation) {
      if (newLocation != null) {
        setState(() {
          userLocation = CustomLocationData(
            'Your Location',
            newLocation.latitude!,
            newLocation.longitude!,
          );
        });
      }
    });
  }

  Future<void> _loadLocations() async {
    final jsonContent = await rootBundle.loadString('assets/maps.json');
    final List<dynamic> jsonList = jsonDecode(jsonContent) as List<dynamic>;

    locations = jsonList
        .map((data) => CustomLocationData(data['name'] as String,
            data['latitude'].toDouble(), data['longitude'].toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialCenter = userLocation != null
        ? LatLng(userLocation!.latitude, userLocation!.longitude)
        : LatLng(8.4021946, 77.39561);
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              zoom: 9,
              center: initialCenter,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: '',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routeCoordinates,
                    gradientColors: [
                      const Color.fromARGB(255, 157, 52, 250),
                      const Color.fromARGB(255, 85, 98, 250),
                    ],
                    strokeWidth: 4,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      userLocation?.latitude ?? 0,
                      userLocation?.longitude ?? 0,
                    ),
                    width: 50,
                    height: 50,
                    builder: (context) => ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 157, 52, 250),
                            Color.fromARGB(255, 85, 98, 250),
                          ],
                        ).createShader(const Rect.fromLTWH(0, 0, 45, 45));
                      },
                      child: const Icon(
                        Ionicons.radio_button_on,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (selectedLocation != null)
                    Marker(
                      point: LatLng(
                        selectedLocation!.latitude,
                        selectedLocation!.longitude,
                      ),
                      width: 50,
                      height: 50,
                      builder: (context) => ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 157, 52, 250),
                              Color.fromARGB(255, 85, 98, 250),
                            ],
                          ).createShader(const Rect.fromLTWH(0, 0, 45, 45));
                        },
                        child: const Icon(
                          Ionicons.radio_button_on,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: ResponsivePadding.fromLTRB(context, 6, 10, 6, 6),
              child: Container(
                  margin: ResponsiveMargin.fromLTRB(context, 7, 16, 7, 7),
                  padding: ResponsivePadding.fromLTRB(context, 3, 6, 3, 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 32, 100, 231)
                            .withOpacity(0.1),
                        spreadRadius: 6,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TypeAheadField<CustomLocationData>(
                    textFieldConfiguration: TextFieldConfiguration(
                      style: GoogleFonts.imprima(
                        fontSize: TextSizeScaler.scaleTextSize(context, 16),
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search Places',
                        prefixIcon: Icon(
                          Ionicons.search,
                          color: Color.fromARGB(255, 32, 100, 231),
                          size: 24,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: locationController,
                    ),
                    suggestionsCallback: (pattern) async {
                      return _getPlaceSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.name,
                          style: GoogleFonts.imprima(
                            fontSize: TextSizeScaler.scaleTextSize(context, 14),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _selectLocation(suggestion);
                    },
                  )),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: selectedLocation != null ? 80 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 32, 100, 231)
                        .withOpacity(0.1),
                    spreadRadius: 6,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Distance: ',
                            style: GoogleFonts.imprima(
                              fontSize:
                                  TextSizeScaler.scaleTextSize(context, 14),
                              color: const Color.fromARGB(255, 157, 52, 250),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: '$distance kms',
                            style: GoogleFonts.imprima(
                              fontSize:
                                  TextSizeScaler.scaleTextSize(context, 14),
                              color: const Color.fromARGB(255, 85, 98, 250),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Duration: ',
                            style: GoogleFonts.imprima(
                              fontSize:
                                  TextSizeScaler.scaleTextSize(context, 14),
                              color: const Color.fromARGB(255, 157, 52, 250),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: '$duration min',
                            style: GoogleFonts.imprima(
                              fontSize:
                                  TextSizeScaler.scaleTextSize(context, 14),
                              color: const Color.fromARGB(255, 85, 98, 250),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Future<List<CustomLocationData>> _getPlaceSuggestions(String pattern) async {
    final filteredLocations = locations
        .where((location) =>
            location.name.toLowerCase().contains(pattern.toLowerCase()))
        .toList();

    return filteredLocations.take(5).toList();
  }

  void _selectLocation(CustomLocationData suggestion) {
    setState(() {
      selectedLocation = suggestion;
      _calculateAndDrawRoute();
      locationController.text = suggestion.name;
    });
  }

  Future<Map<String, double>?> _fetchDistanceAndDuration(
      String startPoint, String endPoint) async {
    final routeUrl = getRouteUrl(startPoint, endPoint);

    try {
      final response = await http.get(routeUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double distance =
            data['features'][0]['properties']['segments'][0]['distance'];
        final double duration =
            data['features'][0]['properties']['segments'][0]['duration'];

        return {'distance': distance / 1000, 'duration': duration / 60};
      } else {
        print('Failed to fetch route: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void _calculateAndDrawRoute() async {
    if (userLocation != null && selectedLocation != null) {
      final startPoint = '${userLocation!.longitude},${userLocation!.latitude}';
      final endPoint =
          '${selectedLocation!.longitude},${selectedLocation!.latitude}';
      final routeUrl = getRouteUrl(startPoint, endPoint);

      try {
        final response = await http.get(routeUrl);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> geometry =
              data['features'][0]['geometry']['coordinates'];

          final List<LatLng> coordinates = geometry.map((coord) {
            final List<dynamic> c = coord;
            return LatLng(c[1], c[0]);
          }).toList();

          final info = await _fetchDistanceAndDuration(startPoint, endPoint);

          setState(() {
            routeCoordinates = coordinates;
            if (info != null) {
              distance = info['distance']?.toStringAsFixed(0);
              duration = info['duration']?.toStringAsFixed(0);
            }
          });
        } else {
          print('Failed to fetch route: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }
}
