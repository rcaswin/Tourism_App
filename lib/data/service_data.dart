// service_data.dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/pages/updatesoonpage.dart';
import 'package:trip_to_kumari/services/helplines.dart';
import 'package:trip_to_kumari/pages/hospital_list_screen.dart';
import 'package:trip_to_kumari/pages/RoomListScreen.dart';
import 'package:trip_to_kumari/pages/RestaurantListScreen.dart';
import 'package:trip_to_kumari/pages/ATMListPage.dart';

class Service {
  final IconData icon;
  final String title;
  final Widget path;

  Service({required this.icon, required this.title, required this.path});
}

List<Service> services = [
  Service(icon: Ionicons.call_outline, title: "Helplines", path: Helplines()),
  Service(icon: Ionicons.bed_outline, title: "Rooms", path: RoomListScreen()),
  Service(icon: Ionicons.pulse_outline, title: "Hospitals", path: HospitalListScreen()),
  Service(icon: Ionicons.restaurant_outline, title: "Restaurant", path: RestaurantListScreen()),
  Service(icon: Ionicons.wallet_outline, title: "ATM", path: ATMListScreen()),
  Service(icon: Ionicons.cart_outline, title: "Shop", path: UpdateSoonPage()),
];
