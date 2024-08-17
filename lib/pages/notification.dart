import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Map<String, dynamic> jsonData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://nflipbk.com/kkapp/notify.json'));
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          iconSize: 25,
                          color: Colors.black,
                          icon: const Icon(Ionicons.chevron_back),
                        ),
                        Text(
                          "News & Events",
                          style: GoogleFonts.imprima(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Latest News",
                    style: GoogleFonts.imprima(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 32, 100, 231),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buildListView(jsonData['new'], 250),
                  const SizedBox(height: 10),
                  Text(
                    "Old News",
                    style: GoogleFonts.imprima(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 32, 100, 231),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  buildListView(jsonData['old'], 400),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget buildListView(List<dynamic> items, double height) {
    return Container(
      height: height,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(), // Use ClampingScrollPhysics
        itemCount: items.length,
        itemBuilder: (context, index) {
          return buildListItem(items[index]);
        },
      ),
    );
  }

  Widget buildListItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 128, 172, 255).withOpacity(0.1),
            spreadRadius: 6,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date: ${item['date']}',
            style: GoogleFonts.imprima(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${item['title']}',
            style: GoogleFonts.imprima(
              fontSize: 16,
              color: const Color.fromARGB(255, 49, 49, 49),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${item['description']}',
            style: GoogleFonts.imprima(
              fontSize: 15,
              color: const Color.fromARGB(255, 49, 49, 49),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
